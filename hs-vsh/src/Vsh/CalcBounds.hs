module Vsh.CalcBounds where

import Prelude hiding (Left, Right)
import Types.Diagram
import qualified Data.List.Extra as DLE

calcBounds :: Diagram -> Diagram
calcBounds (Diagram facts) = Diagram (facts ++ newFacts)
  where
    newFacts = concat
      [
        [ BoundingBox Left nx x
        , BoundingBox Top nx y
        , BoundingBox Right nx (x + width)
        , BoundingBox Bottom nx (y + height)
        ]
          | (Geometry X nx x) <- facts
          , (Geometry Y ny y) <- facts
          , (Geometry Width nw width) <- facts
          , (Geometry Height nh height) <- facts
          , DLE.allSame [nx, ny, nw, nh]
      ]
