module Types where

import qualified Data.List as DL
import qualified Data.Text as DT

type Pair = (DT.Text, DT.Text)
type HttpRequest = [Pair]

getHeader :: HttpRequest -> DT.Text -> Maybe DT.Text
getHeader request name = DL.find ((== name) . fst) request >>= return . snd
