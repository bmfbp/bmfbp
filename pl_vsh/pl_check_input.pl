:- initialization(main).
:- include(head).

main :-
    readFB(user_input),
    writeFB,
    halt.

:- include(tail).

