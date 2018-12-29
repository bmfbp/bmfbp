module Vsh.EmitGrash where

import Types.Diagram
import qualified Data.Map.Strict as DMS
import qualified Data.Set as DS
import qualified Data.Text as DT
import qualified Data.Maybe as DM
import Debug.Trace
import qualified Control.Monad as CM

data FactBase =
    FactBase
      { component :: DT.Text
      , pipeCount :: Int
      , kinds :: [(DT.Text, DT.Text)]
      , boxes :: DS.Set DT.Text
      , ports :: DS.Set DT.Text
      , parentsByBox :: DMS.Map DT.Text [DT.Text]
      , sinks :: SinkSourceAccessor
      , sources :: SinkSourceAccessor
      , portNames :: DMS.Map DT.Text Int
      , pipeNums :: DMS.Map DT.Text Int
      }

type SinkSourceAccessor = DMS.Map DT.Text DT.Text

emitGrash :: Diagram -> DT.Text
emitGrash (Diagram facts) = buildGrash factbase
  where
    factbase =
      FactBase
        { component = head [ x | Component (PartName x) <- facts ]
        , pipeCount = head [ x | PipeCount x <- facts ]
        , kinds = [ (x, y) | Kind (NodeId x) (PartName y) <- facts ]
        , boxes = DS.fromList [ x | ElementType (NodeId x) Box <- facts ]
        , ports = DS.fromList [ x | ElementType (NodeId x) Port <- facts ]
        , parentsByBox = DMS.fromListWith (++) [ (y, [x]) | Parent (NodeId x) (NodeId y) <- facts ]
        , sinks = DMS.fromList [ (y, x) | Sink (EdgeId x) (NodeId y) <- facts ]
        , sources = DMS.fromList [ (y, x) | Source (EdgeId x) (NodeId y) <- facts ]
        , portNames = DMS.fromList [ (x, y) | PortName (NodeId x) (FileDescriptor y) <- facts ]
        , pipeNums = DMS.fromList [ (x, y) | PipeNumber (NodeId x) (FileDescriptor y) <- facts ]
        }

buildGrash :: FactBase -> DT.Text
buildGrash factbase = DT.intercalate "\n" (preamble ++ forks)
  where
    preamble = map DT.concat
      [ ["#name ", component factbase, ".gsh"]
      , ["pipes ", DT.pack (show (pipeCount factbase))]
      ]
    forks = map (fork factbase) (kinds factbase)

fork :: FactBase -> (DT.Text, DT.Text) -> DT.Text
fork factbase (id, name) = unlines lines
  where
    unlines = DT.intercalate "\n"
    pipeLine command fd = DT.concat ["  ", command, " ", DT.pack (show fd)]
    execLine = DT.append "  " (exec factbase id name)
    inputLines = unlines $ map (pipeLine "inPipe") (input factbase id name)
    outputLines = unlines $ map (pipeLine "outPipe") (output factbase id name)
    lines = ["fork", inputLines, outputLines, execLine, "krof"]

exec :: FactBase -> DT.Text -> DT.Text -> DT.Text
exec factbase id name = DT.append command name
  where
    isBox = DS.member id (boxes factbase)
    isPort x = DS.member x (ports factbase)
    isSink x = DMS.member x (sinks factbase)
    validate port = isBox && isSink port && isPort port
    command =
      case DMS.lookup id (parentsByBox factbase) of
        Nothing -> "exec1st "
        Just ports -> if any validate ports then "exec " else "exec1st "

input :: FactBase -> DT.Text -> DT.Text -> [Int]
input = ioPipe sinks

output :: FactBase -> DT.Text -> DT.Text -> [Int]
output = ioPipe sources

ioPipe :: (FactBase -> SinkSourceAccessor) -> FactBase -> DT.Text -> DT.Text -> [Int]
ioPipe accessor factbase id name = fds
  where
    parents = concat $ DM.maybeToList $ DMS.lookup id (parentsByBox factbase)
    isAccessorType x = DMS.member x (accessor factbase)
    validate x = do
      DMS.lookup x (portNames factbase)
      CM.guard (isAccessorType x)
      return x
    nodes = DM.catMaybes $ map validate parents
    pipe x = DMS.lookup x (pipeNums factbase)
    fds = DM.catMaybes $ map pipe nodes
