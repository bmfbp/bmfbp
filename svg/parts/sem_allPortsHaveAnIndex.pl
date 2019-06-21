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
    asserta(log('eRROR',PortID,'_has_more_than_one_index',First,Second)).
    %we('eRROR:'),we('port '),we(PortID),we( 'has more than one index '),we(First),wspc,wen(Second).


check_has_index(PortID):-
    portIndex(PortID,_),!.

check_has_index(PortID):-
    asserta(log('eRROR',PortID,'_has_no_index')).
    %we('eRROR: '),we('port '),we(PortID),wen(' has no index').

:- include('tail').

