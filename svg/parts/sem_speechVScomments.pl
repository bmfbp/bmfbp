% check that each speechbubble is a comment

:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    g_assign(counter,0),
    forall(speechbubble(ID),xinc(ID)),
    forall(comment(ID),xdec(ID)),
    g_read(counter,Counter),
    checkZero(Counter),
    writeFB,
    halt.

xinc(_) :- inc(counter,_).
xdec(_) :- dec(counter,_).


checkZero(0) :- !.

checkZero(N) :-
    asserta(log('fATAL','speechCountCommentCount',N)).


:- include('tail').

