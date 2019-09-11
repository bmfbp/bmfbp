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


-- *** Application model ***

type alias Flags = {}

type Msg
  = NoOp
  | MouseMove Coordinates
  | KeyPress String
  | ToggleSelect CanvasItemInstance
  | Point Coordinates
  | Mark Coordinates
  | Roll
  | Hit

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
  }

type alias Coordinates = { x : Int, y : Int }

-- This captures the state of some task that the user wants to
-- do in multiple steps.
type Intent
  -- e.g. Moving the mouse around
  = Explore
  | MoveSelectedCanvasItemInstances
  | CreateCanvasItemInstance CanvasItemInstance

type CursorMode
  = FreeFormCursor
  | DragCursor
  -- Parameter is the starting coordinates
  | PointAndMarkCursor Coordinates
  | RollAndHitCursor

type alias CanvasItemInstance = { id : Int, item : CanvasItem }

type CanvasItem
  = Part Coordinates Coordinates
  | Wire (List Coordinates)
  | SourceSink Coordinates Int
  | Text Coordinates String
  --| Comment Coordinates Coordinates Coordinates


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
  }

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    NoOp -> updateModelOnly model
    MouseMove coords ->
      updateModelOnly { model | cursorCoords = coords }
    KeyPress key -> handleKey model key |> updateModelOnly
    ToggleSelect item ->
      let
        selected =
          if isSelectedCanvasItemInstance model item
          then List.filter ((/=) item) model.selectedItems
          else item :: model.selectedItems
      in
        updateModelOnly { model | selectedItems = selected }
    Point coords ->
      updateModelOnly { model | cursorMode = PointAndMarkCursor coords }
    Mark ending ->
      case (model.cursorMode, model.intent) of
        (PointAndMarkCursor starting, CreateCanvasItemInstance item) ->
          updateModelOnly
            { model |
                instantiatedItems =
                  item :: model.instantiatedItems
            }
        (PointAndMarkCursor starting, _) ->
          let
            updatedModel = updateSelectedItemCoordinates model starting ending
          in
            updateModelOnly { updatedModel | cursorMode = FreeFormCursor }
        _ -> updateModelOnly { model | cursorMode = FreeFormCursor }
    -- TODO: To implement
    Roll -> updateModelOnly model
    -- TODO: To implement
    Hit -> updateModelOnly model

handleKey : Model -> String -> Model
handleKey model key =
  case key of
    "c" -> copySelectedCanvasItemInstances model
    _ -> model

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
    [ BE.onMouseDown (JD.map Point mouseDecoder)
    , BE.onMouseUp (JD.map Mark mouseDecoder)
    , BE.onMouseMove (JD.map MouseMove mouseDecoder)
    , BE.onKeyPress (JD.map KeyPress keyDecoder)
    ]

mouseDecoder : JD.Decoder Coordinates
mouseDecoder =
  JD.map2 Coordinates
    (JD.at [ "offsetX" ] JD.int)
    (JD.at [ "offsetY" ] JD.int)

keyDecoder : JD.Decoder String
keyDecoder =
  JD.field "key" JD.string

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
      if List.member item model.selectedItems
      then
        let updatedItem = updateCoordinates item
        in  (updatedItem, Just updatedItem)
      else (item, Nothing)
    (updatedItems, selectedItemMaybes) =
      List.map process model.instantiatedItems |> List.unzip
    selectedItems = List.filterMap identity selectedItemMaybes
  in
    { model | instantiatedItems = updatedItems, selectedItems = selectedItems }


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
  in
    Svg.svg [ SA.height "700" ] canvasItems

moveSelectedItems : Model -> CanvasItemInstance -> CanvasItemInstance
moveSelectedItems model item =
  case (model.cursorMode, model.cursorCoords) of
    (PointAndMarkCursor starting, current) ->
      updateItemCoordinates starting current item
    _ -> item

displayCanvasItemInstance : Model -> CanvasItemInstance -> Svg.Svg Msg
displayCanvasItemInstance model item =
  let
    isSelected = isSelectedCanvasItemInstance model item
    itemToDisplay =
      case (isSelected, model.cursorMode) of
        (True, PointAndMarkCursor _) -> moveSelectedItems model item
        _ -> item
  in
    case itemToDisplay.item of
      Part upperLeft lowerRight ->
        Svg.rect
          [ SA.fill "white"
          , SA.stroke (if isSelected then "blue" else "black")
          , SE.onClick (ToggleSelect item)
          , SA.x (String.fromInt upperLeft.x)
          , SA.y (String.fromInt upperLeft.y)
          , SA.width (String.fromInt (lowerRight.x - upperLeft.x))
          , SA.height (String.fromInt (lowerRight.y - upperLeft.y))
          ]
          []
      Wire points ->
        let
          coordsToString { x, y } = String.fromInt x ++ "," ++ String.fromInt y
          pointsString = List.map coordsToString points |> String.join " "
        in
          Svg.polyline
            [ SA.fill "white"
            , SA.stroke (if isSelected then "blue" else "black")
            , SE.onClick (ToggleSelect item)
            , SA.points pointsString
            ]
            []
      SourceSink center longRadius ->
        Svg.ellipse
          [ SA.fill "white"
          , SA.stroke (if isSelected then "blue" else "black")
          , SE.onClick (ToggleSelect item)
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
          , SE.onClick (ToggleSelect item)
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
