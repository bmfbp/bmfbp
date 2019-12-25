{-# LANGUAGE DeriveGeneric, DeriveAnyClass, NamedFieldPuns #-}

module Types.Part where

import qualified GHC.Generics as GG
import qualified Data.Aeson as DA
import qualified Data.Map as DMP

data Part =
  Part
    { kindName :: String
    , partName :: String
    , inCount  :: Int
    , outCount :: Int
    , inMap    :: DMP.Map String Int
    , outMap   :: DMP.Map String Int
    , inPins   :: [[Int]]
    , outPins  :: [[Int]]
    } deriving (Show, GG.Generic, DA.ToJSON, DA.FromJSON)

instance Semigroup Part where
  x <> y =
    let
      xInMapsCount = DMP.size $ inMap x
      yInMapsAdjusted = DMP.map (+ xInMapsCount) $ inMap y
      xOutMapsCount = DMP.size $ outMap x
      yOutMapsAdjusted = DMP.map (+ xOutMapsCount) $ outMap y
    in
      Part
        { kindName = "self"
        , partName = "self"
        , inCount  = inCount x + inCount y
        , outCount = outCount x + outCount y
        , inMap    = DMP.union (inMap x) yInMapsAdjusted
        , outMap   = DMP.union (outMap x) yOutMapsAdjusted
        , inPins   = inPins x ++ inPins y
        , outPins  = outPins x ++ outPins y
        }

instance Monoid Part where
  mempty =
    Part
      { kindName = ""
      , partName = ""
      , inCount  = 0
      , outCount = 0
      , inMap    = DMP.empty
      , outMap   = DMP.empty
      , inPins   = []
      , outPins  = []
      }
