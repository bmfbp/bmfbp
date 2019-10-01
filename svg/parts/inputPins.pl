:- initialization(main).
:- include('head').
:- include('port').

main :-
    readFB(user_input),
    condSinkRect,
    writeFB,
    halt.

condSinkRect :-
    forall(rect(RectID),makeInputPins(RectID)),
    !.
condSinkRect :- true.

makeInputPins(RectID) :-
    portFor(RectID,PortID),
    sink(_,PortID),
    asserta(inputPin(PortID)),!.

makeInputPins(_) :-
    true.

:- include('tail').
