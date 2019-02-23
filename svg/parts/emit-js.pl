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
    emitAllPins,
    emitExecs,
    write(' )'),
    nl,
    write(')'),
    halt.

emitAllPins :-
    write('  ins ('), nl,
    forall(eltype(PartID,box),getAllInPinsForPart(PartID)),
    write('  )'), nl,
    write('  outs ('), nl,
    forall(eltype(PartID,box),getAllOutPinsForPart(PartID)),
    write('  )'), nl.

getAllInPinsForPart(PartID):-
    forall(inPinOfPart(PortID,PartID),getOneInPin(PortID,PartID)).

inPinOfPart(PortID,PartID) :-
    parent(PortID,PartID),
    sink(_,PortID).

getOneInPin(PortID,PartID):-
    eltype(PortID,port),
    pipeNum(PortID,Wire),
    portIndex(PortID,Pin),
    write('    ('),
    write(PartID),
    write(' '),
    write(PortID),
    write(' '),
    write(Wire),
    write(' '),
    write(Pin),
    write(')'),
    nl.

getAllOutPinsForPart(PartID):-
    forall(outPinOfPart(PortID,PartID),getOneOutPin(PortID,PartID)).

outPinOfPart(PortID,PartID) :-
    parent(PortID,PartID),
    source(_,PortID).

getOneOutPin(PortID,PartID):-
    eltype(PortID,port),
    pipeNum(PortID,Wire),
    portIndex(PortID,Pin),
    write('    ('),
    write(PartID),
    write(' '),
    write(PortID),
    write(' '),
    write(Wire),
    write(' '),
    write(Pin),
    write(')'),
    nl.


emitExecs:-
    write('  execs ('),
    nl,
    forall(kind(PartID,ExecName),emitExec(PartID,ExecName)),
    write('  )'),
    nl.

emitExec(PartID,ExecName) :-
    write('    ('),
    write(PartID),
    write(' "'),
    write(ExecName),
    write('")'),
    nl.

:- include('tail').





