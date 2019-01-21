module ParseDrawIO where

import qualified Parser.DrawIO as PDI
import qualified Data.Text.IO as DTI
import qualified System.Environment as SE

main :: IO ()
main = do
    args <- SE.getArgs
    let componentNameMb =
          case args of
            (head : _) -> Just head
            _ -> Nothing
    DTI.interact $ PDI.parseSVG componentNameMb
