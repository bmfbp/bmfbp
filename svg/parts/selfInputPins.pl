:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    condSourceEllipse,
    writeFB,
    halt.

condSourceEllipse :-
    forall(ellipse(EllipseID),makeSelfInputPins(EllipseID)).
condSourceEllispe :- true.

makeSelfInputPins(EllipseID) :-
wen(a),
    parent(Main,EllipseID),
wen(b),
    component(Main),
wen(c),
    parent(EllipseID,PortID),
wen(d),
    port(PortID),
wen(e),
    source(PortID),
wen(f),
    asserta(selfInputPin(PortID)).  % self-input -> is a source (backwards from part inputs)

:- include('tail').
