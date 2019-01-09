module HttpSend where

import Types
import qualified Data.Text as DT
import qualified Data.Attoparsec.Text as DAT
import qualified Data.Maybe as DM

writeHttpRequest :: DT.Text -> Either String DT.Text
writeHttpRequest input = do
    response <- DAT.parseOnly httpRequestP input
    let responseBody = DM.fromMaybe "" $ getHeader response "Body"
    return $ prepareResponse responseBody

httpRequestP :: DAT.Parser HttpRequest
httpRequestP = DAT.many' pairP

pairP :: DAT.Parser Pair
pairP = do
    name <- DAT.takeTill (== '\t')
    DAT.char '\t'
    value <- DAT.takeTill DAT.isEndOfLine
    return (name, value)

prepareResponse :: DT.Text -> DT.Text
prepareResponse body = DT.append "HTTP/1.1 200 OK\r\n" body
