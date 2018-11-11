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

writeIn(In) :-
    writeSpaces,
    portName(In,in),
    pipeNum(In,Pipe),
    write('stdinPipe'),
    write(' '),
    write(Pipe),
    nl.

writeOut(Out) :-
    writeSpaces,
    portName(Out,out),
    pipeNum(Out,Pipe),
    write('stdoutPipe'),
    write(' '),
    write(Pipe),
    nl.

writeErr(Out) :-
    writeSpaces,
    portName(Out,out),
    pipeNum(Out,Pipe),
    write('stderrPipe'),
    write(' '),
    write(Pipe),
    nl.

emitComponent(ID) :-
    write('fork'),
    nl,
    forall(inputOfParent(ID,In),writeIn(In)),
    forall(outputOfParent(ID,O),writeOut(O)),
    forall(erroutputOfParent(ID,Out),writeErr(Out)),
    writeSpaces,
    writeExec(ID),
    write(' '),
    kind(ID,Name),
    write(Name),
    nl,
    write('krof'),
    nl.

writeSpaces :- char_code(C,32), write(C), write(C).

inputOfParent(P,In) :-
    parent(In,P),portName(In,in).
    
outputOfParent(P,Out) :-
    parent(Out,P),portName(Out,out).
    
erroutputOfParent(P,Out) :-
    parent(Out,P),portName(Out,err).
    
writeExec(ID) :-
    hasInput(ID),write(exec),!.
writeExec(_) :-
    write(exec1st),!.

hasInput(ID) :-
    eltype(ID,box),
    parent(Port,ID),
    eltype(Port,port),
    sink(_,Port).


:- include(tail).

