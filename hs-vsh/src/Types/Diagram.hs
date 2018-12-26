module Types.Diagram where

import qualified Data.Text as DT

newtype PartName = PartName DT.Text deriving Show
newtype EdgeId = EdgeId DT.Text deriving Show
newtype NodeId = NodeId DT.Text deriving (Show, Eq)
newtype FileDescriptor = FileDescriptor Int deriving Show

data Anchor = Left | Right | Top | Bottom deriving Show
data Dimension = X | Y | Width | Height deriving Show
data ElementType = Box | Port deriving Show

newtype Diagram = Diagram [DiagramFact] deriving Show

data DiagramFact
    = Component PartName
    | Edge EdgeId
    | ElementType NodeId ElementType
    | BoundingBox Anchor NodeId Float
    | Geometry Dimension NodeId Float
    | Kind NodeId PartName
    | Node NodeId
    | PipeCount Int
    | PipeNumber NodeId FileDescriptor
    | Parent NodeId NodeId
    | PortName NodeId FileDescriptor
    | Sink EdgeId NodeId
    | SinkFileDescriptor NodeId FileDescriptor
    | Source EdgeId NodeId
    | SourceFileDescriptor NodeId FileDescriptor
    deriving Show
