:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(sinkPortPortIndex(P,N),assign_sink_PortIndex(P,N)),
    forall(sourcePortPortIndex(P,N),assign_source_PortIndex(P,N)),
    writeFB,
    halt.

sinkPortPortIndex(P,N) :-
    portName(P,N),
    sink(_,P),
    integer(N).

sourcePortPortIndex(P,N) :-
    portName(P,N),
    source(_,P),
    integer(N).

assign_source_PortIndex(P,N) :-
    asserta(sourcePortIndex(P,N)).

assign_sink_PortIndex(P,N) :-
    asserta(sinkPortIndex(P,N)).

:- include('tail').
