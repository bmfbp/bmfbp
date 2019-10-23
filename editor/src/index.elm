module Main exposing (main)

import Url
import Browser.Navigation
import Browser
import Browser.Events as BE
import Element
import Element.Font as Font
import Element.Background as Background
import Svg
import Svg.Attributes as SA
import Svg.Events as SE
import Html
import Json.Decode as JD

import Debug


-- *** Application model ***

type alias Flags = {}

type Msg
  = NoOp
  | MouseMove Coordinates
  | KeyPress String
  | KeyUp String
  | SelectItem CanvasItemInstance
  | ResizeItem CanvasItemInstance Coordinates Corner
  | ClearSelection
  | MouseDown Coordinates
  | MouseUp Coordinates

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
  , canvasItemCount : Int
  , selectionMode : SelectionMode
  }

type alias Coordinates = { x : Int, y : Int }

-- This captures the state of some task that the user wants to
-- do in multiple steps.
type Intent
  -- Moving the mouse around
  = Explore
  | MoveSelectedCanvasItemInstances
  | ResizeCanvasItemInstance CanvasItemInstance Coordinates Corner
  | CreateCanvasItemInstance CanvasItemInstance

type CursorMode
  = FreeFormCursor
  -- Parameter is the starting coordinates
  | DragCursor Coordinates
  -- This is needed to deal with all the events being fired
  -- when the user triggers a mousedown event.
  | SelectionInProgress

type alias CanvasItemInstance = { id : Int, item : CanvasItem }

type CanvasItem
  = Part Coordinates Coordinates
  | Wire (List Coordinates)
  | SourceSink Coordinates Int
  | Text Coordinates String
  --| Comment Coordinates Coordinates Coordinates

type Corner
  = UpperLeft
  | UpperRight
  | LowerLeft
  | LowerRight

-- *** Application logic ***

-- MOCK: This will be removed once we have the ability to create new canvas items.
initialCanvasItemInstances : List CanvasItemInstance
initialCanvasItemInstances =
  [
    { id = 0, item = SourceSink { x = 500, y = 200 } 50 },
    { id = 1, item = Part { x = 24, y = 73 } { x = 73, y = 108 } },
    { id = 2, item = Part { x = 284, y = 73 } { x = 333, y = 108 } },
    { id = 3, item = Wire [{ x = 73, y = 83 }, { x = 284, y = 83 }] },
    { id = 4, item = Text { x = 500, y = 200 } "Sink" }
  ]

initialModel : Model
initialModel =
  { cursorCoords = { x = 0, y = 0 }
  , instantiatedItems = initialCanvasItemInstances
  , selectedItems = List.take 1 initialCanvasItemInstances
  , itemsUnderCursor = []
  , currentItemUnderCursor = Nothing
  , cursorMode = FreeFormCursor
  , intent = Explore
  , canvasItemCount = List.length initialCanvasItemInstances
  , selectionMode = SingleSelect
  }

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    NoOp -> updateModelOnly model
    MouseMove coords ->
      let
        newModel =
          case model.intent of
            ResizeCanvasItemInstance { id, item } startingCoords corner ->
              let
                newItem = resizeCanvasItem item startingCoords model.cursorCoords corner
                updatedItems = replaceCanvasItemInstanceById model.instantiatedItems id newItem
              in
                { model
                | instantiatedItems = updatedItems
                -- Resizing means we're not selecting anything.
                , selectedItems = []
                }
            _ -> model
      in
        updateModelOnly { newModel | cursorCoords = coords }
    KeyPress key -> handleKey model key |> updateModelOnly
    KeyUp key -> handleKeyUp model key |> updateModelOnly
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
    ResizeItem item startingCursorCoords corner ->
      updateModelOnly
        { model |
            intent = ResizeCanvasItemInstance item startingCursorCoords corner
        }
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
      updateModelOnly
        { model
        | cursorMode = DragCursor coords
        }
    MouseUp ending ->
      case (model.cursorMode, model.intent) of
        (_, ResizeCanvasItemInstance _ _ _) ->
          updateModelOnly { model | intent = Explore }
        (DragCursor starting, CreateCanvasItemInstance item) ->
          updateModelOnly
            { model
            | instantiatedItems = item :: model.instantiatedItems
            }
        (DragCursor starting, _) ->
          let
            updatedModel = updateSelectedItemCoordinates model starting ending
          in
            updateModelOnly { updatedModel | cursorMode = FreeFormCursor }
        _ -> updateModelOnly { model | cursorMode = FreeFormCursor }

handleKey : Model -> String -> Model
handleKey model key =
  let
    createInstance = createNewCanvasItemInstance model
  in
    case key of
      "Shift" -> { model | selectionMode = MultipleSelect }
      "c" -> copySelectedCanvasItemInstances model
      "Backspace" -> deleteSelectedCanvasItemInstances model
      "1" -> createInstance <| Part { x = 100, y = 100 } { x = 200, y = 200 }
      "2" -> createInstance <| Wire [{ x = 100, y = 100 }, { x = 300, y = 100}]
      "3" -> createInstance <| SourceSink { x = 100, y = 100 } 50
      "4" -> createInstance <| Text { x = 100, y = 100 } "Text"
      _ -> model

handleKeyUp : Model -> String -> Model
handleKeyUp model key = model

createNewCanvasItemInstance : Model -> CanvasItem -> Model
createNewCanvasItemInstance model canvasItem =
  let
    (newModel, newItem) = copyCanvasItemInstance model { id = -1, item = canvasItem }
  in
    { newModel | instantiatedItems = newItem :: model.instantiatedItems }

deleteSelectedCanvasItemInstances : Model -> Model
deleteSelectedCanvasItemInstances model =
  { model
      | instantiatedItems = List.filter (\x -> not (List.member x model.selectedItems)) model.instantiatedItems
      , selectedItems = []
  }

copySelectedCanvasItemInstances : Model -> Model
copySelectedCanvasItemInstances model =
  let
    (newModel, newItems) = List.foldl foldCopy (model, []) model.selectedItems
  in
    { newModel
        | instantiatedItems = List.append newItems model.instantiatedItems
        , selectedItems = newItems
    }

foldCopy : CanvasItemInstance -> (Model, List CanvasItemInstance) -> (Model, List CanvasItemInstance)
foldCopy item (model, newItems) =
  let
    (newModel, newItem) = copyCanvasItemInstance model item
  in
    (newModel, newItem :: newItems)

copyCanvasItemInstance : Model -> CanvasItemInstance -> (Model, CanvasItemInstance)
copyCanvasItemInstance model canvasItem =
  let
    newId = model.canvasItemCount
    newItem = { canvasItem | id = newId }
  in
    ({ model | canvasItemCount = newId + 1 }, newItem)

updateModelOnly : Model -> (Model, Cmd Msg)
updateModelOnly model = (model, Cmd.none)

isSelectedCanvasItemInstance : Model -> CanvasItemInstance -> Bool
isSelectedCanvasItemInstance model match = List.any (\i -> i.id == match.id) model.selectedItems

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ BE.onMouseDown (JD.map MouseDown mouseDecoder)
    , BE.onMouseUp (JD.map MouseUp mouseDecoder)
    , BE.onMouseMove (JD.map MouseMove mouseDecoder)
    , BE.onKeyDown (JD.map KeyPress keyDecoder)
    , BE.onKeyUp (JD.map KeyUp keyDecoder)
    ]

mouseDecoder : JD.Decoder Coordinates
mouseDecoder =
  JD.map2 Coordinates
    (JD.at [ "offsetX" ] JD.int)
    (JD.at [ "offsetY" ] JD.int)

keyDecoder : JD.Decoder String
keyDecoder = JD.field "key" JD.string

updateItemCoordinates : Coordinates -> Coordinates -> CanvasItemInstance -> CanvasItemInstance
updateItemCoordinates starting ending canvasItem =
  let
    dx = ending.x - starting.x
    dy = ending.y - starting.y
    item =
      case canvasItem.item of
        Part upperLeft lowerRight ->
          Part
            { x = upperLeft.x + dx, y = upperLeft.y + dy }
            { x = lowerRight.x + dx, y = lowerRight.y + dy }
        Wire points ->
          Wire (List.map (\{ x, y } -> { x = x + dx, y = y + dy }) points)
        SourceSink center radius ->
          SourceSink { x = center.x + dx, y = center.y + dy } radius
        Text center label ->
          Text { x = center.x + dx, y = center.y + dy } label
  in
    { canvasItem | item = item }

updateSelectedItemCoordinates : Model -> Coordinates -> Coordinates -> Model
updateSelectedItemCoordinates model starting ending =
  let
    updateCoordinates = updateItemCoordinates starting ending
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

resizeCanvasItem : CanvasItem -> Coordinates -> Coordinates -> Corner -> CanvasItem
resizeCanvasItem originalItem startingCoords currentCoords corner =
  let
    deltaX = currentCoords.x - startingCoords.x
    deltaY = currentCoords.y - startingCoords.y
    threshold = 25
  in
    case originalItem of
      Part upperLeft lowerRight ->
        case corner of
          UpperLeft ->
            Part
              { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
              , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
              }
              lowerRight
          UpperRight ->
            Part
              { x = upperLeft.x
              , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
              }
              { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
              , y = lowerRight.y
              }
          LowerLeft ->
            Part
              { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
              , y = upperLeft.y
              }
              { x = lowerRight.x
              , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
              }
          LowerRight ->
            Part
              upperLeft
              { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
              , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
              }
      -- TODO: Implement resizing the rest of the item types
      _ ->
        originalItem

replaceCanvasItemInstanceById : List CanvasItemInstance -> Int -> CanvasItem -> List CanvasItemInstance
replaceCanvasItemInstanceById allItems id newItem =
  let
    replaceItem item =
      if item.id == id
      then { item | item = newItem }
      else item
  in
    List.map replaceItem allItems


-- *** UI ***

view : Model -> Browser.Document Msg
view model =
  { title = "Arrowgram Editor"
  , body = [ Element.layout
              [ Background.color (Element.rgb 255 255 255)
              , Font.family [ Font.monospace ]
              , Font.color (Element.rgb255 249 250 111)
              ]
              ( canvas model |> Element.html )
           ]
  }

canvas : Model -> Html.Html Msg
canvas model =
  let
    canvasItems = List.map (displayCanvasItemInstance model) model.instantiatedItems
    definitions =
      -- Arrowhead. Taken from https://developer.mozilla.org/en-US/docs/Web/SVG/Element/marker.
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
      ]
  in
    Svg.svg
      [ SA.height "700"
      , SE.onMouseDown ClearSelection
      ]
      (definitions ++ canvasItems)

-- Selection circle around visual elements for resizing.
makeResizeCircle : Coordinates -> CanvasItemInstance -> Int -> Int -> Corner -> Svg.Svg Msg
makeResizeCircle cursorCoords item width height corner =
  let
    (offsetX, offsetY) =
      case corner of
        UpperLeft -> (0, 0)
        UpperRight -> (width, 0)
        LowerLeft -> (0, height)
        LowerRight -> (width, height)
    x = String.fromInt (offsetX - 5)
    y = String.fromInt (offsetY - 5)
  in
    Svg.path
      [ SA.d "M 5, 5 m -2, 0 a 2,2 0 1,0 5,0 a 2,2 0 1,0 -5,0"
      , SA.fill "white"
      , SA.stroke "black"
      , SA.transform ("translate(" ++ x ++ "," ++ y ++ ")")
      , SE.onMouseDown (ResizeItem item cursorCoords corner)
      ]
      []

displayResizeOption : Intent -> CanvasItemInstance -> Coordinates -> Coordinates -> Coordinates -> List (Svg.Svg Msg)
displayResizeOption intent item cursorCoords upperLeft lowerRight =
  let
    isResizing =
      case intent of
        ResizeCanvasItemInstance _ _ _ -> True
        _ -> False
    width = lowerRight.x - upperLeft.x
    height = lowerRight.y - upperLeft.y
    makeCircle = makeResizeCircle cursorCoords item width height
  in
    if isResizing || withinView cursorCoords upperLeft lowerRight
    then
      [ makeCircle UpperLeft
      , makeCircle UpperRight
      , makeCircle LowerLeft
      , makeCircle LowerRight
      ]
    else []

withinView : Coordinates -> Coordinates -> Coordinates -> Bool
withinView point upperLeft lowerRight =
  point.x >= upperLeft.x && point.y >= upperLeft.y &&
  point.x <= lowerRight.x && point.y <= lowerRight.y

moveSelectedItems : Model -> CanvasItemInstance -> CanvasItemInstance
moveSelectedItems model item =
  case (model.cursorMode, model.cursorCoords) of
    (DragCursor starting, current) ->
      updateItemCoordinates starting current item
    _ -> item

displayCanvasItemInstance : Model -> CanvasItemInstance -> Svg.Svg Msg
displayCanvasItemInstance model item =
  let
    isSelected = isSelectedCanvasItemInstance model item
    itemToDisplay =
      case (isSelected, model.cursorMode) of
        (True, DragCursor _) -> moveSelectedItems model item
        _ -> item
  in
    case itemToDisplay.item of
      Part upperLeft lowerRight ->
        let
          x = String.fromInt upperLeft.x
          y = String.fromInt upperLeft.y
          width = String.fromInt (lowerRight.x - upperLeft.x)
          height = String.fromInt (lowerRight.y - upperLeft.y)
          resizeOption = displayResizeOption model.intent itemToDisplay model.cursorCoords upperLeft lowerRight
        in
          Svg.g
            [ SE.onMouseDown (SelectItem item)
            , SA.transform ("translate(" ++ x ++ "," ++ y ++ ")")
            ]
            (
              [
                Svg.rect
                  [ SA.fill "white"
                  , SA.stroke (if isSelected then "blue" else "black")
                  , SA.width width
                  , SA.height height
                  ]
                  []
              ] ++ resizeOption
            )
      Wire points ->
        let
          coordsToString { x, y } = String.fromInt x ++ "," ++ String.fromInt y
          pointsString = List.map coordsToString points |> String.join " "
        in
          Svg.g
            [ SE.onMouseDown (SelectItem item)
            ]
            [
              -- This is the wire visible to the user.
              (
                Svg.polyline
                  [ SA.fill "white"
                  , SA.stroke (if isSelected then "blue" else "black")
                  , SA.points pointsString
                  , SA.strokeWidth "1"
                  , SA.markerEnd "url(#arrowhead)"
                  ]
                  []
              ),
              -- This is the wire hidden to the user but of a wider stroke so
              -- that the user can click on the wire more easily.
              (
                Svg.polyline
                  [ SA.fill "white"
                  , SA.stroke "black"
                  , SA.points pointsString
                  , SA.fillOpacity "0.0"
                  , SA.strokeOpacity "0.0"
                  , SA.strokeWidth "20"
                  ]
                  []
              )
            ]
      SourceSink center longRadius ->
        Svg.ellipse
          [ SA.fill "white"
          , SA.stroke (if isSelected then "blue" else "black")
          , SE.onMouseDown (SelectItem item)
          , SA.cx (String.fromInt center.x)
          , SA.cy (String.fromInt center.y)
          , SA.rx (String.fromInt longRadius)
          , SA.ry (toFloat longRadius * 0.80 |> round |> String.fromInt)
          ]
          []
      Text center label ->
        Svg.text_
          [ SA.fill "black"
          , SA.x (String.fromInt center.x)
          , SA.y (String.fromInt center.y)
          , SA.stroke (if isSelected then "blue" else "black")
          , SE.onMouseDown (SelectItem item)
          ]
          [ Svg.text label ]


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
