port module Main exposing (main)

import Url
import Browser.Navigation
import Browser
import Browser.Events as BE
import Element as El
import Element.Events as EE
import Element.Font as Font
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Svg
import Svg.Attributes as SA
import Svg.Events as SE
import Html
import Html.Attributes as HA
import Json.Decode as JD
import Json.Encode as JE
import Json.Decode.Extra as JDE
import String.Interpolate as SI
import Parser as P
import Parser exposing ((|=), (|.))

import Debug


-- *** Interop ***

port saveFile : JE.Value -> Cmd msg
port loadFile : JE.Value -> Cmd msg
port viewPortHasResized : (JE.Value -> msg) -> Sub msg
port fileHasBeenRead : (JE.Value -> msg) -> Sub msg


-- *** Constants ***

zoomStepSize = 0.1
defaultTextWidth = 7
defaultTextHeight = 12
versionCanonicalFormat = "2019-12-19"


-- *** Application model ***

type alias Flags = {}

type Msg
  = NoOp
  | SaveSchematic
  | LoadSchematic
  | AddRect
  | AddEllipse
  | AddArrow
  | AddText
  | UpdateItemName CanvasItemInstance String
  | UpdateSourcePinName CanvasItemInstance String
  | UpdateSinkPinName CanvasItemInstance String
  | UpdateItemGitUrl CanvasItemInstance String
  | UpdateItemGitRef CanvasItemInstance String
  | UpdateItemContextDir CanvasItemInstance String
  | UpdateItemManifestPath CanvasItemInstance String
  | UserIsTyping CanvasItemInstance
  | UserIsNotTyping CanvasItemInstance
  | MouseMove Coordinates
  | KeyPress String
  | KeyUp String
  | SelectItem CanvasItemInstance
  | ResizeItem CanvasItemInstance Coordinates AnchorPosition
  | HoveredItem CanvasItemInstance
  | DoubleClick (Maybe CanvasItemInstance)
  | MovePath CanvasItemInstance Int Coordinates
  | UnhoveredItem
  | ClearSelection
  | MouseDown Coordinates
  | MouseUp Coordinates
  | ViewPortHasResized (Result JD.Error (Int, Int))
  | FileHasBeenRead (Result JD.Error File)

type SelectionMode = SingleSelect | MultipleSelect

type alias Model =
  { cursorCoords : Coordinates
  , instantiatedItems : List CanvasItemInstance
  , selectedItems : List CanvasItemInstance
  , itemsUnderCursor : List CanvasItemInstance
  -- Out of the items under cursor, only one item (or none) can be selected.
  , currentItemUnderCursor : Maybe CanvasItemInstance
  , cursorMode : CursorMode
  , intent : Intent
  , selectionMode : SelectionMode
  , hoveredItem : Maybe CanvasItemInstance
  , zoomFactor : Float
  , panCoords : Coordinates
  , viewPortSize : (Int, Int)
  }

type alias File =
  { moduleName : String
  , canvasItems : List CanvasItemInstance
  }

encodeFile : File -> JE.Value
encodeFile file =
  JE.object
    [ ( "version", JE.string versionCanonicalFormat )
    , ( "moduleName", JE.string file.moduleName )
    , ( "canvasItems", JE.list encodeCanvasItemInstance file.canvasItems )
    ]

encodeCanvasItemInstance : CanvasItemInstance -> JE.Value
encodeCanvasItemInstance canvasItem =
  JE.object
    [ ( "id", JE.int canvasItem.id )
    , ( "item", encodeCanvasItem canvasItem.item )
    , ( "kindName", JE.string canvasItem.name )
    , ( "gitUrl", JE.string canvasItem.gitUrl )
    , ( "gitRef", JE.string canvasItem.gitRef )
    , ( "contextDir", JE.string canvasItem.contextDir )
    , ( "manifestPath", JE.string canvasItem.manifestPath )
    , ( "sourcePinName", JE.string canvasItem.sourcePinName )
    , ( "sinkPinName", JE.string canvasItem.sinkPinName )
    ]

encodeCanvasItem : CanvasItem -> JE.Value
encodeCanvasItem canvasItem =
  case canvasItem of
    Rect topLeft bottomRight ->
      JE.object
        [ ( "tag", JE.string "Rect" )
        , ( "topLeft", encodeCoordinates topLeft )
        , ( "bottomRight", encodeCoordinates bottomRight )
        ]
    Polyline points ->
      JE.object
        [ ( "tag", JE.string "Polyline" )
        , ( "points", JE.list encodeCoordinates points )
        ]
    Ellipse topLeft bottomRight ->
      JE.object
        [ ( "tag", JE.string "Ellipse" )
        , ( "topLeft", encodeCoordinates topLeft )
        , ( "bottomRight", encodeCoordinates bottomRight )
        ]
    Text topLeft bottomRight text ->
      JE.object
        [ ( "tag", JE.string "Text" )
        , ( "topLeft", encodeCoordinates topLeft )
        , ( "bottomRight", encodeCoordinates bottomRight )
        , ( "text", JE.string text )
        ]

encodeCoordinates : Coordinates -> JE.Value
encodeCoordinates coords =
  JE.object
    [ ( "x", JE.int coords.x )
    , ( "y", JE.int coords.y )
    ]

fileDecoder : JD.Decoder File
fileDecoder =
  JD.field "version" JD.string
    |> JD.andThen fileDecoderSwitch

fileDecoderSwitch : String -> JD.Decoder File
fileDecoderSwitch version =
  case version of
    "2019-12-19" ->
      JD.map2 File
        (JD.field "moduleName" JD.string)
        (JD.field "canvasItems" (JD.list canvasItemInstanceDecoder))
    _ ->
      JD.fail <| "Unknown version: " ++ version

canvasItemInstanceDecoder : JD.Decoder CanvasItemInstance
canvasItemInstanceDecoder =
  JD.succeed CanvasItemInstance
    |> JDE.andMap (JD.field "id" JD.int)
    |> JDE.andMap (JD.field "item" canvasItemDecoder)
    |> JDE.andMap (JD.field "kindName" JD.string)
    |> JDE.andMap (JD.field "gitUrl" JD.string)
    |> JDE.andMap (JD.field "gitRef" JD.string)
    |> JDE.andMap (JD.field "contextDir" JD.string)
    |> JDE.andMap (JD.field "manifestPath" JD.string)
    |> JDE.andMap (JD.field "sourcePinName" JD.string)
    |> JDE.andMap (JD.field "sinkPinName" JD.string)

canvasItemDecoder : JD.Decoder CanvasItem
canvasItemDecoder =
  JD.field "tag" JD.string
    |> JD.andThen canvasItemContent

canvasItemContent : String -> JD.Decoder CanvasItem
canvasItemContent contentType =
  case contentType of
    "Rect" ->
      JD.map2 Rect
        (JD.field "topLeft" coordinatesDecoder)
        (JD.field "bottomRight" coordinatesDecoder)
    "Polyline" ->
      JD.field "points" <|
        JD.map Polyline (JD.list coordinatesDecoder)
    "Ellipse" ->
      JD.map2 Ellipse
        (JD.field "topLeft" coordinatesDecoder)
        (JD.field "bottomRight" coordinatesDecoder)
    "Text" ->
      JD.map3 Text
        (JD.field "topLeft" coordinatesDecoder)
        (JD.field "bottomRight" coordinatesDecoder)
        (JD.field "text" JD.string)
    _ ->
      JD.fail "Unrecognized canvas item content"

coordinatesDecoder : JD.Decoder Coordinates
coordinatesDecoder = JD.map2 Coordinates (JD.field "x" JD.int) (JD.field "y" JD.int)

type alias Coordinates = { x : Int, y : Int }
type alias BoundingBoxCoordinates = (Coordinates, Coordinates)

-- This captures the state of some task that the user wants to
-- do in multiple steps.
type Intent
  -- Default state: Moving the mouse around
  = ToExplore
  | ToMoveSelectedCanvasItemInstances
  | ToResizeCanvasItemInstance CanvasItemInstance Coordinates AnchorPosition
  | ToCreateCanvasItemInstance CanvasItemInstance
  | ToMovePath CanvasItemInstance Int Coordinates
  -- The first parameter is the next point to be drawn and the second parameter
  -- is the rest of the points from which to draw the polyline.
  | ToCreatePolyline Coordinates (List Coordinates)
  -- Parameters are the starting pan coordinates and starting cursor
  -- coordinates.
  | ToPanViewBox Coordinates Coordinates
  -- When the user is typing text to a particular item
  | ToType CanvasItemInstance

type CursorMode
  = FreeFormCursor
  -- Parameter is the starting coordinates
  | DragCursor Coordinates
  -- This is needed to deal with all the events being fired
  -- when the user triggers a mousedown event.
  | SelectionInProgress

type alias CanvasItemId = Int

-- These are the items actually displayed on the canvas.
type alias CanvasItemInstance =
  { id : CanvasItemId
  -- TODO: Rename CanvasItem to Shape
  , item : CanvasItem
  -- TODO: Refactor the following into Element since it's disjoint.
  , name : String -- Part and Pin
  , gitUrl : String -- Part only
  , gitRef : String -- Part only
  , contextDir : String -- Part only
  , manifestPath : String -- Part only
  , sourcePinName : String -- Wire only
  , sinkPinName : String -- Wire only
  }

-- These are the elements that can be displayed on the canvas.
type CanvasItem
  -- A rectangle is defined by the upper-left and the lower-right coordinates.
  = Rect Coordinates Coordinates
  | Polyline (List Coordinates)
  -- Ellipse is constructed using the upper-left and the lower-right corners of
  -- the bounding box of the ellipse.
  | Ellipse Coordinates Coordinates
  -- A text is defined by upper-left corner, lower-right corner, and the text
  -- to display.
  | Text Coordinates Coordinates String

type AnchorPosition
  = UpperLeft
  | UpperRight
  | LowerLeft
  | LowerRight

type Fact
  = Single String
  | Double String String
  | Triple String String String


-- *** Application logic ***

factToProlog : Fact -> String
factToProlog fact =
  case fact of
    Single x -> SI.interpolate "{0}()." [x]
    Double x y -> SI.interpolate "{0}({1})." [x, y]
    Triple x y z -> SI.interpolate "{0}({1}, {2})." [x, y, z]

factToLisp : Fact -> String
factToLisp fact =
  case fact of
    Single x -> SI.interpolate "({0})" [x]
    Double x y -> SI.interpolate "({0} {1})" [x, y]
    Triple x y z -> SI.interpolate "({0} {1} {2})" [x, y, z]

serializeFacts : (Fact -> String) -> List Fact -> String
serializeFacts serializer facts = List.map serializer facts |> String.join "\n"

initialModel : Model
initialModel =
  { cursorCoords = { x = 0, y = 0 }
  , instantiatedItems = []
  , selectedItems = []
  , itemsUnderCursor = []
  , currentItemUnderCursor = Nothing
  , cursorMode = FreeFormCursor
  , intent = ToExplore
  , selectionMode = SingleSelect
  , hoveredItem = Nothing
  , zoomFactor = 1.0
  , panCoords = { x = 0, y = 0 }
  , viewPortSize = (1000, 1000)
  }

calculateActualCoords : Model -> Coordinates -> Coordinates
calculateActualCoords model coords =
  { x = (toFloat coords.x * model.zoomFactor |> round) + model.panCoords.x
  , y = (toFloat coords.y * model.zoomFactor |> round) + model.panCoords.y
  }

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    NoOp -> updateModelOnly model
    SaveSchematic ->
      let
        -- In the future, get the component name from somewhere.
        componentName = "default-component-name"
        encodedFile =
          encodeFile
            { moduleName = componentName
            , canvasItems = model.instantiatedItems
            }
      in
        (model, saveFile encodedFile)
    LoadSchematic -> (model, loadFile (JE.null))
    AddRect ->
      (createNewCanvasItemInstance model (Rect { x = 100, y = 100 } { x = 200, y = 200 }), Cmd.none)
    AddArrow ->
      case model.intent of
        ToCreatePolyline _ points -> updateModelOnly <| addArrow model points
        _ ->
          ({ model | intent = ToCreatePolyline model.cursorCoords [] }, Cmd.none)
    AddEllipse ->
      (createNewCanvasItemInstance model (Ellipse { x = 100, y = 100 } { x = 300, y = 250 }), Cmd.none)
    AddText ->
      (createNewCanvasItemInstance model (Text { x = 100, y = 100 } { x = 200, y = 200 } "text"), Cmd.none)
    UpdateItemName item newName ->
      let
        updateName i = { i | name = newName }
      in
        (updateCanvasItemInstance model item updateName, Cmd.none)
    UpdateItemGitUrl item newGitUrl ->
      let
        updateGitUrl i = { i | gitUrl = newGitUrl }
      in
        (updateCanvasItemInstance model item updateGitUrl, Cmd.none)
    UpdateItemGitRef item newGitRef ->
      let
        updateGitRef i = { i | gitRef = newGitRef }
      in
        (updateCanvasItemInstance model item updateGitRef, Cmd.none)
    UpdateItemContextDir item newContextDir ->
      let
        updateContextDir i = { i | contextDir = newContextDir }
      in
        (updateCanvasItemInstance model item updateContextDir, Cmd.none)
    UpdateItemManifestPath item newManifestPath ->
      let
        updateManifestPath i = { i | manifestPath = newManifestPath }
      in
        (updateCanvasItemInstance model item updateManifestPath, Cmd.none)
    UpdateSourcePinName item newName ->
      let
        updateSourcePinName i = { i | sourcePinName = newName }
      in
        (updateCanvasItemInstance model item updateSourcePinName, Cmd.none)
    UpdateSinkPinName item newName ->
      let
        updateSinkPinName i = { i | sinkPinName = newName }
      in
        (updateCanvasItemInstance model item updateSinkPinName, Cmd.none)
    UserIsTyping item -> updateModelOnly { model | intent = ToType item }
    UserIsNotTyping item -> updateModelOnly { model | intent = ToExplore }
    MouseMove coords ->
      let
        updatedModel = { model | cursorCoords = coords }
        newModel =
          case (updatedModel.cursorMode, updatedModel.intent) of
            -- Moving paths is handled differently than the rest because it
            -- doesn't have an anchor point.
            (_, ToMovePath { id, item } index point) ->
              case item of
                Polyline points ->
                  let
                    updatePoint i pt = if i == index then calculateActualCoords model coords else pt
                    newPoints = List.indexedMap updatePoint points
                    updatedItems = replaceCanvasItemInstanceById updatedModel.instantiatedItems id (Polyline newPoints)
                  in
                    { updatedModel | instantiatedItems = updatedItems }
                _ -> updatedModel
            (_, ToResizeCanvasItemInstance { id, item } startingCoords anchor) ->
              let
                newItem = resizeCanvasItem model.zoomFactor item startingCoords updatedModel.cursorCoords anchor
                updatedItems = replaceCanvasItemInstanceById updatedModel.instantiatedItems id newItem
              in
                { updatedModel
                | instantiatedItems = updatedItems
                -- Resizing means we're not selecting anything.
                , selectedItems = []
                }
            (_, ToPanViewBox startingPanCoords startingCoords) ->
              { updatedModel
              | panCoords =
                  { x = startingPanCoords.x - (coords.x - startingCoords.x)
                  , y = startingPanCoords.y - (coords.y - startingCoords.y)
                  }
              }
            (_, ToCreatePolyline _ points) ->
              { updatedModel
              | intent = ToCreatePolyline (getCursorDropPointCoords updatedModel.instantiatedItems coords) points
              }
            _ -> updatedModel
      in
        updateModelOnly newModel
    KeyPress key ->
      case model.intent of
        ToType _ -> updateModelOnly model
        _ -> handleKeyDown model key
    KeyUp key ->
      case model.intent of
        ToType _ -> updateModelOnly model
        _ -> (handleKeyUp model key |> updateModelOnly)
    SelectItem item ->
      case model.selectionMode of
        SingleSelect ->
          updateModelOnly
            { model
            | selectedItems = [item]
            , cursorMode = SelectionInProgress
            }
        MultipleSelect ->
          let
            selected =
              if isSelectedCanvasItemInstance model item
              then model.selectedItems
              else item :: model.selectedItems
            newSelectionMode =
              if List.length selected == 0
              then SingleSelect
              else model.selectionMode
          in
            updateModelOnly
              { model
              | selectedItems = selected
              , selectionMode = newSelectionMode
              , cursorMode = SelectionInProgress
              }
    ResizeItem item startingCursorCoords anchor ->
      updateModelOnly
        { model
        | intent = ToResizeCanvasItemInstance item startingCursorCoords anchor
        }
    HoveredItem item -> updateModelOnly { model | hoveredItem = Just item }
    UnhoveredItem -> updateModelOnly { model | hoveredItem = Nothing }
    DoubleClick item ->
      case (model.intent, item) of
        (ToCreatePolyline _ points, _) -> updateModelOnly <| addArrow model (List.take (List.length points - 1) points)
        (_, Just i) ->
          case i.item of
            (Text _ _ _) -> updateModelOnly { model | intent = ToType i }
            (Polyline _) -> updateModelOnly <| updateCanvasItemInstance model i (addPointToPolyline model.cursorCoords)
            _ -> (model, Cmd.none)
        _ -> (model, Cmd.none)
    MovePath path index point ->  updateModelOnly { model | intent = ToMovePath path index point }
    ClearSelection ->
      case model.cursorMode of
        SelectionInProgress -> (model, Cmd.none)
        _ ->
          updateModelOnly
            { model
            | selectedItems = []
            , selectionMode = SingleSelect
            }
    MouseDown coords ->
      case (model.cursorMode, model.intent, model.selectedItems) of
        (_, ToCreatePolyline dropPoint points, _) ->
          -- TODO: Next point should create angular lines
          ( { model | intent = ToCreatePolyline dropPoint (points ++ [calculateActualCoords model dropPoint]) }, Cmd.none )
        (_, ToMovePath _ _ _, _) ->
          (model, Cmd.none)
        -- The user wants to pan if there is no selected items.
        (_, _, []) ->
          updateModelOnly
            { model | intent = ToPanViewBox model.panCoords model.cursorCoords }
        _ ->
          updateModelOnly
            { model | cursorMode = DragCursor coords }
    MouseUp coords ->
      case (model.cursorMode, model.intent) of
        (_, ToMovePath _ _ _) ->
          updateModelOnly { model | intent = ToExplore }
        (_, ToResizeCanvasItemInstance _ _ _) ->
          updateModelOnly { model | intent = ToExplore }
        (_, ToPanViewBox _ _) ->
          updateModelOnly { model | intent = ToExplore }
        (DragCursor starting, ToCreateCanvasItemInstance item) ->
          updateModelOnly
            { model
            | instantiatedItems = item :: model.instantiatedItems
            }
        (DragCursor starting, _) ->
          let
            updatedModel = updateSelectedItemCoordinates model starting coords
          in
            updateModelOnly { updatedModel | cursorMode = FreeFormCursor }
        _ -> updateModelOnly { model | cursorMode = FreeFormCursor }
    ViewPortHasResized result ->
      case result of
        Ok (width, height) -> updateModelOnly { model | viewPortSize = (width, height) }
        _ -> updateModelOnly model
    FileHasBeenRead result ->
      case result of
        Ok content -> updateModelOnly { model | instantiatedItems = content.canvasItems }
        e ->
          let
            x = Debug.log "Error loading file: " e
          in
            updateModelOnly model

addArrow : Model -> List Coordinates -> Model
addArrow model points =
  let
    model2 = createNewCanvasItemInstance model <| Polyline points
  in
    { model2 | intent = ToExplore }

addPointToPolyline : Coordinates -> CanvasItemInstance -> CanvasItemInstance
addPointToPolyline cursor item =
  case item.item of
    Polyline points -> { item | item = Polyline (List.append points [cursor]) }
    _ -> item

-- We convert to float because of legacy reason with the compiler.
fromInt x = String.fromInt x ++ ".0"
fromFloat x = String.fromInt (round x) ++ ".0"

zoom : Model -> Float -> (Model, Cmd Msg)
zoom model zoomBy = ({ model | zoomFactor = model.zoomFactor * zoomBy }, Cmd.none)

handleKeyDown : Model -> String -> (Model, Cmd Msg)
handleKeyDown model key =
  let
    defaultCmd = Cmd.none
  in
    case key of
      -- Multiple select
      "Shift" -> ({ model | selectionMode = MultipleSelect }, defaultCmd)
      -- Delete
      "Backspace" -> (deleteSelectedCanvasItemInstances model, defaultCmd)
      -- Copy
      "c" -> (copySelectedCanvasItemInstances model, defaultCmd)
      -- Zoom in
      "=" -> zoom model (1.0 - zoomStepSize)
      "+" -> zoom model (1.0 - zoomStepSize)
      -- Zoom out
      "-" -> zoom model (1.0 + zoomStepSize)
      -- No-op
      _ -> (model, defaultCmd)

handleKeyUp : Model -> String -> Model
handleKeyUp model key = model

createNewCanvasItemInstance : Model -> CanvasItem -> Model
createNewCanvasItemInstance model canvasItem =
  let
    newItem =
      copyCanvasItemInstance model
        { id = -1
        , item = canvasItem
        , name = ""
        , gitUrl = ""
        , gitRef = ""
        , contextDir = ""
        , manifestPath = ""
        , sourcePinName = ""
        , sinkPinName = ""
        }
  in
    { model | instantiatedItems = newItem :: model.instantiatedItems }

createNewCanvasItemInstance2 : CanvasItem -> Model -> Model
createNewCanvasItemInstance2 item model = createNewCanvasItemInstance model item

deleteSelectedCanvasItemInstances : Model -> Model
deleteSelectedCanvasItemInstances model =
  { model
      | instantiatedItems = List.filter (\x -> not (List.member x model.selectedItems)) model.instantiatedItems
      , selectedItems = []
  }

copySelectedCanvasItemInstances : Model -> Model
copySelectedCanvasItemInstances model =
  let
    copiedItems = List.foldl (foldCopy model) [] model.selectedItems
    move instance = { instance | item = moveItem 20 20 instance.item }
    newItems = List.map move copiedItems
  in
    { model
        | instantiatedItems = List.append newItems model.instantiatedItems
        , selectedItems = newItems
    }

moveItem : Int -> Int -> CanvasItem -> CanvasItem
moveItem deltaX deltaY item =
  let
    move = moveCoordinates deltaX deltaY
  in
    case item of
      Rect upperLeft lowerRight ->
        Rect (move upperLeft) (move lowerRight)
      Polyline points ->
        Polyline <| List.map move points
      Ellipse upperLeft lowerRight ->
        Ellipse (move upperLeft) (move lowerRight)
      Text upperLeft lowerRight label ->
        Text (move upperLeft) (move lowerRight) label

moveCoordinates : Int -> Int -> Coordinates -> Coordinates
moveCoordinates deltaX deltaY coords =
  { coords | x = coords.x + deltaX, y = coords.y + deltaY }

foldCopy : Model -> CanvasItemInstance -> List CanvasItemInstance -> List CanvasItemInstance
foldCopy model item newItems =
  let
    newItem = copyCanvasItemInstance model item
  in
    (newItem :: newItems)

findLargestId : List CanvasItemInstance -> Int
findLargestId = List.map .id >> List.maximum >> Maybe.withDefault 0

copyCanvasItemInstance : Model -> CanvasItemInstance -> CanvasItemInstance
copyCanvasItemInstance model canvasItem =
  let
    newId = findLargestId model.instantiatedItems + 1
  in
    { canvasItem | id = newId }

updateModelOnly : Model -> (Model, Cmd Msg)
updateModelOnly model = (model, Cmd.none)

isSelectedCanvasItemInstance : Model -> CanvasItemInstance -> Bool
isSelectedCanvasItemInstance model match = List.any (\i -> i.id == match.id) model.selectedItems

updateCanvasItemInstance : Model -> CanvasItemInstance -> (CanvasItemInstance -> CanvasItemInstance) -> Model
updateCanvasItemInstance model target f =
  let
    process item =
      if item.id == target.id
      then f item
      else item
  in
    { model
        | instantiatedItems = List.map process model.instantiatedItems
        , selectedItems = List.map process model.selectedItems
    }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ BE.onMouseDown (JD.map MouseDown mouseDecoder)
    , BE.onMouseUp (JD.map MouseUp mouseDecoder)
    , BE.onMouseMove (JD.map MouseMove mouseDecoder)
    , BE.onKeyDown (JD.map KeyPress keyDecoder)
    , BE.onKeyUp (JD.map KeyUp keyDecoder)
    , viewPortHasResized (JD.decodeValue viewPortDecoder >> ViewPortHasResized)
    , fileHasBeenRead (JD.decodeValue fileDecoder >> FileHasBeenRead)
    ]

viewPortDecoder : JD.Decoder (Int, Int)
viewPortDecoder =
  JD.map2 Tuple.pair
    (JD.index 0 JD.int)
    (JD.index 1 JD.int)

mouseDecoder : JD.Decoder Coordinates
mouseDecoder =
  JD.map2 Coordinates
    (JD.at [ "offsetX" ] JD.int)
    (JD.at [ "offsetY" ] JD.int)

keyDecoder : JD.Decoder String
keyDecoder = JD.field "key" JD.string

updateItemCoordinates : Float -> Coordinates -> Coordinates -> CanvasItemInstance -> CanvasItemInstance
updateItemCoordinates zoomFactor starting ending canvasItem =
  let
    dx = toFloat (ending.x - starting.x) * zoomFactor |> round
    dy = toFloat (ending.y - starting.y) * zoomFactor |> round
    move = moveCoordinates dx dy
    item =
      case canvasItem.item of
        Rect upperLeft lowerRight ->
          Rect (move upperLeft) (move lowerRight)
        Polyline points ->
          Polyline (List.map move points)
        Ellipse upperLeft lowerRight ->
          Ellipse (move upperLeft) (move lowerRight)
        Text upperLeft lowerRight label ->
          Text (move upperLeft) (move lowerRight) label
  in
    { canvasItem | item = item }

updateSelectedItemCoordinates : Model -> Coordinates -> Coordinates -> Model
updateSelectedItemCoordinates model starting ending =
  let
    updateCoordinates = updateItemCoordinates model.zoomFactor starting ending
    process item =
      if isSelectedCanvasItemInstance model item
      then
        let updatedItem = updateCoordinates item
        in  (updatedItem, Just updatedItem)
      else (item, Nothing)
    (updatedItems, selectedItemMaybes) =
      List.map process model.instantiatedItems |> List.unzip
    selectedItems = List.filterMap identity selectedItemMaybes
  in
    { model | instantiatedItems = updatedItems, selectedItems = selectedItems }

resizeCanvasItem : Float -> CanvasItem -> Coordinates -> Coordinates -> AnchorPosition -> CanvasItem
resizeCanvasItem zoomFactor originalItem startingCoords currentCoords anchor =
  let
    deltaX = toFloat (currentCoords.x - startingCoords.x) * zoomFactor |> round
    deltaY = toFloat (currentCoords.y - startingCoords.y) * zoomFactor |> round
    threshold = 25
  in
    case originalItem of
      Rect upperLeft lowerRight ->
        case anchor of
          UpperLeft ->
            Rect
              { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
              , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
              }
              lowerRight
          UpperRight ->
            Rect
              { x = upperLeft.x
              , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
              }
              { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
              , y = lowerRight.y
              }
          LowerLeft ->
            Rect
              { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
              , y = upperLeft.y
              }
              { x = lowerRight.x
              , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
              }
          LowerRight ->
            Rect
              upperLeft
              { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
              , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
              }
      Ellipse upperLeft lowerRight ->
        let
          (newUpperLeft, newLowerRight) =
            case anchor of
              UpperLeft ->
                ( { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
                  , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
                  }
                , lowerRight
                )
              UpperRight ->
                ( { x = upperLeft.x
                  , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
                  }
                , { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
                  , y = lowerRight.y
                  }
                )
              LowerLeft ->
                ( { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
                  , y = upperLeft.y
                  }
                , { x = lowerRight.x
                  , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
                  }
                )
              LowerRight ->
                ( upperLeft
                , { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
                  , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
                  }
                )
        in
          Ellipse newUpperLeft newLowerRight
      _ -> originalItem

boundingBoxToEllipse : Coordinates -> Coordinates -> (Coordinates, Int, Int)
boundingBoxToEllipse upperLeft lowerRight =
  let
    radiusX = (lowerRight.x - upperLeft.x) // 2
    radiusY = (lowerRight.y - upperLeft.y) // 2
    centerX = upperLeft.x + radiusX
    centerY = upperLeft.y + radiusY
  in
    ({ x = centerX, y = centerY }, radiusX, radiusY)

ellipseToBoundingBox : Int -> Int -> Int -> Int -> BoundingBoxCoordinates
ellipseToBoundingBox cX cY rX rY =
  ( { x = cX - rX, y = cY - rY }
  , { x = cX + rX, y = cY + rY }
  )

replaceCanvasItemInstanceById : List CanvasItemInstance -> Int -> CanvasItem -> List CanvasItemInstance
replaceCanvasItemInstanceById allItems id newItem =
  let
    replaceItem item =
      if item.id == id
      then { item | item = newItem }
      else item
  in
    List.map replaceItem allItems

getCursorDropPointCoords : List CanvasItemInstance -> Coordinates -> Coordinates
getCursorDropPointCoords canvasItems cursorCoords =
  let
    tolerance = 20
    moveTopLeft point by = { point | x = point.x - by, y = point.y - by }
    moveBottomRight point by = { point | x = point.x + by, y = point.y + by }
    findFirstClosestItem item found =
      case found of
        Just _ -> found
        Nothing ->
          case item.item of
            Polyline points -> Nothing
            Text _ _ _ -> Nothing
            Rect topLeft bottomRight ->
              if pointWithinView cursorCoords (moveTopLeft topLeft tolerance) (moveBottomRight bottomRight tolerance)
              then Just <| getClosestPoint topLeft bottomRight cursorCoords
              else Nothing
            Ellipse topLeft bottomRight ->
              -- TODO: Find the point on the curve instead of the bounding box.
              if pointWithinView cursorCoords (moveTopLeft topLeft tolerance) (moveBottomRight bottomRight tolerance)
              then Just <| getClosestPoint topLeft bottomRight cursorCoords
              else Nothing
  in
    Maybe.withDefault cursorCoords <| List.foldl findFirstClosestItem Nothing canvasItems

getClosestPoint : Coordinates -> Coordinates -> Coordinates -> Coordinates
getClosestPoint topLeft bottomRight point =
  let
    x = inBetween topLeft.x bottomRight.x point.x
    y = inBetween topLeft.y bottomRight.y point.y
  in
    { x = x, y = y }

-- Given min, max, and a number, return the number if within min and max,
-- otherwise min or max.
inBetween : Int -> Int -> Int -> Int
inBetween min max num =
  case List.minimum [max, num] of
    Just n -> Maybe.withDefault num <| List.maximum [n, min]
    Nothing -> min


-- *** UI ***

menuHeight = 30

view : Model -> Browser.Document Msg
view model =
  { title = "Arrowgrams"
  , body = [ El.layout
               [ Background.color (El.rgb255 255 255 255)
               , Font.family [ Font.sansSerif ]
               ]
               (
                 El.column
                   [ El.width El.fill
                   , El.height El.fill
                   ]
                   [ menu
                   , El.row
                       [ El.width El.fill
                       , El.height El.fill
                       ]
                       [ palette
                       , El.el
                           [ El.width El.fill
                           , El.height (El.px <| Tuple.second model.viewPortSize - menuHeight)
                           , El.scrollbars
                           ]
                           ( El.el
                               -- TODO: Make the size adjust to schematic's content
                               [ El.width (El.px 5000)
                               , El.height (El.px 2000)
                               , Font.family [ Font.monospace ]
                               ]
                               (El.html (canvas model))
                           )
                       , propertyPanel model
                       ]
                   ]
               )
           ]
  }

menu : El.Element Msg
menu =
  let
    item attrs =
      El.el <|
        [ El.width El.shrink
        , El.padding 7
        , Font.center
        , El.mouseOver [ Background.color (El.rgb255 224 224 224) ]
        , El.pointer
        ] ++ attrs
  in
    El.row
      [ El.height (El.px menuHeight)
      , El.width El.fill
      , Font.size 14
      , El.spacing 5
      , El.padding 5
      , Border.color (El.rgb255 192 192 192)
      , Border.widthEach
          { bottom = 1
          , left = 0
          , right = 0
          , top = 0
          }
      ]
      [ item [ EE.onClick SaveSchematic ] (El.text "Save")
      , item [ EE.onClick LoadSchematic ] (El.text "Load")
      ]

palette : El.Element Msg
palette =
  let
    item attrs svg =
      El.el
        ( [ El.width (El.px 40)
          , El.height (El.px 40)
          , El.spacing 5
          , El.mouseOver [ Background.color (El.rgb255 224 224 224) ]
          , El.pointer
          ] ++ attrs
        )
        (Svg.svg [] [svg] |> El.html)
  in
    El.row
      [ El.width (El.px 40)
      , El.height El.fill
      , Border.color (El.rgb255 192 192 192)
      , Border.widthEach
          { bottom = 0
          , left = 0
          , right = 1
          , top = 0
          }
      , Background.color (El.rgb255 252 252 252)
      ]
      [ El.column
          [ El.alignTop
          ]
          [ item
              [ EE.onClick AddRect
              ]
              ( Svg.rect
                  [ SA.fill "white"
                  , SA.fillOpacity "0.0"
                  , SA.stroke "rgb(64, 64, 64)"
                  , SA.strokeWidth "3"
                  , SA.x "13"
                  , SA.y "13"
                  , SA.width "14"
                  , SA.height "14"
                  ]
                  []
              )
          , item
              [ EE.onClick AddEllipse
              ]
              ( Svg.ellipse
                  [ SA.fill "white"
                  , SA.fillOpacity "0.0"
                  , SA.stroke "rgb(64, 64, 64)"
                  , SA.strokeWidth "3"
                  , SA.cx "20"
                  , SA.cy "20"
                  , SA.rx "8"
                  , SA.ry "8"
                  ]
                  []
              )
          , item
              [ EE.onClick AddArrow
              ]
              ( Svg.polyline
                  [ SA.fill "white"
                  , SA.fillOpacity "0.0"
                  , SA.stroke "rgb(64, 64, 64)"
                  , SA.strokeWidth "3"
                  , SA.points "12,28 28,12"
                  , SA.markerEnd "url(#arrowhead-palette)"
                  ]
                  []
              )
          ]
      ]

propertyPanel : Model -> El.Element Msg
propertyPanel model =
  El.column
    [ El.width (El.px 300)
    , El.height El.fill
    , Border.color (El.rgb255 192 192 192)
    , Border.widthEach
        { bottom = 0
        , left = 1
        , right = 0
        , top = 0
        }
    , Background.color (El.rgb255 252 252 252)
    , El.padding 20
    , Font.color (El.rgb255 196 196 196)
    ]
    ( case model.selectedItems of
        [] -> [ El.text "No item selected" ]
        item :: [] -> itemPropertyPanel item
        _ :: _ -> [ El.text "Multiple items selected" ]
    )

itemPropertyPanel : CanvasItemInstance -> List (El.Element Msg)
itemPropertyPanel item =
  let
    fieldLabel label =
      Input.labelAbove
        []
        (El.text label)
    fieldPlaceholder label =
      Just <|
        Input.placeholder
          [ Font.color (El.rgb255 196 196 196)
          ]
          (El.text label)
    textField onChange text placeholder label =
      Input.text
        [ EE.onFocus (UserIsTyping item)
        , EE.onLoseFocus (UserIsNotTyping item)
        , Font.size 12
        ]
        { onChange = onChange item
        , text = text
        , placeholder = fieldPlaceholder placeholder
        , label = fieldLabel label
        }
  in
    [ El.column
        [ Font.color (El.rgb255 0 0 0)
        , El.spacing 25
        , El.width El.fill
        ]
        ( case item.item of
            Rect _ _ ->
              [ textField UpdateItemName item.name "e.g. Compile composite" "Part name"
              , textField UpdateItemGitUrl item.gitUrl "e.g. https://github.com/arrowgrams/arrowgrams.git" "Git URL"
              , textField UpdateItemGitRef item.gitRef "e.g. 1b83cf3" "Git ref"
              , textField UpdateItemContextDir item.contextDir "e.g. build_process/parts/" "Context directory to run in"
              , textField UpdateItemManifestPath item.manifestPath "e.g. compile_composite.json" "Manifest path relative to the context directory"
              ]
            Ellipse _ _ ->
              [ textField UpdateItemName item.name "Pin's name here" "Pin name"
              ]
            Polyline _ ->
              [ textField UpdateSourcePinName item.sourcePinName "source" "Source pin name"
              , textField UpdateSinkPinName item.sinkPinName "sink" "Sink pin name"
              ]
            _ -> []
        )
    ]

canvas : Model -> Html.Html Msg
canvas model =
  let
    canvasItems = List.map (displayCanvasItemInstance model) model.instantiatedItems
    (polylineUnderConstruction, pointUnderCursorCoords) =
      case model.intent of
        ToCreatePolyline cursorCoords points -> (pointsToString points, Just cursorCoords)
        _ -> ("", Nothing)
    specialItems =
      -- Arrowhead. Taken from https://developer.mozilla.org/en-US/docs/Web/SVG/Element/marker
      [ Svg.marker
          [ SA.id "arrowhead"
          , SA.viewBox "0 0 10 10"
          , SA.refX "10"
          , SA.refY "5"
          , SA.markerWidth "6"
          , SA.markerHeight "6"
          , SA.orient "auto-start-reverse"
          ]
          [ Svg.path [ SA.d "M 0 0 L 10 5 L 0 10 z" ] []
          ]
      , Svg.marker
          [ SA.id "arrowhead-palette"
          , SA.viewBox "0 0 15 15"
          , SA.refX "7"
          , SA.refY "5"
          , SA.markerWidth "6"
          , SA.markerHeight "6"
          , SA.orient "auto-start-reverse"
          ]
          [ Svg.path [ SA.d "M 0 0 L 10 5 L 0 10 z" ] []
          ]
      -- The polyline while it is being constructed.
      , Svg.polyline
          [ SA.fill "white"
          , SA.fillOpacity "0.0"
          , SA.stroke "black"
          , SA.points polylineUnderConstruction
          , SA.strokeWidth "1"
          , SA.markerEnd "url(#arrowhead)"
          ]
          []
      -- The dot under cursor while the the polyline is being drawn.
      , Svg.ellipse
          [ SA.fill "white"
          , SA.fillOpacity "1.0"
          , SA.stroke "grey"
          , SA.strokeWidth "1.5"
          , SA.display <|
              case pointUnderCursorCoords of
                Just _ -> "inherit"
                Nothing -> "none"
          , SA.cx (String.fromInt <| Maybe.withDefault 0 <| Maybe.map .x pointUnderCursorCoords)
          , SA.cy (String.fromInt <| Maybe.withDefault 0 <| Maybe.map .y pointUnderCursorCoords)
          , SA.rx (String.fromInt 3)
          , SA.ry (String.fromInt 3)
          ]
          []
      ]
    backgroundItems =
      -- Generated from http://www.heropatterns.com/
      [ Svg.pattern
          [ SA.id "background-graph-paper"
          , SA.patternUnits "userSpaceOnUse"
          , SA.x "0"
          , SA.y "0"
          , SA.width "100"
          , SA.height "100"
          ]
          [ Svg.path
              [ SA.opacity "0.1"
              , SA.d "M96 95h4v1h-4v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4h-9v4h-1v-4H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15v-9H0v-1h15V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h9V0h1v15h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9h4v1h-4v9zm-1 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm9-10v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm9-10v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm9-10v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-10 0v-9h-9v9h9zm-9-10h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9zm10 0h9v-9h-9v9z"
              ] []
          , Svg.path
              [ SA.opacity "0.2"
              , SA.d "M6 5V0H5v5H0v1h5v94h1V6h94V5H6z"
              ]
              []
          ]
      , Svg.rect
          [ SA.fill "url(#background-graph-paper)"
          , SA.width "100%"
          , SA.height "100%"
          ]
          []
      ]
    viewBoxDims =
      SI.interpolate "{0} {1} {2} {3}"
        [ String.fromInt model.panCoords.x
        , String.fromInt model.panCoords.y
        , String.fromFloat model.zoomFactor
        , String.fromFloat model.zoomFactor
        ]
  in
    Svg.svg
      [ SA.width "100%"
      , SA.height "100%"
      , SE.onMouseDown ClearSelection
      , SE.on "dblclick" (JD.succeed <| DoubleClick Nothing)
      -- TODO: View box isn't working. Fix before enabling.
      --, SA.viewBox viewBoxDims
      ]
      -- Note that we want `specialItems` to be after because of SVG rendering
      -- order.
      (backgroundItems ++ canvasItems ++ specialItems)

movementCircleAttributes : Bool -> List (Svg.Attribute Msg)
movementCircleAttributes toDisplay =
  [ SA.d "M 5, 5 m -2, 0 a 2,2 0 1,0 5,0 a 2,2 0 1,0 -5,0"
  , SA.fill "white"
  , SA.stroke "black"
  , SA.visibility (if toDisplay then "visible" else "hidden")
  ]

makeMovementCirlces : CanvasItemInstance -> Bool -> List Coordinates -> List (Svg.Svg Msg)
makeMovementCirlces item toDisplay points =
  let
    makeCircle i { x, y } =
      Svg.path
        ( movementCircleAttributes toDisplay ++
          [ SA.transform ("translate(" ++ String.fromInt (x - 5) ++ "," ++ String.fromInt (y - 5) ++ ")")
          , SE.onMouseDown (MovePath item i { x = x, y = y})
          ]
        )
        []
  in
    List.indexedMap makeCircle points

-- Selection circle around visual elements for resizing.
makeResizeCircles : Coordinates -> CanvasItemInstance -> Int -> Int -> Bool -> AnchorPosition -> Svg.Svg Msg
makeResizeCircles cursorCoords item width height toDisplay anchor =
  let
    (offsetX, offsetY) =
      case anchor of
        UpperLeft -> (0, 0)
        UpperRight -> (width, 0)
        LowerLeft -> (0, height)
        LowerRight -> (width, height)
    x = String.fromInt (offsetX - 5)
    y = String.fromInt (offsetY - 5)
  in
    Svg.path
      (
        movementCircleAttributes toDisplay ++
          [ SA.transform ("translate(" ++ x ++ "," ++ y ++ ")")
          , SE.onMouseDown (ResizeItem item cursorCoords anchor)
          ]
      )
      []

displayResizeOption : Bool -> Intent -> CanvasItemInstance -> Coordinates -> Coordinates -> Coordinates -> List (Svg.Svg Msg)
displayResizeOption isItemHovered intent item cursorCoords upperLeft lowerRight =
  let
    isResizing =
      case intent of
        ToResizeCanvasItemInstance _ _ _ -> True
        _ -> False
    width = lowerRight.x - upperLeft.x
    height = lowerRight.y - upperLeft.y
    toDisplay = isResizing || isItemHovered
    makeCircle = makeResizeCircles cursorCoords item width height toDisplay
  in
    [ makeCircle UpperLeft
    , makeCircle UpperRight
    , makeCircle LowerLeft
    , makeCircle LowerRight
    ]

pointWithinView : Coordinates -> Coordinates -> Coordinates -> Bool
pointWithinView point upperLeft lowerRight =
  point.x >= upperLeft.x && point.y >= upperLeft.y &&
  point.x <= lowerRight.x && point.y <= lowerRight.y

moveSelectedItems : Model -> CanvasItemInstance -> CanvasItemInstance
moveSelectedItems model item =
  case (model.cursorMode, model.cursorCoords) of
    (DragCursor starting, current) ->
      updateItemCoordinates model.zoomFactor starting current item
    _ -> item

displayCanvasItemInstance : Model -> CanvasItemInstance -> Svg.Svg Msg
displayCanvasItemInstance model item =
  let
    isSelected = isSelectedCanvasItemInstance model item
    itemToDisplay =
      case (isSelected, model.cursorMode) of
        (True, DragCursor _) -> moveSelectedItems model item
        _ -> item
    isItemHovered =
      case model.hoveredItem of
        Just hovered -> hovered == item
        Nothing -> False
    toDisplayResizeOption = displayResizeOption isItemHovered model.intent itemToDisplay model.cursorCoords
  in
    case itemToDisplay.item of
      Rect upperLeft lowerRight ->
        let
          x = String.fromInt upperLeft.x
          y = String.fromInt upperLeft.y
          width = String.fromInt (lowerRight.x - upperLeft.x)
          height = String.fromInt (lowerRight.y - upperLeft.y)
          cx = String.fromInt <| (lowerRight.x - upperLeft.x) // 2
          cy = String.fromInt <| (lowerRight.y - upperLeft.y) // 2
          resizeOption = toDisplayResizeOption upperLeft lowerRight
        in
          Svg.g
            [ SE.onMouseDown (SelectItem item)
            , SE.onMouseOver (HoveredItem item)
            , SE.onMouseOut UnhoveredItem
            , SA.transform ("translate(" ++ x ++ "," ++ y ++ ")")
            ]
            (
              [ Svg.rect
                  [ SA.fill "white"
                  , SA.fillOpacity "1.0"
                  , SA.stroke (if isSelected then "blue" else "black")
                  , SA.width width
                  , SA.height height
                  ]
                  []
              , Svg.text_
                  [ SA.transform ("translate(" ++ cx ++ "," ++ cy ++ ")")
                  , SA.textAnchor "middle"
                  , SA.alignmentBaseline "middle"
                  , SA.width "200"
                  , SA.height "50"
                  ]
                  [ Svg.text item.name
                  ]
              ] ++ resizeOption
            )
      Polyline rawPoints ->
        let
          straightenedPoints = straightenPolyline rawPoints
          pointsString = pointsToString straightenedPoints
          movementCircles = makeMovementCirlces itemToDisplay isItemHovered rawPoints
          nameTexts = List.filterMap (Maybe.map makePinNameText) pinNamesWithPoints
          pinNamesWithPoints =
            [ Maybe.map (\x -> (x, item.sourcePinName)) starting
            , Maybe.map (\x -> (x, item.sinkPinName)) ending
            ]
          (starting, ending) =
            case straightenedPoints of
              [] -> (Nothing, Nothing)
              (x :: xs) -> (Just x, (List.drop (List.length xs - 1) xs |> List.head))
          makePinNameText (coords, pinName) =
            let
              ((newCoords, _), anchor, baseline) = calculatePinNamePosition model.instantiatedItems coords
            in
              ( Svg.text_
                  [ SA.fill "black"
                  , SA.fontSize "8pt"
                  , SA.stroke (if isSelected then "blue" else "black")
                  -- Give the pin names some space from the points.
                  , SA.x <| String.fromInt <| newCoords.x
                  , SA.y <| String.fromInt <| newCoords.y
                  , SA.textAnchor anchor
                  , SA.alignmentBaseline baseline
                  ]
                  [ Svg.text pinName ]
              )
        in
          Svg.g
            [ SE.onMouseDown (SelectItem item)
            , SE.onMouseOver (HoveredItem item)
            , SE.onMouseOut UnhoveredItem
            ]
            (
              [
                -- This is the wire visible to the user.
                ( Svg.polyline
                    [ SA.fill "white"
                    , SA.fillOpacity "0.0"
                    , SA.stroke (if isSelected then "blue" else "black")
                    , SA.points pointsString
                    , SA.strokeWidth "1"
                    , SA.markerEnd "url(#arrowhead)"
                    ]
                    []
                ),
                -- This is the wire hidden to the user but of a wider stroke so
                -- that the user can click on the wire more easily.
                ( Svg.polyline
                    [ SA.fill "white"
                    , SA.stroke "black"
                    , SA.points pointsString
                    , SA.fillOpacity "0.0"
                    , SA.strokeOpacity "0.0"
                    , SA.strokeWidth "20"
                    , SE.on "dblclick" (JD.succeed <| DoubleClick (Just item))
                    ]
                    []
                )
              ] ++ movementCircles ++ nameTexts
            )
      Ellipse upperLeft lowerRight ->
        let
          (center, radiusX, radiusY) = boundingBoxToEllipse upperLeft lowerRight
          resizeOption = toDisplayResizeOption upperLeft lowerRight
        in
          Svg.g
            [ SE.onMouseDown (SelectItem item)
            , SE.onMouseOver (HoveredItem item)
            , SE.onMouseOut UnhoveredItem
            , SA.transform ("translate(" ++ String.fromInt upperLeft.x ++ "," ++ String.fromInt upperLeft.y ++ ")")
            ]
            (
              -- This is the ellipse visible to the user.
              [ Svg.ellipse
                  [ SA.fill "white"
                  , SA.fillOpacity "1.0"
                  , SA.stroke (if isSelected then "blue" else "black")
                  , SA.cx (String.fromInt radiusX)
                  , SA.cy (String.fromInt radiusY)
                  , SA.rx (String.fromInt radiusX)
                  , SA.ry (String.fromInt radiusY)
                  ]
                  []
              , Svg.text_
                  [ SA.transform ("translate(" ++ String.fromInt radiusX ++ "," ++ String.fromInt radiusY ++ ")")
                  , SA.textAnchor "middle"
                  , SA.alignmentBaseline "middle"
                  ]
                  [ Svg.text item.name
                  ]
              -- This is the bounding box hidden to the user so that the user
              -- can select the resize circles.
              , Svg.rect
                  [ SA.fill "white"
                  , SA.stroke (if isSelected then "blue" else "black")
                  , SA.width (lowerRight.x - upperLeft.x |> String.fromInt)
                  , SA.height (lowerRight.y - upperLeft.y |> String.fromInt)
                  , SA.fillOpacity "0.0"
                  , SA.strokeOpacity "0.0"
                  ]
                  []
              ] ++ resizeOption
            )
      Text upperLeft lowerRight label ->
        let
          isEditing =
            case model.intent of
              ToType i -> i.id == item.id
              _ -> False
        in
          Svg.g
            [ SE.onMouseDown (SelectItem item)
            , SE.on "dblclick" (JD.succeed <| DoubleClick (Just item))
            , SA.transform ("translate(" ++ String.fromInt upperLeft.x ++ "," ++ String.fromInt upperLeft.y ++ ")")
            ]
            -- This is the selection box.
            [ Svg.rect
                [ SA.fill "white"
                , SA.stroke "black"
                , SA.width <| String.fromInt <| lowerRight.x - upperLeft.x
                , SA.height <| String.fromInt <| lowerRight.y - upperLeft.y
                , SA.fillOpacity "0.0"
                , SA.strokeOpacity "1.0"
                , SA.strokeDasharray "4"
                ]
                []
            , if isEditing
              then
                Svg.foreignObject
                  [ SA.width "500"
                  , SA.height "500"
                  ]
                  [ Html.input
                      [ HA.type_ "text"
                      , HA.size 35
                      ]
                      []
                  ]
              else
                Svg.text_
                  [ SA.fill "black"
                  , SA.fontSize "8pt"
                  , SA.stroke (if isSelected then "blue" else "black")
                  , SA.id ("canvas-item-text-" ++ String.fromInt item.id)
                  ]
                  [ Svg.text label ]
            ]

-- Polylines in Arrowgrams are always in straight lines. i.e. No diagonal line.
straightenPolyline : List Coordinates -> List Coordinates
straightenPolyline points =
  case points of
    (x :: xs) ->
      let
        (last, list) = List.foldr addConnectingPoint (x, []) xs
      in
        List.reverse (last :: list)
    _ -> points

addConnectingPoint : Coordinates -> (Coordinates, List Coordinates) -> (Coordinates, List Coordinates)
addConnectingPoint next (pt, pts) =
  let
    connectingPoint = { x = next.x, y = pt.y }
  in
    (next, connectingPoint :: pt :: pts)

calculatePinNamePosition : List CanvasItemInstance -> Coordinates -> (BoundingBoxCoordinates, String, String)
calculatePinNamePosition instantiatedItems coords =
  let
    rects = List.filterMap (.item >> getCoords) instantiatedItems
    getCoords item =
      case item of
        (Rect upperLeft lowerRight) -> Just (upperLeft, lowerRight)
        _ -> Nothing
    -- Faking the lower right of the pin name since we don't have access to the
    -- width and height of the text.
    pinNameLR = { x = coords.x + 100, y = coords.y + 100 }
    seed = ((coords, pinNameLR), "start", "baseline")
  in
    List.foldl calculatePositionOutsideOfBoundingBox seed rects

padBoundingBox : BoundingBoxCoordinates -> Int -> BoundingBoxCoordinates
padBoundingBox (ul, lr) padding =
  ( { ul
    | x = ul.x - padding
    , y = ul.y - padding
    }
  , { lr
    | x = lr.x + padding
    , y = lr.y + padding
    }
  )

calculatePositionOutsideOfBoundingBox : (Coordinates, Coordinates) -> (BoundingBoxCoordinates, String, String) -> (BoundingBoxCoordinates, String, String)
calculatePositionOutsideOfBoundingBox bbox ((itemUL, itemLR), _, _) =
  let
    -- MAGIC: Padding of 10 for bounding boxes
    (bbUL, bbLR) = padBoundingBox bbox 10
    (dx, dy) = calculateClosestPointDelta itemUL itemLR bbUL bbLR
    -- Which dimension is closer?
    closerDimension = if abs dx < abs dy then "x" else "y"
    -- See https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/text-anchor
    (x, anchor) = if dx < 0 then (bbUL.x, "end") else (bbLR.x, "start")
    -- See https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/alignment-baseline
    (y, baseline) = if dy < 0 then (bbUL.y, "baseline") else (bbLR.y, "hanging")
    (ul, an, bl) =
      case (dx, dy, abs dx < abs dy) of
        (0, 0, _) -> (itemUL, "start", "baseline")
        (_, _, True) -> ({ x = x, y = itemUL.y }, anchor, "baseline")
        (_, _, False) -> ({ x = itemUL.x, y = y }, "start", baseline)
  in
    ((ul, ul), an, bl)

-- Given: upper-left of box A, lower-right of box A, upper-left of box B,
-- lower-right of box B, A intersects with B, do the following:
-- 1. Calculate the closest point outside of B to A's upper-left.
-- 2. Calculate the delta between that closest point and A's upper-left.
-- 3. Return the delta in the form of (xDelta, yDelta).
-- If A does not intersect with B, return (0, 0).
calculateClosestPointDelta : Coordinates -> Coordinates -> Coordinates -> Coordinates -> (Int, Int)
calculateClosestPointDelta aUL aLR bUL bLR =
  if not (intersectingBoxes aUL aLR bUL bLR)
  then (0, 0)
  else 
    let
      -- Delta between A's upper left and B's upper left in the horizontal dimension
      dxUL = bUL.x - aUL.x
      -- Delta between A's upper left and B's lower right in the horizontal dimension
      dxLR = bLR.x - aUL.x
      -- Horizontal delta to return
      dx = if abs dxUL < abs dxLR then dxUL else dxLR
      -- Delta between A's upper left and B's upper left in the vertical dimension
      dyUL = bUL.y - aUL.y
      -- Delta between A's upper left and B's lower right in the vertical dimension
      dyLR = bLR.y - aUL.y
      -- Vertical delta to return
      dy = if abs dyUL < abs dyLR then dyUL else dyLR
    in
      (dx, dy)

intersectingBoxes : Coordinates -> Coordinates -> Coordinates -> Coordinates -> Bool
intersectingBoxes aUL aLR bUL bLR =
  (aUL.x > bUL.x && aUL.y > bUL.y && aUL.x < bLR.x && aUL.y < bLR.y) ||
  (aLR.x > bUL.x && aLR.y > bUL.y && aLR.x < bLR.x && aLR.y < bLR.y)

pointsToString : List Coordinates -> String
pointsToString points =
  let
    coordsToString { x, y } = String.fromInt x ++ "," ++ String.fromInt y
  in
    List.map coordsToString points |> String.join " "


-- *** Entry point ***

init : Flags -> Url.Url -> Browser.Navigation.Key -> (Model, Cmd Msg)
init flags url key = (initialModel, Cmd.none)

main : Program Flags Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = \_ -> NoOp
    , onUrlRequest = \_ -> NoOp
    }
