:- initialization(main).
:- include('head').

main :-
    g_assign(counter,0),
    readFB(user_input),
    forall(sink(_,Pin),assign_wire_number(Pin)),
    g_read(counter,N),
    asserta(nwire(N)),
    writeFB,
    halt.

assign_wire_number(Pin) :-
    g_read(counter,Old),
    asserta(wireNum(Pin,Old)),
    inc(counter,_).

:- include('tail').

