{-# LANGUAGE DeriveGeneric, DeriveAnyClass, NamedFieldPuns #-}

module Types.Metadata where

import qualified GHC.Generics as GG
import qualified Data.Aeson as DA

data Metadata =
  Metadata
    { gitRef       :: String
    , contextDir   :: String
    , gitUrl       :: String
    , manifestPath :: String
    , kindName     :: String
    } deriving (Show, GG.Generic, DA.ToJSON, DA.FromJSON)
