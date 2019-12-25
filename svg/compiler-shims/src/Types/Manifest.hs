{-# LANGUAGE DeriveGeneric, DeriveAnyClass, NamedFieldPuns #-}

module Types.Manifest where

import qualified GHC.Generics as GG
import qualified Data.Aeson as DA
import qualified Types.Part as TPT

data Manifest =
  Manifest
    { kindName    :: String
    , wireCount   :: Int
    , metaData    :: String
    , self        :: Maybe TPT.Part
    , parts       :: [TPT.Part]
    } deriving (Show, GG.Generic, DA.ToJSON, DA.FromJSON)
