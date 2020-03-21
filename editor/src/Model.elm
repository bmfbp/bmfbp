module Model exposing (..)

import Constants as CS
import Json.Decode as JD
import Json.Encode as JE
import Json.Decode.Extra as JDE

type alias Flags = {}

type Msg
  = NoOp
  | SaveSchematic
  | LoadSchematic
  | AddRect
  | AddEllipse
  | AddArrow
  | AddText
  | UpdateItemName CanvasItem String
  | UpdateSourcePinName CanvasItem String
  | UpdateSinkPinName CanvasItem String
  | UpdateItemGitUrl CanvasItem String
  | UpdateItemGitRef CanvasItem String
  | UpdateItemContextDir CanvasItem String
  | UpdateItemManifestPath CanvasItem String
  | UserIsTyping CanvasItem
  | UserIsNotTyping CanvasItem
  | MouseMove Coordinates
  | KeyPress String
  | KeyUp String
  | SelectItem CanvasItem
  | ResizeItem CanvasItem Coordinates AnchorPosition
  | HoveredItem CanvasItem
  | DoubleClick (Maybe CanvasItem)
  | MovePath CanvasItem Int Coordinates
  | UnhoveredItem
  | ClearSelection
  | MouseDown Coordinates
  | MouseUp Coordinates
  | ViewPortHasResized (Result JD.Error (Int, Int))
  | FileHasBeenRead (Result JD.Error File)

type SelectionMode = SingleSelect | MultipleSelect

type alias GlobalState =
  { cursorCoords : Coordinates
  , instantiatedItems : List CanvasItem
  , selectedItems : List CanvasItem
  , itemsUnderCursor : List CanvasItem
  -- Out of the items under cursor, only one item (or none) can be selected.
  , currentItemUnderCursor : Maybe CanvasItem
  , cursorMode : CursorMode
  , intent : Intent
  , selectionMode : SelectionMode
  , hoveredItem : Maybe CanvasItem
  , zoomFactor : Float
  , panCoords : Coordinates
  , viewPortSize : (Int, Int)
  }

type alias File =
  { moduleName : String
  , canvasItems : List CanvasItem
  }

type alias Coordinates = { x : Int, y : Int }
type alias BoundingBoxCoordinates = (Coordinates, Coordinates)

-- This captures the state of some task that the user wants to
-- do in multiple steps.
type Intent
  -- Default state: Moving the mouse around
  = ToExplore
  | ToMoveSelectedCanvasItems
  | ToResizeCanvasItem CanvasItem Coordinates AnchorPosition
  | ToCreateCanvasItem CanvasItem
  | ToMovePath CanvasItem Int Coordinates
  -- The first parameter is the next point to be drawn and the second parameter
  -- is the rest of the points from which to draw the polyline.
  | ToCreatePolyline Coordinates (List Coordinates)
  -- Parameters are the starting pan coordinates and starting cursor
  -- coordinates.
  | ToPanViewBox Coordinates Coordinates
  -- When the user is typing text to a particular item
  | ToType CanvasItem

type CursorMode
  = FreeFormCursor
  -- Parameter is the starting coordinates
  | DragCursor Coordinates
  -- This is needed to deal with all the events being fired
  -- when the user triggers a mousedown event.
  | SelectionInProgress

type alias ShapeId = Int

-- These are the items actually displayed on the canvas.
type alias CanvasItem =
  { id : ShapeId
  , shape : Shape
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
type Shape
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

encodeFile : File -> JE.Value
encodeFile file =
  JE.object
    [ ( "version", JE.string CS.versionCanonicalFormat )
    , ( "moduleName", JE.string file.moduleName )
    , ( "canvasItems", JE.list encodeCanvasItem file.canvasItems )
    ]

encodeCanvasItem : CanvasItem -> JE.Value
encodeCanvasItem canvasItem =
  JE.object
    [ ( "id", JE.int canvasItem.id )
    , ( "shape", encodeShape canvasItem.shape )
    , ( "kindName", JE.string canvasItem.name )
    , ( "gitUrl", JE.string canvasItem.gitUrl )
    , ( "gitRef", JE.string canvasItem.gitRef )
    , ( "contextDir", JE.string canvasItem.contextDir )
    , ( "manifestPath", JE.string canvasItem.manifestPath )
    , ( "sourcePinName", JE.string canvasItem.sourcePinName )
    , ( "sinkPinName", JE.string canvasItem.sinkPinName )
    ]

encodeShape : Shape -> JE.Value
encodeShape shape =
  case shape of
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
        (JD.field "canvasItems" (JD.list canvasItemDecoder20191219))
    "2020-03-21" ->
      JD.map2 File
        (JD.field "moduleName" JD.string)
        (JD.field "canvasItems" (JD.list canvasItemDecoder))
    _ ->
      JD.fail <| "Unknown version: " ++ version

canvasItemDecoder20191219 : JD.Decoder CanvasItem
canvasItemDecoder20191219 =
  JD.succeed CanvasItem
    |> JDE.andMap (JD.field "id" JD.int)
    |> JDE.andMap (JD.field "item" shapeDecoder)
    |> JDE.andMap (JD.field "kindName" JD.string)
    |> JDE.andMap (JD.field "gitUrl" JD.string)
    |> JDE.andMap (JD.field "gitRef" JD.string)
    |> JDE.andMap (JD.field "contextDir" JD.string)
    |> JDE.andMap (JD.field "manifestPath" JD.string)
    |> JDE.andMap (JD.field "sourcePinName" JD.string)
    |> JDE.andMap (JD.field "sinkPinName" JD.string)

canvasItemDecoder : JD.Decoder CanvasItem
canvasItemDecoder =
  JD.succeed CanvasItem
    |> JDE.andMap (JD.field "id" JD.int)
    |> JDE.andMap (JD.field "shape" shapeDecoder)
    |> JDE.andMap (JD.field "kindName" JD.string)
    |> JDE.andMap (JD.field "gitUrl" JD.string)
    |> JDE.andMap (JD.field "gitRef" JD.string)
    |> JDE.andMap (JD.field "contextDir" JD.string)
    |> JDE.andMap (JD.field "manifestPath" JD.string)
    |> JDE.andMap (JD.field "sourcePinName" JD.string)
    |> JDE.andMap (JD.field "sinkPinName" JD.string)

shapeDecoder : JD.Decoder Shape
shapeDecoder =
  JD.field "tag" JD.string
    |> JD.andThen shapeContent

shapeContent : String -> JD.Decoder Shape
shapeContent contentType =
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

isSelectedCanvasItem : GlobalState -> CanvasItem -> Bool
isSelectedCanvasItem model match = List.any (\i -> i.id == match.id) model.selectedItems

updateItemCoordinates : Float -> Coordinates -> Coordinates -> CanvasItem -> CanvasItem
updateItemCoordinates zoomFactor starting ending canvasItem =
  let
    dx = toFloat (ending.x - starting.x) * zoomFactor |> round
    dy = toFloat (ending.y - starting.y) * zoomFactor |> round
    move = moveCoordinates dx dy
    shape =
      case canvasItem.shape of
        Rect upperLeft lowerRight ->
          Rect (move upperLeft) (move lowerRight)
        Polyline points ->
          Polyline (List.map move points)
        Ellipse upperLeft lowerRight ->
          Ellipse (move upperLeft) (move lowerRight)
        Text upperLeft lowerRight label ->
          Text (move upperLeft) (move lowerRight) label
  in
    { canvasItem | shape = shape }

moveCoordinates : Int -> Int -> Coordinates -> Coordinates
moveCoordinates deltaX deltaY coords =
  { coords | x = coords.x + deltaX, y = coords.y + deltaY }
