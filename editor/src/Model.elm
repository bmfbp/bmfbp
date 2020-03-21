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

type alias GlobalState =
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

encodeFile : File -> JE.Value
encodeFile file =
  JE.object
    [ ( "version", JE.string CS.versionCanonicalFormat )
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

isSelectedCanvasItemInstance : GlobalState -> CanvasItemInstance -> Bool
isSelectedCanvasItemInstance model match = List.any (\i -> i.id == match.id) model.selectedItems

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

moveCoordinates : Int -> Int -> Coordinates -> Coordinates
moveCoordinates deltaX deltaY coords =
  { coords | x = coords.x + deltaX, y = coords.y + deltaY }
