:- initialization(main).
:- include('head').

main :-
    g_assign(counter,0),
    readFB(user_input),
    forall(edge(EdgeID),assign_wire_number(EdgeID)),
    g_read(counter,N),
    asserta(nwires(N)),
    writeFB,
    halt.

assign_wire_number(EdgeID) :-
    g_read(counter,Old),
    asserta(wireNum(EdgeID,Old)),
    inc(counter,_).

:- include('tail').

