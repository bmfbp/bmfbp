:- initialization(main).
:- include('head').


main :-
    readFB(user_input),
    forall(sink(_,P),aown(P)),
    writeFB,
    halt.

aown(INPUT_PIN) :- 
    sink(EDGE,INPUT_PIN),
    wireNum(INPUT_PIN,INPUT_WIRE),
    source(EDGE,OUTPUT_PIN),
    asserta(wireNum(OUTPUT_PIN,INPUT_WIRE)).
    
writeterm(Term) :- current_output(Out), write_term(Out, Term, []), write(Out, '.'), nl.

:- include('tail').
