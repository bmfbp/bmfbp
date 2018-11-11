:- initialization(main).
:- include('../common/head').

main :-
    g_assign(counter,0),
    readFB(user_input),
    forall(sink(_,Pin),assign_pipe_number(Pin)),
    g_read(counter,N),
    asserta(npipes(N)),
    writeFB,
    halt.

assign_pipe_number(Pin) :-
    g_read(counter,Old),
    asserta(pipeNum(Pin,Old)),
    inc(counter,_).


    % g_inc(Counter,New).

    % junk (Pin, Old, X) :-
    % g_read(counter,Old),
    % asserta(pipeNum(Pin,Old)),
    % X is Old+1,
    % g_assign(counter,X).

:- include('../common/tail').

