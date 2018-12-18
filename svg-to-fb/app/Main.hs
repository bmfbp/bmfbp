module Main where

import qualified Parser as PSR
import qualified Data.Text.IO as DTI

main :: IO ()
main = DTI.interact PSR.parseSVG
