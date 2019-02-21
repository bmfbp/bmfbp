:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    write('('),
    nl,
    write('name "'),
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
    emitIns,
    emitOuts,
    emitExecs,
    write('  )'),
    halt,
    write(')'),
    halt.

emitIns :-
    write('ins ('),
    nl,
    forall(partHasAnInput(PartID),emitIns(PartID)),
    write(')'),
    nl.

emitIns(PartID) :-
    forall(inputPortBelongingToPart(PortID),emitIn(PartID,PortID)).

partHasAnInput(PartID):-
    kind(PartID,_),
    inputPin(PartID,_).

emitOuts :-
    write('outs ('),
    nl,
    forall(partHasAnOutput(PartID),emitOuts(PartID)),
    write(')'),
    nl.

emitOuts(PartID) :-
    forall(outputPortBelongingToPart(PortID),emitOut(PartID,PortID)).

partHasAnOutput(PartID):-
    kind(PartID,_),
    outputPin(PartID,_).



emitIn(ParentID,PortID) :-
    eltype(PortID,port),
    sink(Edge,PortID),
    edge(Edge),
    portIndex(PortID,Pin),
    pipeNum(PortID,Wire),
    write('('),
    write(ParentID),
    write(' '),
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

:- include('tail').

