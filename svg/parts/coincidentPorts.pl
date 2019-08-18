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
    forall(namedSink(X),findAllCoincidentSinks(X)).

findAllCoincidentSinks(A) :-
    forall(sink(_,B),findCoincidentSink(A,B)).

findCoincidentSink(A,B):-
    center_y(A,Ay),
    center_y(B,By),
    center_x(A,Ax),
    center_x(B,Bx),
    A \== B,
    sink(_,B),
    notNamedSink(B),
    closeTogether(Ax,Bx),
    closeTogether(Ay,By),
    portName(A,N),
    asserta(log(coincidentsink,A,B,N)),
    asserta(portName(B,N)).

findCoincidentSink(_,_):-
    true.

notNamedSink(X) :-
    \+ namedSink(X).


coincidentSources:-
    forall(namedSource(X),findAllCoincidentSources(X)).

findAllCoincidentSources(A) :-
    forall(source(_,B),findCoincidentSource(A,B)).

findCoincidentSource(A,B):-
    center_y(A,Ay),
    center_y(B,By),
    center_x(A,Ax),
    center_x(B,Bx),
    A \== B,
    source(_,B),
    notNamedSource(B),
    closeTogether(Ax,Bx),
    closeTogether(Ay,By),
    portName(A,N),
    asserta(log(coincidentsource,A,B,N)),
    asserta(portName(B,N)).

findCoincidentSource(_,_):-
    true.

notNamedSource(X) :-
    \+ namedSource(X).



closeTogether(X,Y):-
    Delta is X - Y,
    Abs is abs(Delta),
    20 >= Abs.

closeTogether(_,_) :- 
    fail.
