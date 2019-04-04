:- initialization(main).
:- include('head').
:- include('tail').

main :-
    readFB(user_input), 
    forall(portIndex(P,_),markIndexed(P)),
    writeFB,
    halt.

markIndexed(P) :-
    sink(_,P),
    asserta(indexedSink(P)).

markIndexed(P) :-
    source(_,P),
    asserta(indexedSource(P)).

