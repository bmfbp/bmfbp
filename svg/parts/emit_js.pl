:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    write('('),
    nl,
    write('name "'),
    component(Name),
    write(Name),
    write('"'),
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

% for self print
% (self nil wireNum portName)
% for parts print
% (partid portid wireNum portName)
% skip pinless parts
emitAllPins :-
    write('  ins ('), nl,
      forall(selfInputPin(PortID),printSelfInputPort(PortID)),
      forall(inputPin(PartID,_),printInputPort(PartID)),
    write('  )'), nl,
    write('  outs ('), nl,
      forall(selfOutputPin(PortID),printSelfOutputPort(PortID)),
      forall(outputPin(PartID,_),printOutputPort(PartID)),
    write('  )'), nl.

emitAllPins :-
    true.

printSelfInputPort(PortID) :-
    write('    (self nil '),
    source(EdgeID,PortID),
    edge(EdgeID),
    wireNum(EdgeID,WN),
    write(WN),
    write(' '),
    portName(portID,Name),
    write(Name),
    write(')'),
    nl.
    
printSelfOutputPort(PortID) :-
    write('    (self nil '),
    sink(EdgeID,PortID),
    edge(EdgeID),
    wireNum(EdgeID,WN),
    write(WN),
    write(' '),
    portName(portID,Name),
    write(Name),
    write(')'),
    nl.

% (partid portid wireNum portName)
% skip pinless parts
printInputPort(PartID) :-
    pinless(PartID),!.

printInputPort(PartID) :-
    write('    ('),
    inputPort(PartID,PortID),
    sink(EdgeID,PortID),
    edge(EdgeID),
    wireNum(EdgeID,WN),
    write(PartID),
    write(' '),
    write(PortID),
    write(' '),
    write(WN),
    write(' '),
    portName(portID,Name),
    write(Name),
    write(')'),
    nl.

printInputPort(PartID) :-
    true.



printOutputPort(PartID) :-
    pinless(PartID),!.

printOutputPort(PartID) :-
    write('    ('),
    outputPort(PartID,PortID),
    sourse(EdgeID,PortID),
    edge(EdgeID),
    wireNum(EdgeID,WN),
    write(PartID),
    write(' '),
    write(PortID),
    write(' '),
    write(WN),
    write(' '),
    portName(portID,Name),
    write(Name),
    write(')'),
    nl.

printOutputPort(PartID) :-
    true.


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





