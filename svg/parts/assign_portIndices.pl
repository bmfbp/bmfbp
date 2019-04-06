:- initialization(main).
:- include('head').

main :-
    %g_assign(fdnum,3),  % non-special case fd's start at 3 and up to maximum
    readFB(user_input),
    forall(integerSinkPortName(P,N),assign_sink_index(P,N)),
    forall(integerSourcePortName(P,N),assign_source_index(P,N)),

    writeFB,
    halt.

integerSinkPortName(P,N) :-
    portName(P,N),
    sink(_,P),
    integer(N).

integerSourcePortName(P,N) :-
    portName(P,N),
    source(_,P),
    integer(N).

assign_source_index(P,N) :-
    asserta(sourcefd(P,N)).

assign_sink_index(P,N) :-
    asserta(sinkfd(P,N)).

:- include('tail').
