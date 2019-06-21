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
    asserta(log(ParentID,'warning_parent_has_no_port_but_ok_if_it_is_metadata','partsHaveSomePorts')),
    asserta(pinless(ParentID)).

:- include('tail').

