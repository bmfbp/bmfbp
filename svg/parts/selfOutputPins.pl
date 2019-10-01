:- initialization(main).
:- include('head').
:- include('port').

main :-
    readFB(user_input),
    condSinkEllipse,
    writeFB,
    halt.

condSinkEllipse :-
    forall(ellipse(EllipseID),makeSelfOutputPins(EllipseID)),
    !.
condSourceEllipse :- true.

makeSelfOutputPins(EllipseID) :-
    parent(Main,EllipseID),
    component(Main),
    portFor(EllipseID,PortID),
    sink(_,PortID),
    asserta(selfOutputPin(PortID)),!.  % self-output -> is a sink (backwards from part inputs)

makeSelfOutputPins(_) :-
    true.

:- include('tail').
