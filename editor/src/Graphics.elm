module Graphics exposing (..)

import Model as MD
import Constants as CS
import Svg
import Svg.Attributes as SA

pointWithinView : MD.Coordinates -> MD.Coordinates -> MD.Coordinates -> Bool
pointWithinView point upperLeft lowerRight =
  point.x >= upperLeft.x && point.y >= upperLeft.y &&
  point.x <= lowerRight.x && point.y <= lowerRight.y

padBoundingBox : MD.BoundingBoxCoordinates -> Int -> MD.BoundingBoxCoordinates
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

calculatePositionOutsideOfBoundingBox : (MD.Coordinates, MD.Coordinates) -> (MD.BoundingBoxCoordinates, String, String) -> (MD.BoundingBoxCoordinates, String, String)
calculatePositionOutsideOfBoundingBox bbox ((itemUL, itemLR), _, _) =
  let
    (itemX, itemY) = (itemUL.x + gapFromBoundingBox, itemUL.y + gapFromBoundingBox)
    (bbUL, bbLR) = padBoundingBox bbox CS.detectionPaddingSize
    (dx, dy) = calculateClosestPointDelta itemUL itemLR bbUL bbLR
    -- See https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/text-anchor
    (x, anchor) = if dx < 0 then (bbUL.x, "end") else (bbLR.x, "start")
    -- See https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/alignment-baseline
    (y, baseline) = if dy < 0 then (bbUL.y, "baseline") else (bbLR.y, "hanging")
    (ul, an, bl) =
      case (dx, dy, abs dx < abs dy) of
        (0, 0, _) -> ({ x = itemX, y = itemY }, "start", "baseline")
        (_, _, True) -> ({ x = x, y = itemY }, anchor, "baseline")
        (_, _, False) -> ({ x = itemX, y = y }, "start", baseline)
  in
    ((ul, ul), an, bl)

-- Given: upper-left of box A, lower-right of box A, upper-left of box B,
-- lower-right of box B, A intersects with B, do the following:
-- 1. Calculate the closest point outside of B to A's upper-left.
-- 2. Calculate the delta between that closest point and A's upper-left.
-- 3. Return the delta in the form of (xDelta, yDelta).
-- If A does not intersect with B, return (0, 0).
calculateClosestPointDelta : MD.Coordinates -> MD.Coordinates -> MD.Coordinates -> MD.Coordinates -> (Int, Int)
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

intersectingBoxes : MD.Coordinates -> MD.Coordinates -> MD.Coordinates -> MD.Coordinates -> Bool
intersectingBoxes aUL aLR bUL bLR =
  (aUL.x > bUL.x && aUL.y > bUL.y && aUL.x < bLR.x && aUL.y < bLR.y) ||
  (aLR.x > bUL.x && aLR.y > bUL.y && aLR.x < bLR.x && aLR.y < bLR.y)

pointsToString : List MD.Coordinates -> String
pointsToString points =
  let
    coordsToString { x, y } = String.fromInt x ++ "," ++ String.fromInt y
  in
    List.map coordsToString points |> String.join " "

boundingBoxToEllipse : MD.Coordinates -> MD.Coordinates -> (MD.Coordinates, Int, Int)
boundingBoxToEllipse upperLeft lowerRight =
  let
    radiusX = (lowerRight.x - upperLeft.x) // 2
    radiusY = (lowerRight.y - upperLeft.y) // 2
    centerX = upperLeft.x + radiusX
    centerY = upperLeft.y + radiusY
  in
    ({ x = centerX, y = centerY }, radiusX, radiusY)

addConnectingPoint : MD.Coordinates -> (MD.Coordinates, List MD.Coordinates) -> (MD.Coordinates, List MD.Coordinates)
addConnectingPoint next (pt, pts) =
  let
    connectingPoint = { x = next.x, y = pt.y }
  in
    (next, connectingPoint :: pt :: pts)

movementCircleAttributes : Bool -> List (Svg.Attribute MD.Msg)
movementCircleAttributes toDisplay =
  [ SA.d "M 5, 5 m -2, 0 a 2,2 0 1,0 5,0 a 2,2 0 1,0 -5,0"
  , SA.fill "white"
  , SA.stroke "black"
  , SA.visibility (if toDisplay then "visible" else "hidden")
  ]

-- Polylines in Arrowgrams are always in straight lines. i.e. No diagonal line.
straightenPolyline : List MD.Coordinates -> List MD.Coordinates
straightenPolyline points =
  case points of
    (x :: xs) ->
      let
        (last, list) = List.foldr addConnectingPoint (x, []) xs
      in
        List.reverse (last :: list)
    _ -> points

getClosestPoint : MD.Coordinates -> MD.Coordinates -> MD.Coordinates -> MD.Coordinates
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

-- TODO: Not used
ellipseToBoundingBox : Int -> Int -> Int -> Int -> MD.BoundingBoxCoordinates
ellipseToBoundingBox cX cY rX rY =
  ( { x = cX - rX, y = cY - rY }
  , { x = cX + rX, y = cY + rY }
  )
