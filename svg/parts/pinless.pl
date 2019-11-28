:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(eltype(ParentID, box), check_has_port(ParentID)),
    writeFB,
    halt.

check_has_port(ParentID):-
    parent(ParentID,PortID),
    port(PortID),
    !.

check_has_port(ParentID):-
    roundedrect(ParentID),
    asserta(pinless(ParentID)).

check_has_port(PID):-
    we('fATAL: no port for id '),wen(PID).

:- include('tail').

