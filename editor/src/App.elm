module App exposing (..)

import Model as MD
import Constants as CS
import Graphics as GP
import Interop as IR
import Browser.Events as BE
import Json.Decode as JD
import Json.Encode as JE
import String.Interpolate as SI

factToProlog : MD.Fact -> String
factToProlog fact =
  case fact of
    MD.Single x -> SI.interpolate "{0}()." [x]
    MD.Double x y -> SI.interpolate "{0}({1})." [x, y]
    MD.Triple x y z -> SI.interpolate "{0}({1}, {2})." [x, y, z]

factToLisp : MD.Fact -> String
factToLisp fact =
  case fact of
    MD.Single x -> SI.interpolate "({0})" [x]
    MD.Double x y -> SI.interpolate "({0} {1})" [x, y]
    MD.Triple x y z -> SI.interpolate "({0} {1} {2})" [x, y, z]

serializeFacts : (MD.Fact -> String) -> List MD.Fact -> String
serializeFacts serializer facts = List.map serializer facts |> String.join "\n"

calculateActualCoords : MD.GlobalState -> MD.Coordinates -> MD.Coordinates
calculateActualCoords model coords =
  { x = (toFloat coords.x * model.zoomFactor |> round) + model.panCoords.x
  , y = (toFloat coords.y * model.zoomFactor |> round) + model.panCoords.y
  }

update : MD.Msg -> MD.GlobalState -> (MD.GlobalState, Cmd MD.Msg)
update message model =
  case message of
    MD.NoOp -> updateModelOnly model
    MD.SaveSchematic ->
      let
        -- In the future, get the component name from somewhere.
        componentName = "default-component-name"
        encodedFile =
          MD.encodeFile
            { moduleName = componentName
            , canvasItems = model.instantiatedItems
            }
      in
        (model, IR.saveFile encodedFile)
    MD.LoadSchematic -> (model, IR.loadFile (JE.null))
    MD.AddRect ->
      (createNewCanvasItemInstance model (MD.Rect { x = 100, y = 100 } { x = 200, y = 200 }), Cmd.none)
    MD.AddArrow ->
      case model.intent of
        MD.ToCreatePolyline _ points -> updateModelOnly <| addArrow model points
        _ ->
          ({ model | intent = MD.ToCreatePolyline model.cursorCoords [] }, Cmd.none)
    MD.AddEllipse ->
      (createNewCanvasItemInstance model (MD.Ellipse { x = 100, y = 100 } { x = 250, y = 200 }), Cmd.none)
    MD.AddText ->
      (createNewCanvasItemInstance model (MD.Text { x = 100, y = 100 } { x = 200, y = 200 } "text"), Cmd.none)
    MD.UpdateItemName item newName ->
      let
        updateName i = { i | name = newName }
      in
        (updateCanvasItemInstance model item updateName, Cmd.none)
    MD.UpdateItemGitUrl item newGitUrl ->
      let
        updateGitUrl i = { i | gitUrl = newGitUrl }
      in
        (updateCanvasItemInstance model item updateGitUrl, Cmd.none)
    MD.UpdateItemGitRef item newGitRef ->
      let
        updateGitRef i = { i | gitRef = newGitRef }
      in
        (updateCanvasItemInstance model item updateGitRef, Cmd.none)
    MD.UpdateItemContextDir item newContextDir ->
      let
        updateContextDir i = { i | contextDir = newContextDir }
      in
        (updateCanvasItemInstance model item updateContextDir, Cmd.none)
    MD.UpdateItemManifestPath item newManifestPath ->
      let
        updateManifestPath i = { i | manifestPath = newManifestPath }
      in
        (updateCanvasItemInstance model item updateManifestPath, Cmd.none)
    MD.UpdateSourcePinName item newName ->
      let
        updateSourcePinName i = { i | sourcePinName = newName }
      in
        (updateCanvasItemInstance model item updateSourcePinName, Cmd.none)
    MD.UpdateSinkPinName item newName ->
      let
        updateSinkPinName i = { i | sinkPinName = newName }
      in
        (updateCanvasItemInstance model item updateSinkPinName, Cmd.none)
    MD.UserIsTyping item -> updateModelOnly { model | intent = MD.ToType item }
    MD.UserIsNotTyping item -> updateModelOnly { model | intent = MD.ToExplore }
    MD.MouseMove coords ->
      let
        updatedModel = { model | cursorCoords = coords }
        newModel =
          case (updatedModel.cursorMode, updatedModel.intent) of
            -- Moving paths is handled differently than the rest because it
            -- doesn't have an anchor point.
            (_, MD.ToMovePath { id, item } index point) ->
              case item of
                MD.Polyline points ->
                  let
                    updatePoint i pt = if i == index then calculateActualCoords model coords else pt
                    newPoints = matchClosestRect model.instantiatedItems <| List.indexedMap updatePoint points
                    updatedItems = replaceCanvasItemInstanceById updatedModel.instantiatedItems id (MD.Polyline newPoints)
                  in
                    { updatedModel | instantiatedItems = updatedItems }
                _ -> updatedModel
            (_, MD.ToResizeCanvasItemInstance { id, item } startingCoords anchor) ->
              let
                newItem = resizeCanvasItem model.zoomFactor item startingCoords updatedModel.cursorCoords anchor
                updatedItems = replaceCanvasItemInstanceById updatedModel.instantiatedItems id newItem
              in
                { updatedModel
                | instantiatedItems = updatedItems
                -- Resizing means we're not selecting anything.
                , selectedItems = []
                }
            (_, MD.ToPanViewBox startingPanCoords startingCoords) ->
              { updatedModel
              | panCoords =
                  { x = startingPanCoords.x - (coords.x - startingCoords.x)
                  , y = startingPanCoords.y - (coords.y - startingCoords.y)
                  }
              }
            (_, MD.ToCreatePolyline _ points) ->
              { updatedModel
              | intent = MD.ToCreatePolyline (getCursorDropPointCoords updatedModel.instantiatedItems coords) points
              }
            _ -> updatedModel
      in
        updateModelOnly newModel
    MD.KeyPress key ->
      case model.intent of
        MD.ToType _ -> updateModelOnly model
        _ -> handleKeyDown model key
    MD.KeyUp key ->
      case model.intent of
        MD.ToType _ -> updateModelOnly model
        _ -> (handleKeyUp model key |> updateModelOnly)
    MD.SelectItem item ->
      case model.selectionMode of
        MD.SingleSelect ->
          updateModelOnly
            { model
            | selectedItems = [item]
            , cursorMode = MD.SelectionInProgress
            }
        MD.MultipleSelect ->
          let
            selected =
              if MD.isSelectedCanvasItemInstance model item
              then model.selectedItems
              else item :: model.selectedItems
            newSelectionMode =
              if List.length selected == 0
              then MD.SingleSelect
              else model.selectionMode
          in
            updateModelOnly
              { model
              | selectedItems = selected
              , selectionMode = newSelectionMode
              , cursorMode = MD.SelectionInProgress
              }
    MD.ResizeItem item startingCursorCoords anchor ->
      updateModelOnly
        { model
        | intent = MD.ToResizeCanvasItemInstance item startingCursorCoords anchor
        }
    MD.HoveredItem item -> updateModelOnly { model | hoveredItem = Just item }
    MD.UnhoveredItem -> updateModelOnly { model | hoveredItem = Nothing }
    MD.DoubleClick item ->
      case (model.intent, item) of
        (MD.ToCreatePolyline _ points, _) -> updateModelOnly <| addArrow model (List.take (List.length points - 1) points)
        (_, Just i) ->
          case i.item of
            (MD.Text _ _ _) -> updateModelOnly { model | intent = MD.ToType i }
            (MD.Polyline _) -> updateModelOnly <| updateCanvasItemInstance model i (addPointToPolyline model.cursorCoords)
            _ -> (model, Cmd.none)
        _ -> (model, Cmd.none)
    MD.MovePath path index point ->  updateModelOnly { model | intent = MD.ToMovePath path index point }
    MD.ClearSelection ->
      case model.cursorMode of
        MD.SelectionInProgress -> (model, Cmd.none)
        _ ->
          updateModelOnly
            { model
            | selectedItems = []
            , selectionMode = MD.SingleSelect
            }
    MD.MouseDown coords ->
      case (model.cursorMode, model.intent, model.selectedItems) of
        (_, MD.ToCreatePolyline dropPoint points, _) ->
          -- TODO: Next point should create angular lines
          ( { model | intent = MD.ToCreatePolyline dropPoint (points ++ [calculateActualCoords model dropPoint]) }, Cmd.none )
        (_, MD.ToMovePath _ _ _, _) ->
          (model, Cmd.none)
        -- The user wants to pan if there is no selected items.
        (_, _, []) ->
          updateModelOnly
            { model | intent = MD.ToPanViewBox model.panCoords model.cursorCoords }
        _ ->
          updateModelOnly
            { model | cursorMode = MD.DragCursor coords }
    MD.MouseUp coords ->
      case (model.cursorMode, model.intent) of
        (_, MD.ToMovePath _ _ _) ->
          updateModelOnly { model | intent = MD.ToExplore }
        (_, MD.ToResizeCanvasItemInstance _ _ _) ->
          updateModelOnly { model | intent = MD.ToExplore }
        (_, MD.ToPanViewBox _ _) ->
          updateModelOnly { model | intent = MD.ToExplore }
        (MD.DragCursor starting, MD.ToCreateCanvasItemInstance item) ->
          updateModelOnly
            { model
            | instantiatedItems = item :: model.instantiatedItems
            }
        (MD.DragCursor starting, _) ->
          let
            updatedModel = updateSelectedItemCoordinates model starting coords
          in
            updateModelOnly { updatedModel | cursorMode = MD.FreeFormCursor }
        _ -> updateModelOnly { model | cursorMode = MD.FreeFormCursor }
    MD.ViewPortHasResized result ->
      case result of
        Ok (width, height) -> updateModelOnly { model | viewPortSize = (width, height) }
        _ -> updateModelOnly model
    MD.FileHasBeenRead result ->
      case result of
        Ok content -> updateModelOnly { model | instantiatedItems = content.canvasItems }
        e ->
          let
            x = Debug.log "Error loading file: " e
          in
            updateModelOnly model

-- Given all instantiated items and a list of polyline points, match the first
-- (the source) and the last point (the sink) to the closest instantiated
-- item's boundary, if close enough.
matchClosestRect : List MD.CanvasItemInstance -> List MD.Coordinates -> List MD.Coordinates
matchClosestRect items points =
  case points of
    (first :: tail) ->
      case List.reverse tail of
        (last :: middle) ->
          let
            newFirst = List.foldl matchPointWithRect first items
            newLast = List.foldl matchPointWithRect last items
          in
            List.concat [[newFirst], middle, [newLast]]
        _ -> points
    _ -> points

matchPointWithRect : MD.CanvasItemInstance -> MD.Coordinates -> MD.Coordinates
matchPointWithRect item point =
  case item.item of
    MD.Rect ul lr ->
      let
        (bbUL, bbLR) = GP.padBoundingBox (ul, lr) CS.detectionPaddingSize
        (dx, dy) = GP.calculateClosestPointDelta point point bbUL bbLR
        x = if dx < 0 then ul.x else lr.x
        y = if dy < 0 then ul.y else lr.y
      in
        if GP.intersectingBoxes point point bbUL bbLR
        then if abs dx < abs dy then { x = x, y = point.y } else { x = point.x, y = y }
        else point
    _ -> point

addArrow : MD.GlobalState -> List MD.Coordinates -> MD.GlobalState
addArrow model points =
  let
    model2 = createNewCanvasItemInstance model <| MD.Polyline points
  in
    { model2 | intent = MD.ToExplore }

addPointToPolyline : MD.Coordinates -> MD.CanvasItemInstance -> MD.CanvasItemInstance
addPointToPolyline cursor item =
  case item.item of
    MD.Polyline points -> { item | item = MD.Polyline (List.append points [cursor]) }
    _ -> item

-- We convert to float because of legacy reason with the compiler.
fromInt x = String.fromInt x ++ ".0"
fromFloat x = String.fromInt (round x) ++ ".0"

zoom : MD.GlobalState -> Float -> (MD.GlobalState, Cmd MD.Msg)
zoom model zoomBy = ({ model | zoomFactor = model.zoomFactor * zoomBy }, Cmd.none)

handleKeyDown : MD.GlobalState -> String -> (MD.GlobalState, Cmd MD.Msg)
handleKeyDown model key =
  let
    defaultCmd = Cmd.none
  in
    case key of
      -- Multiple select
      "Shift" -> ({ model | selectionMode = MD.MultipleSelect }, defaultCmd)
      -- Delete
      "Backspace" -> (deleteSelectedCanvasItemInstances model, defaultCmd)
      -- Copy
      "c" -> (copySelectedCanvasItemInstances model, defaultCmd)
      -- Zoom in
      "=" -> zoom model (1.0 - CS.zoomStepSize)
      "+" -> zoom model (1.0 - CS.zoomStepSize)
      -- Zoom out
      "-" -> zoom model (1.0 + CS.zoomStepSize)
      -- No-op
      _ -> (model, defaultCmd)

handleKeyUp : MD.GlobalState -> String -> MD.GlobalState
handleKeyUp model key = model

createNewCanvasItemInstance : MD.GlobalState -> MD.CanvasItem -> MD.GlobalState
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

createNewCanvasItemInstance2 : MD.CanvasItem -> MD.GlobalState -> MD.GlobalState
createNewCanvasItemInstance2 item model = createNewCanvasItemInstance model item

deleteSelectedCanvasItemInstances : MD.GlobalState -> MD.GlobalState
deleteSelectedCanvasItemInstances model =
  { model
      | instantiatedItems = List.filter (\x -> not (List.member x model.selectedItems)) model.instantiatedItems
      , selectedItems = []
  }

copySelectedCanvasItemInstances : MD.GlobalState -> MD.GlobalState
copySelectedCanvasItemInstances model =
  let
    copiedItems = List.foldl (foldCopy model) [] model.selectedItems
    move instance = { instance | item = moveItem copyItemOffset copyItemOffset instance.item }
    newItems = List.map move copiedItems
  in
    { model
        | instantiatedItems = List.append newItems model.instantiatedItems
        , selectedItems = newItems
    }

moveItem : Int -> Int -> MD.CanvasItem -> MD.CanvasItem
moveItem deltaX deltaY item =
  let
    move = MD.moveCoordinates deltaX deltaY
  in
    case item of
      MD.Rect upperLeft lowerRight ->
        MD.Rect (move upperLeft) (move lowerRight)
      MD.Polyline points ->
        MD.Polyline <| List.map move points
      MD.Ellipse upperLeft lowerRight ->
        MD.Ellipse (move upperLeft) (move lowerRight)
      MD.Text upperLeft lowerRight label ->
        MD.Text (move upperLeft) (move lowerRight) label

foldCopy : MD.GlobalState -> MD.CanvasItemInstance -> List MD.CanvasItemInstance -> List MD.CanvasItemInstance
foldCopy model item newItems =
  let
    newItem = copyCanvasItemInstance model item
  in
    (newItem :: newItems)

findLargestId : List MD.CanvasItemInstance -> Int
findLargestId = List.map .id >> List.maximum >> Maybe.withDefault 0

copyCanvasItemInstance : MD.GlobalState -> MD.CanvasItemInstance -> MD.CanvasItemInstance
copyCanvasItemInstance model canvasItem =
  let
    newId = findLargestId model.instantiatedItems + 1
  in
    { canvasItem | id = newId }

updateModelOnly : MD.GlobalState -> (MD.GlobalState, Cmd MD.Msg)
updateModelOnly model = (model, Cmd.none)

updateCanvasItemInstance : MD.GlobalState -> MD.CanvasItemInstance -> (MD.CanvasItemInstance -> MD.CanvasItemInstance) -> MD.GlobalState
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

subscriptions : MD.GlobalState -> Sub MD.Msg
subscriptions model =
  Sub.batch
    [ BE.onMouseDown (JD.map MD.MouseDown mouseDecoder)
    , BE.onMouseUp (JD.map MD.MouseUp mouseDecoder)
    , BE.onMouseMove (JD.map MD.MouseMove mouseDecoder)
    , BE.onKeyDown (JD.map MD.KeyPress keyDecoder)
    , BE.onKeyUp (JD.map MD.KeyUp keyDecoder)
    , IR.viewPortHasResized (JD.decodeValue viewPortDecoder >> MD.ViewPortHasResized)
    , IR.fileHasBeenRead (JD.decodeValue MD.fileDecoder >> MD.FileHasBeenRead)
    ]

viewPortDecoder : JD.Decoder (Int, Int)
viewPortDecoder =
  JD.map2 Tuple.pair
    (JD.index 0 JD.int)
    (JD.index 1 JD.int)

mouseDecoder : JD.Decoder MD.Coordinates
mouseDecoder =
  JD.map2 MD.Coordinates
    (JD.at [ "offsetX" ] JD.int)
    (JD.at [ "offsetY" ] JD.int)

keyDecoder : JD.Decoder String
keyDecoder = JD.field "key" JD.string

updateSelectedItemCoordinates : MD.GlobalState -> MD.Coordinates -> MD.Coordinates -> MD.GlobalState
updateSelectedItemCoordinates model starting ending =
  let
    updateCoordinates = MD.updateItemCoordinates model.zoomFactor starting ending
    process item =
      if MD.isSelectedCanvasItemInstance model item
      then
        let updatedItem = updateCoordinates item
        in  (updatedItem, Just updatedItem)
      else (item, Nothing)
    (updatedItems, selectedItemMaybes) =
      List.map process model.instantiatedItems |> List.unzip
    selectedItems = List.filterMap identity selectedItemMaybes
  in
    { model | instantiatedItems = updatedItems, selectedItems = selectedItems }

resizeCanvasItem : Float -> MD.CanvasItem -> MD.Coordinates -> MD.Coordinates -> MD.AnchorPosition -> MD.CanvasItem
resizeCanvasItem zoomFactor originalItem startingCoords currentCoords anchor =
  let
    deltaX = toFloat (currentCoords.x - startingCoords.x) * zoomFactor |> round
    deltaY = toFloat (currentCoords.y - startingCoords.y) * zoomFactor |> round
    threshold = CS.itemResizeThreshold
  in
    case originalItem of
      MD.Rect upperLeft lowerRight ->
        case anchor of
          MD.UpperLeft ->
            MD.Rect
              { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
              , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
              }
              lowerRight
          MD.UpperRight ->
            MD.Rect
              { x = upperLeft.x
              , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
              }
              { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
              , y = lowerRight.y
              }
          MD.LowerLeft ->
            MD.Rect
              { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
              , y = upperLeft.y
              }
              { x = lowerRight.x
              , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
              }
          MD.LowerRight ->
            MD.Rect
              upperLeft
              { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
              , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
              }
      MD.Ellipse upperLeft lowerRight ->
        let
          (newUpperLeft, newLowerRight) =
            case anchor of
              MD.UpperLeft ->
                ( { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
                  , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
                  }
                , lowerRight
                )
              MD.UpperRight ->
                ( { x = upperLeft.x
                  , y = min (lowerRight.y - threshold) (upperLeft.y + deltaY)
                  }
                , { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
                  , y = lowerRight.y
                  }
                )
              MD.LowerLeft ->
                ( { x = min (lowerRight.x - threshold) (upperLeft.x + deltaX)
                  , y = upperLeft.y
                  }
                , { x = lowerRight.x
                  , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
                  }
                )
              MD.LowerRight ->
                ( upperLeft
                , { x = max (upperLeft.x + threshold) (lowerRight.x + deltaX)
                  , y = max (upperLeft.y + threshold) (lowerRight.y + deltaY)
                  }
                )
        in
          MD.Ellipse newUpperLeft newLowerRight
      _ -> originalItem

replaceCanvasItemInstanceById : List MD.CanvasItemInstance -> Int -> MD.CanvasItem -> List MD.CanvasItemInstance
replaceCanvasItemInstanceById allItems id newItem =
  let
    replaceItem item =
      if item.id == id
      then { item | item = newItem }
      else item
  in
    List.map replaceItem allItems

getCursorDropPointCoords : List MD.CanvasItemInstance -> MD.Coordinates -> MD.Coordinates
getCursorDropPointCoords canvasItems cursorCoords =
  let
    tolerance = CS.cursorSnapTolerance
    moveTopLeft point by = { point | x = point.x - by, y = point.y - by }
    moveBottomRight point by = { point | x = point.x + by, y = point.y + by }
    findFirstClosestItem item found =
      case found of
        Just _ -> found
        Nothing ->
          case item.item of
            MD.Polyline points -> Nothing
            MD.Text _ _ _ -> Nothing
            MD.Rect topLeft bottomRight ->
              if GP.pointWithinView cursorCoords (moveTopLeft topLeft tolerance) (moveBottomRight bottomRight tolerance)
              then Just <| GP.getClosestPoint topLeft bottomRight cursorCoords
              else Nothing
            MD.Ellipse topLeft bottomRight ->
              -- TODO: Find the point on the curve instead of the bounding box.
              if GP.pointWithinView cursorCoords (moveTopLeft topLeft tolerance) (moveBottomRight bottomRight tolerance)
              then Just <| GP.getClosestPoint topLeft bottomRight cursorCoords
              else Nothing
  in
    Maybe.withDefault cursorCoords <| List.foldl findFirstClosestItem Nothing canvasItems
