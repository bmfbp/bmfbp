port module Main exposing (main)

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
import Json.Encode as JE
import String.Interpolate as SI

port saveSvg : JE.Value -> Cmd msg


-- *** Application model ***

type alias Flags = {}

type Msg
  = NoOp
  | MouseMove Coordinates
  | KeyPress String
  | KeyUp String
  | SelectItem CanvasItemInstance
  | ResizeItem CanvasItemInstance Coordinates AnchorPosition
  | HoveredItem CanvasItemInstance
  | MovePath CanvasItemInstance Int Coordinates
  | UnhoveredItem
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
  , hoveredItem : Maybe CanvasItemInstance
  }

type alias Coordinates = { x : Int, y : Int }

-- This captures the state of some task that the user wants to
-- do in multiple steps.
type Intent
  -- Default state: Moving the mouse around
  = ToExplore
  | ToMoveSelectedCanvasItemInstances
  | ToResizeCanvasItemInstance CanvasItemInstance Coordinates AnchorPosition
  | ToCreateCanvasItemInstance CanvasItemInstance
  | ToMovePath CanvasItemInstance Int Coordinates
  | ToCreatePolyline (List Coordinates)

type CursorMode
  = FreeFormCursor
  -- Parameter is the starting coordinates
  | DragCursor Coordinates
  -- This is needed to deal with all the events being fired
  -- when the user triggers a mousedown event.
  | SelectionInProgress

type alias CanvasItemInstance = { id : Int, item : CanvasItem }

type CanvasItem
  -- A rectangle is defined by the upper-left and the lower-right coordinates.
  = Rect Coordinates Coordinates
  | Polyline (List Coordinates)
  -- Ellipse is constructed using the upper-left and the lower-right corners of
  -- the bounding box of the ellipse.
  | Ellipse Coordinates Coordinates
  -- A text is defined by upper-left coordinates and the text to display.
  | Text Coordinates String

type AnchorPosition
  = UpperLeft
  | UpperRight
  | LowerLeft
  | LowerRight

-- *** Application logic ***

-- MOCK: This will be removed once we have the ability to create new canvas items.
initialCanvasItemInstances : List CanvasItemInstance
initialCanvasItemInstances =
  [ { id = 0, item = Ellipse { x = 50, y = 60 } { x = 150, y = 140 } }
  , { id = 1, item = Text { x = 59, y = 103 } "top-level svg" }
  , { id = 2, item = Rect { x = 358, y = 67 } { x = 438, y = 136 } }
  , { id = 3, item = Text { x = 370, y = 104 } "compile composite" }
  , { id = 4, item = Polyline [{ x = 150, y = 105}, { x = 356, y = 103 }] }
  ]

initialModel : Model
initialModel =
  { cursorCoords = { x = 0, y = 0 }
  , instantiatedItems = initialCanvasItemInstances
  , selectedItems = List.take 1 initialCanvasItemInstances
  , itemsUnderCursor = []
  , currentItemUnderCursor = Nothing
  , cursorMode = FreeFormCursor
  , intent = ToExplore
  , canvasItemCount = List.length initialCanvasItemInstances
  , selectionMode = SingleSelect
  , hoveredItem = Nothing
  }

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    NoOp -> updateModelOnly model
    MouseMove coords ->
      let
        updatedModel = { model | cursorCoords = coords }
        newModel =
          case (updatedModel.cursorMode, updatedModel.intent) of
            (_, ToMovePath { id, item } index point) ->
              case item of
                Polyline points ->
                  let
                    updatePoint i pt = if i == index then coords else pt
                    newPoints = List.indexedMap updatePoint points
                    updatedItems = replaceCanvasItemInstanceById updatedModel.instantiatedItems id (Polyline newPoints)
                  in
                    { updatedModel | instantiatedItems = updatedItems }
                _ -> updatedModel
            (_, ToResizeCanvasItemInstance { id, item } startingCoords anchor) ->
              let
                newItem = resizeCanvasItem item startingCoords updatedModel.cursorCoords anchor
                updatedItems = replaceCanvasItemInstanceById updatedModel.instantiatedItems id newItem
              in
                { updatedModel
                | instantiatedItems = updatedItems
                -- Resizing means we're not selecting anything.
                , selectedItems = []
                }
            _ -> updatedModel
      in
        updateModelOnly newModel
    KeyPress key -> handleKeyDown model key
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
    ResizeItem item startingCursorCoords anchor ->
      updateModelOnly
        { model |
            intent = ToResizeCanvasItemInstance item startingCursorCoords anchor
        }
    HoveredItem item -> updateModelOnly { model | hoveredItem = Just item }
    UnhoveredItem -> updateModelOnly { model | hoveredItem = Nothing }
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
      case (model.cursorMode, model.intent) of
        (_, ToMovePath _ _ _) -> (model, Cmd.none)
        (_, ToCreatePolyline points) ->
          ( { model | intent = ToCreatePolyline (points ++ [coords]) }
          , Cmd.none
          )
        _ ->
          updateModelOnly
            { model
            | cursorMode = DragCursor coords
            }
    MouseUp ending ->
      case (model.cursorMode, model.intent) of
        (_, ToMovePath _ _ _) ->
          updateModelOnly { model | intent = ToExplore }
        (_, ToResizeCanvasItemInstance _ _ _) ->
          updateModelOnly { model | intent = ToExplore }
        (DragCursor starting, ToCreateCanvasItemInstance item) ->
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

itemsToSvg : List CanvasItem -> JE.Value
itemsToSvg items =
  let
    transformedItems = List.map transform items
    transform item =
      case item of
        Rect upperLeft lowerRight ->
          let
            left = upperLeft.x |> String.fromInt
            top = upperLeft.y |> String.fromInt
            width = lowerRight.x - upperLeft.x |> String.fromInt
            height = lowerRight.y - upperLeft.y |> String.fromInt
          in
            SI.interpolate
              "<g transform=\"translate({0}, {1})\"><rect width=\"{2}\" height=\"{3}\"></rect></g>"
              [left, top, width, height]
        Polyline points ->
          let
            firstPoint = List.head points |> Maybe.withDefault { x = 0, y = 0 }
            (left, top) = (firstPoint.x, firstPoint.y)
            translatedPoints = List.map translate points
            translate point = String.fromInt (point.x - left) ++ "," ++ String.fromInt (point.y - top)
          in
            SI.interpolate
              "<g transform=\"translate({0}, {1})\"><polyline points=\"{2}\"></polyline></g>"
              [String.fromInt left, String.fromInt top, String.join " " translatedPoints]
        Ellipse upperLeft lowerRight ->
          let
            (center, longRadius, shortRadius) = boundingBoxToEllipse upperLeft lowerRight
            left = upperLeft.x
            top = upperLeft.y
            centerRelativeLeft = center.x - left
            centerRelativeTop = center.y - top
          in
            SI.interpolate
              "<g transform=\"translate({0}, {1})\"><ellipse cx=\"{2}\" cy=\"{3}\" rx=\"{4}\" ry=\"{5}\"></ellipse></g>"
              (List.map String.fromInt [left, top, centerRelativeLeft, centerRelativeTop, longRadius, shortRadius])
        Text upperLeft text ->
          SI.interpolate
            "<g transform=\"translate({0}, {1})\"><text>{2}</text></g>"
            [String.fromInt upperLeft.x, String.fromInt upperLeft.y, text]
  in
    JE.string ("<svg>" ++ String.join "" transformedItems ++ "</svg>")

handleKeyDown : Model -> String -> (Model, Cmd Msg)
handleKeyDown model key =
  let
    createInstance = createNewCanvasItemInstance model
    defaultCmd = Cmd.none
  in
    case key of
      -- Multiple select
      "Shift" -> ({ model | selectionMode = MultipleSelect }, defaultCmd)
      -- Delete
      "Backspace" -> (deleteSelectedCanvasItemInstances model, defaultCmd)
      -- Copy
      "c" -> (copySelectedCanvasItemInstances model, defaultCmd)
      -- Save
      "s" -> (model, List.map .item model.instantiatedItems |> itemsToSvg |> saveSvg)
      "r" -> (createInstance <| Rect { x = 100, y = 100 } { x = 200, y = 200 }, defaultCmd)
      "p" ->
        case model.intent of
          ToCreatePolyline points ->
            let
              model2 = createInstance <| Polyline points
            in
              ({ model2 | intent = ToExplore }, defaultCmd)
          _ ->
            ({ model | intent = ToCreatePolyline [] }, defaultCmd)
      "e" -> (createInstance <| Ellipse { x = 100, y = 100 } { x = 150, y = 140 }, defaultCmd)
      "t" -> (createInstance <| Text { x = 100, y = 100 } "Text", defaultCmd)
      _ -> (model, defaultCmd)

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
    (newModel, copiedItems) = List.foldl foldCopy (model, []) model.selectedItems
    move instance = { instance | item = moveItem 20 20 instance.item }
    newItems = List.map move copiedItems
  in
    { newModel
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
      Text upperLeft label ->
        Text (move upperLeft) label

moveCoordinates : Int -> Int -> Coordinates -> Coordinates
moveCoordinates deltaX deltaY coords =
  { coords | x = coords.x + deltaX, y = coords.y + deltaY }

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
    move = moveCoordinates dx dy
    item =
      case canvasItem.item of
        Rect upperLeft lowerRight ->
          Rect (move upperLeft) (move lowerRight)
        Polyline points ->
          Polyline (List.map move points)
        Ellipse upperLeft lowerRight ->
          Ellipse (move upperLeft) (move lowerRight)
        Text upperLeft label ->
          Text (move upperLeft) label
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

resizeCanvasItem : CanvasItem -> Coordinates -> Coordinates -> AnchorPosition -> CanvasItem
resizeCanvasItem originalItem startingCoords currentCoords anchor =
  let
    deltaX = currentCoords.x - startingCoords.x
    deltaY = currentCoords.y - startingCoords.y
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
    polylineUnderConstruction =
      case model.intent of
        ToCreatePolyline points -> pointsToString points
        _ -> ""
    specialItems =
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
      , Svg.polyline
          [ SA.fill "white"
          , SA.stroke "black"
          , SA.points polylineUnderConstruction
          , SA.strokeWidth "1"
          , SA.markerEnd "url(#arrowhead)"
          ]
          []
      ]
  in
    Svg.svg
      [ SA.height "700"
      , SE.onMouseDown ClearSelection
      ]
      (specialItems ++ canvasItems)

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

displayResizeOption : Intent -> CanvasItemInstance -> Coordinates -> Coordinates -> Coordinates -> List (Svg.Svg Msg)
displayResizeOption intent item cursorCoords upperLeft lowerRight =
  let
    isResizing =
      case intent of
        ToResizeCanvasItemInstance _ _ _ -> True
        _ -> False
    width = lowerRight.x - upperLeft.x
    height = lowerRight.y - upperLeft.y
    toDisplay = isResizing || withinView cursorCoords upperLeft lowerRight
    makeCircle = makeResizeCircles cursorCoords item width height toDisplay
  in
    [ makeCircle UpperLeft
    , makeCircle UpperRight
    , makeCircle LowerLeft
    , makeCircle LowerRight
    ]

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
      Rect upperLeft lowerRight ->
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
      Polyline points ->
        let
          pointsString = pointsToString points
          toDisplayMovementCircles =
            case model.hoveredItem of
              Just hovered -> hovered == item
              Nothing -> False
          movementCircles = makeMovementCirlces itemToDisplay toDisplayMovementCircles points
        in
          Svg.g
            [ SE.onMouseDown (SelectItem item)
            , SE.onMouseOver (HoveredItem item)
            , SE.onMouseOut UnhoveredItem
            ]
            (
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
              ] ++ movementCircles
            )
      Ellipse upperLeft lowerRight ->
        let
          (center, longRadius, shortRadius) = boundingBoxToEllipse upperLeft lowerRight
          resizeOption = displayResizeOption model.intent itemToDisplay model.cursorCoords upperLeft lowerRight
        in
          Svg.g
            [ SE.onMouseDown (SelectItem item)
            , SA.transform ("translate(" ++ String.fromInt upperLeft.x ++ "," ++ String.fromInt upperLeft.y ++ ")")
            ]
            (
              [ Svg.ellipse
                  [ SA.fill "white"
                  , SA.stroke (if isSelected then "blue" else "black")
                  , SA.cx (String.fromInt longRadius)
                  , SA.cy (String.fromInt shortRadius)
                  , SA.rx (String.fromInt longRadius)
                  , SA.ry (String.fromInt shortRadius)
                  ]
                  []
              ] ++ resizeOption
            )
      Text upperLeft label ->
        Svg.text_
          [ SA.fill "black"
          , SA.fontSize "8pt"
          , SA.x (String.fromInt upperLeft.x)
          , SA.y (String.fromInt upperLeft.y)
          , SA.stroke (if isSelected then "blue" else "black")
          , SE.onMouseDown (SelectItem item)
          ]
          [ Svg.text label ]

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
