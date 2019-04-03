:- initialization(main).
:- include('head').

% Wires (term taken from electronics schematics) are just indices to an array of wires.
% Each wire is described by an array of 2 elements - the input side of a tube
% and the output side of the same tube.
% We can fashion fan-in and fan-out by thinking of wires as one-way
% segments between one input port and one output port.  Fan-in is fashioned
% as multiple wires outputing to the same (input/sink) port (i.e. all of these
% kinds of wires have the same output-side port (a sink)).
% Fan-out is fashioned by a single wire from the source to a "copier"
% (a "dot" on a schematic).  The "copier" has as many output wires as needed
% to service all fan-out segments with unique wires (i.e. all of fan-out
% wires have the same source port).  Later, we can remove the concept of
% "copier" and simply have a bunch of wires that all have the same source
% (input) wire.
main :-
    readFB(user_input),
    forall(sink(_,PortID),makeInputForWire(PortID)),
    forall(source(_,PortID),makeOutputForWire(PortID)),
    writeFB,
    halt.

makeInputForWire(PortID) :-
    wireNum(PortID,WireIndex),
    portIndex(PortID,Pin),
    parent(PortID,Part),
    asserta(inputPin(Part,Pin)),
    asserta(wireIndex(Pin,WireIndex)).

makeInputForWire(PortID) :-
    n_c(PortID).

makeOutputForWire(PortID) :-
    n_c(PortID).

makeOutputForWire(PortID) :-
    wireNum(PortID,WireIndex),
    portIndex(PortID,Pin),
    parent(PortID,Part),
    asserta(outputPin(Part,Pin)),
    asserta(wireIndex(Pin,WireIndex)).

:- include('tail').
