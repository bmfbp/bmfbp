module HttpReceive where

import Types
import qualified Data.Text as DT
import qualified Data.Attoparsec.Text as DAT

readHttpRequest :: DT.Text -> Either String DT.Text
readHttpRequest input = do
    parsed <- DAT.parseOnly httpRequestP input
    return $ toFactBase parsed

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
