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

makeInput(Part,_,Pin,WireIndex) :-
    rect(Part),
    asserta(inputPin(Part,Pin)),
    asserta(wireIndex(Pin,WireIndex)).

makeInput(Part,_,Pin,WireIndex) :-
    ellipse(Part),
    asserta(selfOutputPin(Part,Pin)),
    asserta(wireIndex(Pin,WireIndex)).

makeInput(Part,PortID,Pin,WireIndex) :-
    we('cannot happen in inOutPins/makeInput '),
    we(Part),wspc,
    we(PortID),wspc,
    we(Pin),wspc,
    we(WireIndex),wspc.

makeOutputForPipe(PortID) :-
    pipeNum(PortID,WireIndex),
    portIndex(PortID,Pin),
    parent(PortID,Part),
    makeOutput(Part,PortID,Pin,WireIndex).

makeOutputForPipe(PortID) :-
    n_c(PortID).

makeOutput(Part,_,Pin,WireIndex):-
    rect(Part),
    asserta(outputPin(Part,Pin)),
    asserta(wireIndex(Pin,WireIndex)).

makeOutput(Part,_,Pin,WireIndex):-
    ellipse(Part),
    asserta(selfInputPin(Part,Pin)),
    asserta(wireIndex(Pin,WireIndex)).

makeOutput(Part,PortID,Pin,WireIndex):-
    we('cannot happen in inOutPins/makeOutput '),
    we(Part),wspc,
    we(PortID),wspc,
    we(Pin),wspc,
    we(WireIndex),wspc.

:- include('tail').
