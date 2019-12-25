module FixSelfPart.Main where

import FixSelfPart

main :: IO ()
main = do
  manifest <- getContents
  putStrLn $ fixSelfInManifest manifest
