:- initialization(main).
:- include('../common/head').


main :-
    readFB(user_input),
    forall(sink(_,P),aopn(P)),
    writeFB,
    halt.

aopn(INPUT_PIN) :- 
    sink(EDGE,INPUT_PIN),
    pipeNum(INPUT_PIN,INPUT_PIPE),
    source(EDGE,OUTPUT_PIN),
    asserta(pipeNum(OUTPUT_PIN,INPUT_PIPE)).
    
writeterm(Term) :- current_output(Out), write_term(Out, Term, []), write(Out, '.'), nl.

:- include('../common/tail').
