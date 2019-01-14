{-# LANGUAGE OverloadedStrings #-}

module HttpReceiveApp where

import HttpReceive
import qualified Data.Text as DT
import qualified Data.Text.IO as DTI
import qualified System.IO as SIO

import Debug.Trace

main :: IO ()
main = do
    result <- readHttpRequest SIO.getChar
    case result of
      Left error -> SIO.hPutStr SIO.stderr ("ERROR: Input is not an HTTP request. Remaining:\n" ++ error)
      Right output -> DTI.putStr output
