:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(eltype(ParentID, box), check_has_port(ParentID)),
    writeFB,
    halt.

check_has_port(ParentID):-
    parent(_,ParentID),!.

check_has_port(ParentID):-
    roundedrect(ParentID).

check_has_port(ParentID):-
    asserta(log(ParentID,'error_parent_has_no_port','partsHaveSomePorts')),
    asserta(pinless(ParentID)).

:- include('tail').

