% HISTORY: this used to work only with numeric indices
% cut over to use port names, not indices

:- initialization(main).
:- include('head').
:- include('tail').

main :-
    readFB(user_input), 
    forall(portName(P,_),markNamed(P)),
    writeFB,
    halt.

markNamed(P) :-
    sink(_,P),
    asserta(namedSink(P)).

markNamed(P) :-
    source(_,P),
    asserta(namedSource(P)).

markName(P) :-
    we('port '),
    we(P),
    wen(' has no name!').

