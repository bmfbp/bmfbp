module HttpReceive where

import Types
import qualified Data.Text as DT
import qualified Data.Attoparsec.Text as DAT
import qualified Control.Monad as CM

import Debug.Trace

readHttpRequest :: IO Char -> IO (Either String DT.Text)
readHttpRequest getMore = go $ DAT.parse httpRequestP ""
  where
    go :: DAT.Result HttpRequest -> IO (Either String DT.Text)
    go (DAT.Fail remaining _ _) = return $ Left $ DT.unpack remaining
    go (DAT.Done _ parsed) = return $ Right $ toFactBase parsed
    go (DAT.Partial cont) = getMore >>= (return . DT.singleton) >>= (go . cont)

word :: DAT.Parser DT.Text
word = fmap DT.pack $ DAT.many1' DAT.letter

httpRequestP :: DAT.Parser HttpRequest
httpRequestP = do
    verb <- word
    DAT.space
    url <- DAT.takeTill (== ' ')
    DAT.space
    DAT.string "HTTP/"
    DAT.skipWhile (/= '\r')
    DAT.string "\r\n"
    headers <- DAT.many' headerP
    let returnValue =
          [ ("Verb", verb)
          , ("Url", url)
          ] ++ headers
    case getHeader headers "Content-Length" of
      Nothing -> return returnValue
      Just length -> do
        DAT.string "\r\n"
        body <- DAT.take $ read $ DT.unpack length
        return (("Body", body) : returnValue)

headerP :: DAT.Parser Pair
headerP = do
    DAT.peekChar' >>= CM.guard . (/= '\r')
    name <- DAT.takeTill (== ':')
    DAT.char ':'
    DAT.many' DAT.space
    value <- DAT.takeTill (== '\r')
    DAT.string "\r\n"
    return (name, value)

toFactBase :: HttpRequest -> DT.Text
toFactBase [] = ""
toFactBase ((name, value) : xs) = DT.append line rest
  where
    line = DT.concat [name, "\t", value, "\n"]
    rest = toFactBase xs
