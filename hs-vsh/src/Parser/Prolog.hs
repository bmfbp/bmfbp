module Parser.Prolog (decodeProlog, encodeProlog) where

import qualified Data.Text as DT
import qualified Data.Attoparsec.Text as DAT
import qualified Data.Either.Extra as DEE
import qualified Types.Diagram as TDG
import qualified Text.Read as TRD

decodeProlog :: DT.Text -> Either String TDG.Diagram
decodeProlog = DAT.parseOnly parser

parser :: DAT.Parser TDG.Diagram
parser = fmap TDG.Diagram (factParser `DAT.sepBy` DAT.endOfLine)

factParser :: DAT.Parser TDG.DiagramFact
factParser = do
    command <- DAT.takeTill (== '(')
    DAT.char '('
    params <- DAT.sepBy1 (DAT.many1 $ DAT.satisfy isNotSpecialFactChar) (DAT.char ',')
    DAT.string ")."
    return $ fact command $ map DT.pack params

isNotSpecialFactChar :: Char -> Bool
isNotSpecialFactChar c = c /= ',' && c /= ')'

fact :: DT.Text -> [DT.Text] -> TDG.DiagramFact
fact "component" [name] = TDG.Component $ TDG.PartName name
fact "edge" [id] = TDG.Edge $ TDG.EdgeId id
fact "eltype" [id, "box"] = TDG.ElementType (TDG.NodeId id) TDG.Box
fact "eltype" [id, "port"] = TDG.ElementType (TDG.NodeId id) TDG.Port
fact "bounding_box_left" [id, coordinate] = boundingBox TDG.Left id coordinate
fact "bounding_box_right" [id, coordinate] = boundingBox TDG.Right id coordinate
fact "bounding_box_top" [id, coordinate] = boundingBox TDG.Top id coordinate
fact "bounding_box_bottom" [id, coordinate] = boundingBox TDG.Bottom id coordinate
fact "geometry_x" [id, coordinate] = geometry TDG.X id coordinate
fact "geometry_y" [id, coordinate] = geometry TDG.Y id coordinate
fact "geometry_w" [id, coordinate] = geometry TDG.Width id coordinate
fact "geometry_h" [id, coordinate] = geometry TDG.Height id coordinate
fact "kind" [id, name] = TDG.Kind (TDG.NodeId id) (TDG.PartName name)
fact "node" [id] = TDG.Node (TDG.NodeId id)
fact "npipes" [count] = TDG.PipeCount (textToReadable count)
fact "pipeNum" [id, fd] = TDG.PipeNumber (TDG.NodeId id) (fileDescriptor fd)
fact "parent" [portId, parentId] = TDG.Parent (TDG.NodeId portId) (TDG.NodeId parentId)
fact "portName" [id, fd] = TDG.PortName (TDG.NodeId id) (fileDescriptor fd)
fact "sink" [edgeId, pinId] = TDG.Sink (TDG.EdgeId edgeId) (TDG.NodeId pinId)
fact "sinkfd" [pinId, fd] = TDG.SinkFileDescriptor (TDG.NodeId pinId) (fileDescriptor fd)
fact "source" [edgeId, pinId] = TDG.Source (TDG.EdgeId edgeId) (TDG.NodeId pinId)
fact "sourcefd" [pinId, fd] = TDG.SourceFileDescriptor (TDG.NodeId pinId) (fileDescriptor fd)
fact command params = error $ DT.unpack $ DT.concat ["Unrecognized command '", command, "' and params '", DT.intercalate "," params, "'"]

textToReadable :: Read a => DT.Text -> a
textToReadable input =
    case TRD.readMaybe (DT.unpack input) of
      Just input -> input
      Nothing -> error $ "Unparsable text: '" ++ DT.unpack input ++ "'"

boundingBox :: TDG.Anchor -> DT.Text -> DT.Text -> TDG.DiagramFact
boundingBox anchor id coordinate = TDG.BoundingBox anchor (TDG.NodeId id) (textToReadable coordinate)

geometry :: TDG.Dimension -> DT.Text -> DT.Text -> TDG.DiagramFact
geometry dimension id coordinate = TDG.Geometry dimension (TDG.NodeId id) (textToReadable coordinate)

fileDescriptor :: DT.Text -> TDG.FileDescriptor
fileDescriptor = TDG.FileDescriptor . textToReadable

encodeProlog :: TDG.Diagram -> DT.Text
encodeProlog (TDG.Diagram facts) = DT.unlines $ map go facts
  where
    go (TDG.Component (TDG.PartName partName)) = DT.concat ["component(", partName, ")."]
    go (TDG.Edge (TDG.EdgeId edgeId)) = DT.concat ["edge(", edgeId, ")."]
    go (TDG.ElementType (TDG.NodeId nodeId) TDG.Box) = DT.concat ["eltype(", nodeId, ",box)."]
    go (TDG.ElementType (TDG.NodeId nodeId) TDG.Port) = DT.concat ["eltype(", nodeId, ",port)."]
    go (TDG.BoundingBox TDG.Top (TDG.NodeId nodeId) coordinate) = DT.concat ["bounding_box_top(", nodeId, ",", (DT.pack $ show coordinate), ")."]
    go (TDG.BoundingBox TDG.Bottom (TDG.NodeId nodeId) coordinate) = DT.concat ["bounding_box_bottom(", nodeId, ",", (DT.pack $ show coordinate), ")."]
    go (TDG.BoundingBox TDG.Left (TDG.NodeId nodeId) coordinate) = DT.concat ["bounding_box_left(", nodeId, ",", (DT.pack $ show coordinate), ")."]
    go (TDG.BoundingBox TDG.Right (TDG.NodeId nodeId) coordinate) = DT.concat ["bounding_box_right(", nodeId, ",", (DT.pack $ show coordinate), ")."]
    go (TDG.Geometry TDG.X (TDG.NodeId nodeId) coordinate) = DT.concat ["geometry_x(", nodeId, ",", (DT.pack $ show coordinate), ")."]
    go (TDG.Geometry TDG.Y (TDG.NodeId nodeId) coordinate) = DT.concat ["geometry_y(", nodeId, ",", (DT.pack $ show coordinate), ")."]
    go (TDG.Geometry TDG.Width (TDG.NodeId nodeId) coordinate) = DT.concat ["geometry_w(", nodeId, ",", (DT.pack $ show coordinate), ")."]
    go (TDG.Geometry TDG.Height (TDG.NodeId nodeId) coordinate) = DT.concat ["geometry_h(", nodeId, ",", (DT.pack $ show coordinate), ")."]
    go (TDG.Kind (TDG.NodeId nodeId) (TDG.PartName partName)) = DT.concat ["kind(", nodeId, ",", partName, ")."]
    go (TDG.Node (TDG.NodeId nodeId)) = DT.concat ["node(", nodeId, ")."]
    go (TDG.PipeCount count) = DT.concat ["npipes(", (DT.pack $ show count), ")."]
    go (TDG.PipeNumber (TDG.NodeId nodeId) (TDG.FileDescriptor fd)) = DT.concat ["pipeNum(", nodeId, ",", (DT.pack $ show fd), ")."]
    go (TDG.Parent (TDG.NodeId portId) (TDG.NodeId boxId)) = DT.concat ["parent(", portId, ",", boxId, ")."]
    go (TDG.PortName (TDG.NodeId nodeId) (TDG.FileDescriptor fd)) = DT.concat ["portName(", nodeId, ",", (DT.pack $ show fd), ")."]
    go (TDG.Sink (TDG.EdgeId edgeId) (TDG.NodeId nodeId)) = DT.concat ["sink(", edgeId, ",", nodeId, ")."]
    go (TDG.SinkFileDescriptor (TDG.NodeId nodeId) (TDG.FileDescriptor fd)) = DT.concat ["sinkfd(", nodeId, ",", (DT.pack $ show fd), ")."]
    go (TDG.Source (TDG.EdgeId edgeId) (TDG.NodeId nodeId)) = DT.concat ["source(", edgeId, ",", nodeId, ")."]
    go (TDG.SourceFileDescriptor (TDG.NodeId nodeId) (TDG.FileDescriptor fd)) = DT.concat ["sourcefd(", nodeId, ",", (DT.pack $ show fd), ")."]
    go x = error $ "ERROR: Unknown fact: " ++ show x
