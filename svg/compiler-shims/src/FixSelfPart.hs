{-# LANGUAGE DeriveGeneric, DeriveAnyClass, NamedFieldPuns #-}

module FixSelfPart
  ( fixSelfInManifest
  ) where

import qualified Data.Aeson as DA
import qualified Data.Map as DMP
import qualified Types.Part as TPT
import qualified Types.Manifest as TMF
import qualified Data.ByteString.Lazy.Char8 as DBLC
import qualified Data.List as DLS

fixSelfInManifest :: String -> String
fixSelfInManifest input = DBLC.unpack $ DA.encode fixedPart
  where
    isSelfPart x = TPT.kindName x == "self"
    manifest =
      case (DA.decode (DBLC.pack input) :: Maybe TMF.Manifest) of
        Nothing -> error "Invalid manifest file"
        Just x -> x
    (selfParts, realParts) = DLS.partition isSelfPart (TMF.parts manifest)
    selfPart = invertInsAndOuts $ mconcat selfParts
    fixedPart = manifest { TMF.self = Just selfPart, TMF.parts = realParts }

-- The input pins and the output pins are inverted when we are looking at the
-- "self" part, which is the schematic itself.  Think of it this way: an
-- ellipse on a schematic receiving packets from another part (i.e. an arrow
-- points to this ellipse) turns into a "self" part with an "input pin" because
-- an arrow is pointing to it. However, as a schematic, this is an "output"
-- pin. So we need invert the ins and the outs.
invertInsAndOuts :: TPT.Part -> TPT.Part
invertInsAndOuts self =
  self
    { TPT.inCount = TPT.outCount self
    , TPT.outCount = TPT.inCount self
    , TPT.inMap = TPT.outMap self
    , TPT.outMap = TPT.inMap self
    , TPT.inPins = TPT.outPins self
    , TPT.outPins = TPT.inPins self
    }
