:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(port(PortID),hasSinkOrSource(PortID)),
    writeFB,
    halt.

hasSinkOrSource(PortID):-
    sink(_,PortID),!.

hasSinkOrSource(PortID):-
    source(_,PortID),!.

hasSinkOrSource(PortID):-
    asserta(log('fATAL',port_isnt_marked_sink_or_source,PortID)),!.

:- include('tail').

