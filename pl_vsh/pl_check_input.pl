:- initialization(main).
:- include('../common/head').

main :-
    readFB(user_input),
    writeFB,
    halt.

:- include('../common/tail').

