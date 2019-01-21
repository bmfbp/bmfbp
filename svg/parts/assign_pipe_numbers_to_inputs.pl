:- initialization(main).
:- include('head').

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

:- include('tail').

