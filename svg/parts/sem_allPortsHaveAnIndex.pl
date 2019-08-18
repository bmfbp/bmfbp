% HISTORY: in switch to named ports from indexed ports, this becomes a no-op

:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    writeFB,
    halt.

:- include('tail').

