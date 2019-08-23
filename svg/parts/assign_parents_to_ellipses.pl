:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(ellipse(EllipseID),makeParentForEllipse(EllipseID)),
    writeFB,
    halt.

makeParentForEllipse(EllipseID) :-
    component(Comp),
    asserta(parent(Comp,EllipseID)).

:- include('tail').

