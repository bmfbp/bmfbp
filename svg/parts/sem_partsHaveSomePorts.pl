:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(eltype(PartID, box), check_has_port(PartID)),
    writeFB,
    halt.

check_has_port(PartID):-
    parent(PortID,PartID),
    port(PortID),
    !.

check_has_port(PartID):-
    pinless(PartID),!.

check_has_port(PartID):-
    asserta(log(PartID,'error_part_has_no_port','partsHaveSomePorts')).

:- include('tail').

