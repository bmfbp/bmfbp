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
    write('wirecount  '),
    write(Npipes),
    nl,
    write('parts ('),
    nl,
    forall(kind(ID,_),emitIns(ID)),
    forall(kind(ID,_),emitOuts(ID)),
    emitExecs,
    write('  )'),
    halt,
    write(')'),
    halt.

emitExecs:-
    write('execs ('),
    nl,
    forall(kind(PartID,ExecName),emitExec(PartID,ExecName)),
    write(')'),
    nl.

emitExec(PartID,ExecName) :-
    write('('),
    write(PartID),
    write(' "'),
    write(ExecName),
    write('")'),
    nl.

emitIns(ParentID) :-
    write('ins ('),
    nl,
    forall(parent(PortID,ParentID),emitIn(ParentID,PortID)),
    write(')'),
    nl.	  

emitOuts(ParentID) :-
    write('outs ('),
    nl,
    forall(parent(PortID,ParentID),emitOut(ParentID,PortID)),
    write(')'),
    nl.	  

emitIn(ParentID,PortID) :-
    eltype(PortID,port),
    sink(Edge,PortID),
    edge(Edge),
    portIndex(PortID,Pin),
    pipeNum(PortID,Wire),
    write('('),
    write(ParentID),
    write(PortID),
    write(' '),
    write(Wire),
    write(' '),
    write(Pin),
    write(')'),
    nl.

emitOut(ParentID,PortID) :-
    eltype(PortId,port),
    source(Edge,PortID),
    edge(Edge),
    portIndex(PortId,Pin),
    pipeNum(PortID,Wire),
    write('('),
    write(ParentID),
    write(PortID),
    write(' '),
    write(Wire),
    write(' '),
    write(Pin),
    write(')'),
    nl.

:- include('tail').

