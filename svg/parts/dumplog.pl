:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    dumplog,
    halt.

:- include('tail').
