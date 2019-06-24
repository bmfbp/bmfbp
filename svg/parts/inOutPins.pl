:- initialization(main).
:- include('head').

% Pipes (term taken from Unix) are just indices to an array of pipes.
% Each pipe is just an array of 2 elements - the input side of a tube
% and the output side of the same tube.
% We can fashion fan-in and fan-out by thinking of pipes as one-way
% segments between one input port and one output port.  Fan-in is fashioned
% as multiple pipes outputing to the same (input/sink) port (i.e. all of these
% kinds of pipes have the same output-side port (a sink)).
% Fan-out is fashioned by a single pipe from the source to a "copier"
% (a "dot" on a schematic).  The "copier" has as many output pipes are needed
% to service all fan-out segments with unique pipes (i.e. all of fan-out
% pipes have the same source port).  Later, we can remove the concept of
% "copier" and simply have a bunch of pipes that all have the same source
% (input) pipe.
main :-
    readFB(user_input),
    condSink,
    condSource,
    writeFB,
    halt.

condSink :-
    forall(sink(_,PortID),makeInputForPipe(PortID)),!.
condSink :- true.

condSource :-
    forall(source(_,PortID),makeOutputForPipe(PortID)),!.
condSource :- true.

makeInputForPipe(PortID) :-
    pipeNum(PortID,WireIndex),
    portIndex(PortID,Pin),
    parent(PortID,Part),
    makeInput(Part,PortID,Pin,WireIndex).

makeInputForPipe(PortID) :-
    n_c(PortID).

% wireIndex(PinID,WireIndex)
% wire index is unique
% PinID (PortID) is unique, pin index is not unique
% portIndex(PortID,PortIndex) is the same as portIndex(PinID,PinIndex)

makeInput(Part,PinID,_,WireIndex) :-
    rect(Part),
    asserta(inputPin(Part,PinID)),
    asserta(wireIndex(PinID,WireIndex)).

makeInput(Part,PinID,_,WireIndex) :-
    ellipse(Part),
    we('makeOutput in'),wspc,we(Part),wspc,we(PinID),wspc,wen(WireIndex),
    asserta(selfOutputPin(Part,PinID)),
    asserta(wireIndex(PinID,WireIndex)).

makeInput(Part,PortID,Pin,WireIndex) :-
    we('cannot happen in inOutPins/makeInput '),
    we(Part),wspc,
    we(PortID),wspc,
    we(Pin),wspc,
    we(WireIndex),wspc.

makeOutputForPipe(PortID) :-
    pipeNum(PortID,WireIndex),
    portIndex(PortID,PinIndex),
    parent(PortID,Part),
    makeOutput(Part,PortID,PinIndex,WireIndex).

makeOutputForPipe(PortID) :-
    n_c(PortID).

makeOutput(Part,PinID,_,WireIndex):-
    rect(Part),
    asserta(outputPin(Part,PinID)),
    asserta(wireIndex(PinID,WireIndex)).

makeOutput(Part,PinID,_,WireIndex):-
    ellipse(Part),
    we('makeOutput out'),wspc,we(Part),wspc,we(PinID),wspc,wen(WireIndex),
    asserta(selfInputPin(Part,PinID)),
    asserta(wireIndex(PinID,WireIndex)).

makeOutput(Part,PortID,PinIndex,WireIndex):-
    we('cannot happen in inOutPins/makeOutput '),
    we(Part),wspc,
    we(PortID),wspc,
    we(PinIndex),wspc,
    wen(WireIndex).

:- include('tail').
