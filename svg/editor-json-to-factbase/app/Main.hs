module Main where

import EditorJsonToFactbase
import qualified Data.Aeson as DA
import qualified Data.ByteString.Lazy as DBL
import qualified System.IO as SIO
import qualified System.Environment as SEV
import qualified System.Directory as SDR
import qualified Control.Monad as CMN

main :: IO ()
main = do
  args <- SEV.getArgs
  let filePath =
        case args of
          (x : _) -> x
          _ -> error "Expecting arguments: filePath"
  fileExists <- SDR.doesFileExist filePath
  CMN.unless fileExists $ error $ "File does not exist at: " ++ filePath
  input <- DBL.readFile filePath
  let file =
        case DA.decode input :: Maybe File of
          Nothing -> error $ "Unparsable file at: " ++ filePath 
          Just x -> x
  let (strings, facts) =
        case version file of
          "2019-12-19" -> canvasItemsToFacts (canvasItems file)
          _ -> error $ "Unrecognized version of: " ++ version file
  let facts2 = Fact "component" (moduleName file) Nothing : facts
  mapM_ (SIO.hPutStrLn SIO.stdout) (map factToProlog facts2)
  mapM_ (SIO.hPutStrLn SIO.stderr) (map factToLisp strings)
