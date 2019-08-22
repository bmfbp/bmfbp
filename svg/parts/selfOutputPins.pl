:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    condSinkEllipse,
    writeFB,
    halt.

condSinkEllipse :-
    forall(ellipse(EllipseID),makeSelfOutputPins(EllipseID)),
    !.
condSource :- true.

makeSelfOutputPins(EllipseID) :-
    parent(Main,EllipseID),
    component(Main),
    parent(EllipseID,PortID),
    port(PortID),
    sink(PortID),
    asserta(selfOutputPin(PortID)).  % self-output -> is a sink (backwards from part inputs)

:- include('tail').
