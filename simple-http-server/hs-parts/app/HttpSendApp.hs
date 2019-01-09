{-# LANGUAGE OverloadedStrings #-}

module HttpSendApp where

import HttpSend
import qualified Data.Text as DT
import qualified Data.Text.IO as DTI
import qualified System.IO as SIO

main :: IO ()
main = do
    input <- DTI.getContents
    case writeHttpRequest input of
      Left error -> do
        SIO.hPutStr SIO.stderr ("ERROR: Input is not a list of tab-separated pairs.\n" ++ error)
      Right output -> DTI.putStr output
