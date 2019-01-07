module Vsh.AssignPipeNumbers where

import Types.Diagram

assignToInputs :: Diagram -> Diagram
assignToInputs (Diagram facts) = Diagram (facts ++ pipeNums ++ [pipeCount])
  where
    sinks = [ x | Sink _ x <- facts ]
    pipeNums = [ PipeNumber x (FileDescriptor i) | (i, x) <- zip [0..] sinks ]
    pipeCount = PipeCount (length pipeNums)

assignToOutputs :: Diagram -> Diagram
assignToOutputs (Diagram facts) = Diagram (facts ++ newFacts)
  where
    sinks = [ (x, y) | Sink x y <- facts ]
    pipeNums = [ (x, y) | PipeNumber x y <- facts ]
    sources = [ (x, y) | Source x y <- facts ]
    newFacts =
      [ PipeNumber outputPin inputPipe
      | (edgeId, inputPin) <- sinks
      , (x, inputPipe) <- pipeNums
      , (y, outputPin) <- sources
      , x == inputPin
      , y == edgeId
      ]
