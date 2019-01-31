module ParseDrawIO where

import qualified Parser.DrawIO as PDI
import qualified Data.Text.IO as DTI

main :: IO ()
main = DTI.interact PDI.parseSVG
