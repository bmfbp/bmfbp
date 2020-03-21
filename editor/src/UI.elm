module UI exposing (..)

import Model as MD
import Constants as CS
import Graphics as GP
import Browser
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
import String.Interpolate as SI

view : MD.GlobalState -> Browser.Document MD.Msg
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
                           , El.height (El.px <| Tuple.second model.viewPortSize - CS.menuHeight)
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

menu : El.Element MD.Msg
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
      [ El.height (El.px CS.menuHeight)
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
      [ item [ EE.onClick MD.SaveSchematic ] (El.text "Save")
      , item [ EE.onClick MD.LoadSchematic ] (El.text "Load")
      ]

palette : El.Element MD.Msg
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
              [ EE.onClick MD.AddRect
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
              [ EE.onClick MD.AddEllipse
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
              [ EE.onClick MD.AddArrow
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

propertyPanel : MD.GlobalState -> El.Element MD.Msg
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

itemPropertyPanel : MD.CanvasItem -> List (El.Element MD.Msg)
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
        [ EE.onFocus (MD.UserIsTyping item)
        , EE.onLoseFocus (MD.UserIsNotTyping item)
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
        ( case item.shape of
            MD.Rect _ _ ->
              [ textField MD.UpdateItemName item.name "e.g. Compile composite" "Part name"
              , textField MD.UpdateItemGitUrl item.gitUrl "e.g. https://github.com/arrowgrams/arrowgrams.git" "Git URL"
              , textField MD.UpdateItemGitRef item.gitRef "e.g. 1b83cf3" "Git ref"
              , textField MD.UpdateItemContextDir item.contextDir "e.g. build_process/parts/" "Context directory to run in"
              , textField MD.UpdateItemManifestPath item.manifestPath "e.g. compile_composite.json" "Manifest path relative to the context directoryModel."
              ]
            MD.Ellipse _ _ ->
              [ textField MD.UpdateItemName item.name "Pin's name here" "Pin name"
              ]
            MD.Polyline _ ->
              [ textField MD.UpdateSourcePinName item.sourcePinName "source" "Source pin name"
              , textField MD.UpdateSinkPinName item.sinkPinName "sink" "Sink pin name"
              ]
            _ -> []
        )
    ]

canvas : MD.GlobalState -> Html.Html MD.Msg
canvas model =
  let
    canvasItems = List.map (displayCanvasItem model) model.instantiatedItems
    (polylineUnderConstruction, pointUnderCursorCoords) =
      case model.intent of
        MD.ToCreatePolyline cursorCoords points -> (GP.pointsToString points, Just cursorCoords)
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
      , SE.onMouseDown MD.ClearSelection
      , SE.on "dblclick" (JD.succeed <| MD.DoubleClick Nothing)
      -- TODO: View box isn't working. Fix before enabling.
      --, SA.viewBox viewBoxDims
      ]
      -- Note that we want `specialItems` to be after because of SVG rendering
      -- order.
      (backgroundItems ++ canvasItems ++ specialItems)

makeMovementCirlces : MD.CanvasItem -> Bool -> List MD.Coordinates -> List (Svg.Svg MD.Msg)
makeMovementCirlces item toDisplay points =
  let
    makeCircle i { x, y } =
      Svg.path
        ( GP.movementCircleAttributes toDisplay ++
          [ SA.transform ("translate(" ++ String.fromInt (x - 5) ++ "," ++ String.fromInt (y - 5) ++ ")")
          , SE.onMouseDown (MD.MovePath item i { x = x, y = y})
          ]
        )
        []
  in
    List.indexedMap makeCircle points

-- Selection circle around visual elements for resizing.
makeResizeCircles : MD.Coordinates -> MD.CanvasItem -> Int -> Int -> Bool -> MD.AnchorPosition -> Svg.Svg MD.Msg
makeResizeCircles cursorCoords item width height toDisplay anchor =
  let
    (offsetX, offsetY) =
      case anchor of
        MD.UpperLeft -> (0, 0)
        MD.UpperRight -> (width, 0)
        MD.LowerLeft -> (0, height)
        MD.LowerRight -> (width, height)
    x = String.fromInt (offsetX - 5)
    y = String.fromInt (offsetY - 5)
  in
    Svg.path
      (
        GP.movementCircleAttributes toDisplay ++
          [ SA.transform ("translate(" ++ x ++ "," ++ y ++ ")")
          , SE.onMouseDown (MD.ResizeItem item cursorCoords anchor)
          ]
      )
      []

displayResizeOption : Bool -> MD.Intent -> MD.CanvasItem -> MD.Coordinates -> MD.Coordinates -> MD.Coordinates -> List (Svg.Svg MD.Msg)
displayResizeOption isItemHovered intent item cursorCoords upperLeft lowerRight =
  let
    isResizing =
      case intent of
        MD.ToResizeCanvasItem _ _ _ -> True
        _ -> False
    width = lowerRight.x - upperLeft.x
    height = lowerRight.y - upperLeft.y
    toDisplay = isResizing || isItemHovered
    makeCircle = makeResizeCircles cursorCoords item width height toDisplay
  in
    [ makeCircle MD.UpperLeft
    , makeCircle MD.UpperRight
    , makeCircle MD.LowerLeft
    , makeCircle MD.LowerRight
    ]

moveSelectedItems : MD.GlobalState -> MD.CanvasItem -> MD.CanvasItem
moveSelectedItems model item =
  case (model.cursorMode, model.cursorCoords) of
    (MD.DragCursor starting, current) ->
      MD.updateItemCoordinates model.zoomFactor starting current item
    _ -> item

displayCanvasItem : MD.GlobalState -> MD.CanvasItem -> Svg.Svg MD.Msg
displayCanvasItem model item =
  let
    isSelected = MD.isSelectedCanvasItem model item
    itemToDisplay =
      case (isSelected, model.cursorMode) of
        (True, MD.DragCursor _) -> moveSelectedItems model item
        _ -> item
    isItemHovered =
      case model.hoveredItem of
        Just hovered -> hovered == item
        Nothing -> False
    toDisplayResizeOption = displayResizeOption isItemHovered model.intent itemToDisplay model.cursorCoords
  in
    case itemToDisplay.shape of
      MD.Rect upperLeft lowerRight ->
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
            [ SE.onMouseDown (MD.SelectItem item)
            , SE.onMouseOver (MD.HoveredItem item)
            , SE.onMouseOut MD.UnhoveredItem
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
      MD.Polyline rawPoints ->
        let
          straightenedPoints = GP.straightenPolyline rawPoints
          pointsString = GP.pointsToString straightenedPoints
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
            [ SE.onMouseDown (MD.SelectItem item)
            , SE.onMouseOver (MD.HoveredItem item)
            , SE.onMouseOut MD.UnhoveredItem
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
                    , SA.strokeWidth "5"
                    , SE.on "dblclick" (JD.succeed <| MD.DoubleClick (Just item))
                    ]
                    []
                )
              ] ++ movementCircles ++ nameTexts
            )
      MD.Ellipse upperLeft lowerRight ->
        let
          (center, radiusX, radiusY) = GP.boundingBoxToEllipse upperLeft lowerRight
          resizeOption = toDisplayResizeOption upperLeft lowerRight
        in
          Svg.g
            [ SE.onMouseDown (MD.SelectItem item)
            , SE.onMouseOver (MD.HoveredItem item)
            , SE.onMouseOut MD.UnhoveredItem
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
      MD.Text upperLeft lowerRight label ->
        let
          isEditing =
            case model.intent of
              MD.ToType i -> i.id == item.id
              _ -> False
        in
          Svg.g
            [ SE.onMouseDown (MD.SelectItem item)
            , SE.on "dblclick" (JD.succeed <| MD.DoubleClick (Just item))
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

calculatePinNamePosition : List MD.CanvasItem -> MD.Coordinates -> (MD.BoundingBoxCoordinates, String, String)
calculatePinNamePosition instantiatedItems coords =
  let
    rects = List.filterMap (.shape >> getCoords) instantiatedItems
    getCoords item =
      case item of
        (MD.Rect upperLeft lowerRight) -> Just (upperLeft, lowerRight)
        _ -> Nothing
    -- TODO: Faking the lower right of the pin name since we don't have access
    -- to the width and height of the text. Find better workaround
    pinNameLR = { x = coords.x + 100, y = coords.y + 100 }
    seed = ((coords, pinNameLR), "start", "baseline")
  in
    List.foldl GP.calculatePositionOutsideOfBoundingBox seed rects
