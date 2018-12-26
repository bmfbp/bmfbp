module Vsh.CalcBounds where

import Prelude hiding (Left, Right)
import Types.Diagram
import qualified Data.List as DLT

calcBounds :: Diagram -> Diagram
calcBounds (Diagram facts) = Diagram (facts ++ newFacts)
  where
    (geometryFacts, geometryNodeIds) =
      unzip [ (fact, nodeId) | fact@(Geometry _ nodeId _) <- facts ]
    nodeIds = DLT.nub geometryNodeIds
    newFacts = DLT.concat $ DLT.map (boundingBoxFacts geometryFacts) nodeIds

boundingBoxFacts :: [DiagramFact] -> NodeId -> [DiagramFact]
boundingBoxFacts facts nodeId = newFacts
  where
    (x, y, w, h) = head
      [ (x, y, width, height)
        | (Geometry X nx x) <- facts
        , (Geometry Y ny y) <- facts
        , (Geometry Width nw width) <- facts
        , (Geometry Height nh height) <- facts
        , nx == nodeId
        , ny == nodeId
        , nw == nodeId
        , nh == nodeId
      ]
    newFacts =
      [ BoundingBox Left nodeId x
      , BoundingBox Top nodeId y
      , BoundingBox Right nodeId (x + w)
      , BoundingBox Bottom nodeId (y + h)
      ]
