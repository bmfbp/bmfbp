:- initialization(main).
:- include('../common/head').

main :-
    readFB(user_input),
% write(user_error,'A'),nl(user_error),
    write('#name '),
    component(Name),
    write(Name),
    write('.gsh'),
    nl,
% write(user_error,'B'),nl(user_error),
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
%write(user_error,ID),nl(user_error),
    forall(inputOfParent(ID,In),writeIn(In)),
% write(user_error,'C'),nl(user_error),
    forall(outputOfParent(ID,O),writeOut(O)),
% write(user_error,'D'),nl(user_error),
    writeSpaces,
    writeExec(ID),
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
    parent(Out,P),
% write(user_error,'E '),write(user_error,P),nl(user_error),write(user_error,Out),nl(user_error),
    source(_,Out).
    
writeExec(ID) :-
    hasInput(ID),write(exec),!.
writeExec(_) :-
    write(exec1st),!.

hasInput(ID) :-
    eltype(ID,box),
    parent(Port,ID),
    eltype(Port,port),
    sink(_,Port).


:- include('../common/tail').

