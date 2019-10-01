:- initialization(main).
:- include('head').
:- include('port').

main :-
    readFB(user_input),
    condSourceRect,
    writeFB,
    halt.

condSourceRect :-
    forall(rect(RectID),makeOutputPins(RectID)),
    !.
condSourceRect :- true.

makeOutputPins(RectID) :-
    portFor(RectID,PortID),
    source(_,PortID),
    asserta(outputPin(PortID)),!.

makeOutputPins(_) :-
    true.

:- include('tail').
