:- initialization(main).
:- include('head').

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
    parent(RectID,PortID),
    port(PortID),
    source(_,PortID),
    asserta(outputPin(PortID)),!.

:- include('tail').
