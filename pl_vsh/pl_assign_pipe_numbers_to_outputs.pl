:- initialization(main).
:- include('../common/head').


main :-
    readFB(user_input),
    forall(sink(_,P),aopn(P)),
    writeFB,
    halt.

aopn(P) :- 
    sink(E,P), 
    pipeNum(P,I),
    source(E,O),
    %write(P), write(' '),
    %write(E), write(' '),
    %write(I), write(' '),
    %write(O), nl,
    asserta(pipeNum(O,I)).
    
writeterm(Term) :- current_output(Out), write_term(Out, Term, []), write(Out, '.'), nl.

:- include('../common/tail').
