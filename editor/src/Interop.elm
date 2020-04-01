port module Interop exposing (..)

import Json.Encode as JE

port saveFile : JE.Value -> Cmd msg
port loadFile : JE.Value -> Cmd msg
port viewPortHasResized : (JE.Value -> msg) -> Sub msg
port fileHasBeenRead : (JE.Value -> msg) -> Sub msg
