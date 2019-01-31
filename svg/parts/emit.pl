:- initialization(main).
:- include('head').

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

inPipeP(P) :-
    portName(P,0).

inPipeP(P) :-
    portName(P,in).

outPipeP(P) :-
    portName(P,out).

outPipeP(P) :-
    portName(P,1).

errPipeP(P) :-
    portName(P,err).

errPipeP(P) :-
    portName(P,2).

writeIn(In) :-
    writeSpaces,
    inPipeP(In),!,
    pipeNum(In,Pipe),
    write('inPipe'),
    write(' '),
    write(Pipe),
    nl.

writeOut(Out) :-
    writeSpaces,
    outPipeP(Out),!,
    pipeNum(Out,Pipe),
    write('outPipe'),
    write(' '),
    write(Pipe),
    nl.


emitComponent(ID) :-
    write('fork'),
    nl,
    forall(inputOfParent(ID,In),writeIn(In)),
    forall(outputOfParent(ID,O),writeOut(O)),
    writeSpaces,
    writeExec,
    write(' '),
    kind(ID,Name),
    write(Name),
    nl,
    write('krof'),
    nl.

writeSpaces :- write('  ').

inputOfParent(P,In) :-
    parent(In,P),sink(_,In).

outputOfParent(P,Out) :-
    parent(Out,P),source(_,Out).
    
writeExec :-
    write(exec),!.

hasInput(ID) :-
    eltype(ID,box),
    parent(Port,ID),
    eltype(Port,port),
    sink(_,Port).


:- include('tail').

