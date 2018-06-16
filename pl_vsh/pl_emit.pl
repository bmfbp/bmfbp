:- initialization(main).
:- include(head).

main :-
    readFB(user_input),
    write('#name '),
    component(Name),
    write(Name),
    write('.gsh'),
    nl,
    npipes(Npipes),
    write('pipes '),
    write(Npipes),
    nl,
    forall(kind(ID,_),emitComponent(ID)),
    halt.

emitComponent(ID) :-
    write('fork'),
    nl,
    writeSpaces,
    writeExec(ID),
    write(' '),
    kind(ID,Name),
    write(Name),
    nl,
    write('krof'),
    nl.

writeSpaces :- char_code(C,32), write(C), write(C).

writeExec(ID) :-
    hasInput(ID),write(exec),!.
writeExec(_) :-
    write(exec1st),!.

hasInput(ID) :-
    eltype(ID,box),
    parent(ID2,ID),
    eltype(ID2,port).
    
:- include(tail).

