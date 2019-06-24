:- initialization(main).
:- include('head').

main :-
    g_assign(counter,0),
    readFB(user_input),
    forall(sink(_,Pin),assign_pipeWire_number(Pin)),
    g_read(counter,N),
    asserta(npipes(N)),
    asserta(nwires(N)),  % redundant, name changed (npipes to nwires)
    writeFB,
    halt.

assign_pipeWire_number(Pin) :-
    g_read(counter,Old),
    asserta(pipeNum(Pin,Old)),
    asserta(wireNum(Pin,Old)), % redundant, see above
    asserta(log(Pin,'assigned_to_wire',Old)),
    inc(counter,_).

:- include('tail').

