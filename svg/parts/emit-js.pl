:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    write('{'),
    nl,
    write('  "name" : "'),
    component(Name),
    write(Name),
    write('.js"'),
    nl,
    npipes(Npipes),
    write('  "wirecount" : '),
    write(Npipes),
    write(','),
    nl,
    write('  "parts" : ['),
    nl,
    forall(kind(ID,_),emitComponent(ID)),
    write('  ]'),
    nl,
    write('}'),
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
    write('      "inPins" : [['),
    write(Pipe),
    write(']],'),
    nl.

writeOut(Out) :-
    writeSpaces,
    outPipeP(Out),!,
    pipeNum(Out,Pipe),
    write('      "outPins" : [[],['),
    write(Pipe),
    write(']],'),
    nl.


emitComponent(ID) :-
    write('    {'),
    nl,
    forall(inputOfParent(ID,In),writeIn(In)),
    forall(outputOfParent(ID,O),writeOut(O)),
    writeSpaces,
    write('      "exec" : "'),
    kind(ID,Name),
    write(Name),
    write('"'),
    nl,
    write('    },'),
    nl.

writeSpaces :- write('  ').

inputOfParent(P,In) :-
    parent(In,P),sink(_,In).

outputOfParent(P,Out) :-
    parent(Out,P),source(_,Out).
    
hasInput(ID) :-
    eltype(ID,box),
    parent(Port,ID),
    eltype(Port,port),
    sink(_,Port).


:- include('tail').

