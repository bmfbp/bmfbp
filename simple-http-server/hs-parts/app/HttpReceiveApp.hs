{-# LANGUAGE OverloadedStrings #-}

module HttpReceiveApp where

import HttpReceive
import qualified Data.Text as DT
import qualified Data.Text.IO as DTI
import qualified System.IO as SIO

main :: IO ()
main = do
    input <- DTI.getContents
    case readHttpRequest input of
      Left error -> do
        SIO.hPutStr SIO.stderr ("ERROR: Input is not an HTTP request.\n" ++ error)
      Right output -> DTI.putStr output
