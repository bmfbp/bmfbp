module MarkDirections where

import qualified Parser.Prolog as PPL
import qualified Data.Text.IO as DTI
import qualified System.Exit as SEX
import qualified System.IO as SIO

main :: IO ()
main = do
    input <- DTI.getContents
    case PPL.decodeProlog input of
      Left error -> do
        SIO.hPutStr SIO.stderr ("ERROR: Input is not prolog.\n" ++ error)
        SEX.exitWith (SEX.ExitFailure 3)
      Right prolog -> DTI.putStr $ PPL.encodeProlog prolog
