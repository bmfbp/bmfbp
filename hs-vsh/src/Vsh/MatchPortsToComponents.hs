module Vsh.MatchPortsToComponents where

import Prelude hiding (Left, Right)
import Types.Diagram
import qualified Data.List.Extra as DLE
import qualified Data.Array as DAR
import qualified Data.Map.Strict as DMS

matchPorts :: Diagram -> Diagram
matchPorts (Diagram facts) = Diagram (facts ++ newFacts)
  where
    -- Bin each type of facts that we want for performance.
    childNIds = [ x | ElementType x Port <- facts ]
    parentNIds = [ x | ElementType x Box <- facts ]
    leftBB = DMS.fromList [ (x, y) | BoundingBox Left x y <- facts ]
    topBB = DMS.fromList [ (x, y) | BoundingBox Top x y <- facts ]
    rightBB = DMS.fromList [ (x, y) | BoundingBox Right x y <- facts ]
    bottomBB = DMS.fromList [ (x, y) | BoundingBox Bottom x y <- facts ]
    -- Match parents.
    newFacts =
      [
        Parent cId pId
          | cId <- childNIds
          , pId <- parentNIds
          , (Just cl) <- [DMS.lookup cId leftBB]
          , (Just ct) <- [DMS.lookup cId topBB]
          , (Just cr) <- [DMS.lookup cId rightBB]
          , (Just cb) <- [DMS.lookup cId bottomBB]
          , (Just pl) <- [DMS.lookup pId leftBB]
          , (Just pt) <- [DMS.lookup pId topBB]
          , (Just pr) <- [DMS.lookup pId rightBB]
          , (Just pb) <- [DMS.lookup pId bottomBB]
          , intersect cl ct cr cb pl pt pr pb
      ]
    intersect cl ct cr cb pl pt pr pb =
      cl <= pr && cr >= pl && ct <= pb && cb >= pt
