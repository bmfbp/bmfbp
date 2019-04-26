:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    write('('),
    nl,
    write('name "'),
    component(Name),
    write(Name),
    write('.js"'),
    nl,
    nwires(Nwires),
    write('wirecount  '),
    write(Nwires),
    nl,
%    write('self ('),
%    nl,
%    emitAllSelfPins,
%    emitSelfExecs,
%    write(' )'),
    write('parts ('),
    nl,
    emitAllPins,
    emitExecs,
    write(' )'),
    nl,
    write(')'),
    halt.

:- include('children').
:- include('tail').





