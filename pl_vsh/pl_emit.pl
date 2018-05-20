:- initialization(main).
:- include(head).

main :-
    readFB(user_input),
    write('#name '),
    component(Name),
    write(Name),
    write('.gsh'),
    nl,
    npipes(Npipes),
    write('pipes '),
    write(Npipes),
    nl,
    halt.

:- include(tail).

