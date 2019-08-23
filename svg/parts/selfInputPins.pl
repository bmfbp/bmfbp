:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    condSourceEllipse,
    writeFB,
    halt.

condSourceEllipse :-
    forall(ellipse(EllipseID),makeSelfInputPins(EllipseID)),!.

condSourceEllispe :- true.

makeSelfInputPins(EllipseID) :-
    parent(Main,EllipseID),
    component(Main),
    parent(EllipseID,PortID),
    port(PortID),
    source(_,PortID),
    asserta(selfInputPin(PortID)),!.  % self-input -> is a source (backwards from part inputs)

makeSelfInputPins(_) :-
    true.

:- include('tail').
