:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(eltype(PortID, port), check_has_index(PortID)),
    writeFB,
    halt.

check_has_index(PortID):-
    portIndex(PortID,First),
    portIndex(PortID,Second),
    First =\= Second,
    !,
    asserta(log('eRROR',PortID,'has_more_than_one_index',First,Second,'allPortsHaveAnIndex')).

check_has_index(PortID):-
    portIndex(PortID,_),!.

check_has_index(PortID):-
    n_c(PortID).

check_has_index(PortID):-
    asserta(log('eRROR',PortID,'has_no_index','allPortsHaveAnIndex')).

:- include('tail').

