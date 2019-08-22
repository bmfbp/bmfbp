:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(eltype(ParentID, box), check_has_port(ParentID)),
    writeFB,
    halt.

check_has_port(ParentID):-
    parent(PortID,ParentID),
    port(PortID),
    !.

check_has_port(ParentID):-
    roundedrect(ParentID),
    asserta(pinless(ParentID)).

:- include('tail').

