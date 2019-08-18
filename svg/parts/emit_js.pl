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
    nwires(Nwires),
    write('wirecount  '),
    write(Nwires),
    nl,
    emitMetaData,
    write('parts ('),
    nl,
    emitAllPins,
    emitExecs,
    write(' )'),
    nl,
    write(')'),
    nl,
    halt.

emitMetaData :-
    metadata(_,TextID),
    write('metadata  '),
    text(TextID,Str),
    write(Str),
    nl.

emitMetaData :-
    true.

emitAllPins :-
    write('  ins ('), nl,
    forall(selfInputPin(_,WireIndex),printSelfInputOrOutput(WireIndex)),
wen('a'),
    forall(eltype(PartID,box),getAllInPinsForPart(PartID)),
wen('b'),
    write('  )'), nl,
    write('  outs ('), nl,
    forall(selfOutputPin(_,WireIndex),printSelfInputOrOutput(WireIndex)),
    forall(eltype(PartID,box),getAllOutPinsForPart(PartID)),
    write('  )'), nl.

emitAllPins :-
    true.

printSelfInputOrOutput(Pin) :-
    write('    (self nil '),
    wireIndex(Pin,WireIndex),
    write(WireIndex),
    write(' '),
    write(Pin),
    write(')'),
    nl.

getAllInPinsForPart(PartID) :-
    pinless(PartID).  %% skip pinless parts (there should be at most 1 - the metadata rect).

getAllInPinsForPart(PartID):-
    forall(inPinOfPart(PortID,PartID),getOneInPin(PortID,PartID)).

getAllInPinsForPart(PartID):-
    forall(inPinOfPart(PortID,PartID),getOneInPin(PortID,PartID)).

inPinOfPart(PortID,PartID) :-
    parent(PortID,PartID),
    sink(_,PortID).

getOneInPin(PortID,PartID):-
    eltype(PortID,port),
    wireNum(PortID,Wire),
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
    pinless(PartID).  %% do nothing

getAllOutPinsForPart(PartID):-
    forall(outPinOfPart(PortID,PartID),getOneOutPin(PortID,PartID)).

outPinOfPart(PortID,PartID) :-
    parent(PortID,PartID),
    source(_,PortID).

getOneOutPin(PortID,PartID):-
    eltype(PortID,port),
    wireNum(PortID,Wire),
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
    write('    (self "schematic")'),
    nl,
    write('  )'),
    nl.

emitExec(PartID,_) :-
    pinless(PartID).  %% do nothing

emitExec(PartID,ExecName) :-
    write('    ('),
    write(PartID),
    write(' "'),
    write(ExecName),
    write('")'),
    nl.

:- include('tail').





