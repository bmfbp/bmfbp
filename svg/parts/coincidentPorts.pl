:- initialization(main).
:- include('head').
:- include('tail').

main :-
    readFB(user_input), 
    coincidentSinks,
    coincidentSources,
    writeFB,
    halt.


coincidentSinks:-
    forall(indexedSink(X),findCoincidentSink(X)).

findCoincidentSink(A):-
    center_y(A,Ay),
    center_y(B,By),
    center_x(A,Ax),
    center_x(B,Bx),
    A \== B,
    sink(_,B),
    notIndexedSink(B),
    closeTogether(Ax,Bx),
    closeTogether(Ay,By),
    portIndex(A,I),
    we('sink '),we(B),we(' coincides with sink '),we(A),we(' index '),wen(I),
    asserta(portIndex(B,I)).

findCoincidentSink(_):-
    true.

notIndexedSink(X) :-
    \+ indexedSink(X).


coincidentSources:-
    forall(indexedSource(X),findCoincidentSource(X)).

findCoincidentSource(A):-
    center_y(A,Ay),
    center_y(B,By),
    center_x(A,Ax),
    center_x(B,Bx),
    A \== B,
    source(_,B),
    notIndexedSource(B),
    closeTogether(Ax,Bx),
    closeTogether(Ay,By),
    portIndex(A,I),
    we('source '),we(B),we(' coincides with source '),we(A),we(' index '),wen(I),
    asserta(portIndex(B,I)).

findCoincidentSource(_):-
    true.

notIndexedSource(X) :-
    \+ indexedSource(X).



closeTogether(X,Y):-
    Delta is X - Y,
    Abs is abs(Delta),
    20 >= Abs.

closeTogether(_,_) :- 
    fail.
