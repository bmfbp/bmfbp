module Main where

import qualified Parser as PS
import qualified System.Directory as SD
import qualified System.Environment as SE
import qualified Data.Text.IO as DTI

main :: IO ()
main = do
  args <- SE.getArgs
  let inputFilePath = head args
  inputFileExistP <- SD.doesFileExist inputFilePath
  if not inputFileExistP
    then error $ "No input file found at '" ++ inputFilePath ++ "'"
    else do
      inputFileContent <- DTI.readFile inputFilePath
      DTI.putStrLn $ PS.parseSVG inputFileContent
