:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    %% logAllEdges,
    dumplog,
    halt.

:- include('query').
:- include('tail').
