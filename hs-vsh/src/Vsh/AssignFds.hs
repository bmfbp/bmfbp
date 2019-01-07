module Vsh.AssignFds where

import Types.Diagram
import qualified Data.Map.Strict as DMS

assignFds :: Diagram -> Diagram
assignFds (Diagram facts) = Diagram (facts ++ sinks ++ sources)
  where
    portNames = DMS.fromList [ (x, y) | PortName x y <- facts ]
    sinks =
      [ SinkFileDescriptor id fd
      | Sink _ id <- facts
      , (Just fd) <- [DMS.lookup id portNames]
      ]
    sources =
      [ SourceFileDescriptor id fd
      | Source _ id <- facts
      , (Just fd) <- [DMS.lookup id portNames]
      ]
