:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    logAllEdges,
    writeFB,
    halt.

:- include('query').
:- include('tail').

