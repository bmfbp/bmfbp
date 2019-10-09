:- initialization(main).
:- include('head').
:- include('query').

main :-
    readFB(user_input),
    write('('),
    nl,
    write('kindName "'),
    component(Name),
    write(Name),
    write('"'),
    nl,
    nwires(Nwires),
    write('wirecount  '),
    write(Nwires),
    nl,
    emitMetaData,
    write('wires ('),
    nl,
    forall(edge(Wire),printWire(Wire)),
    write(')'),
    nl,
    write(')'),
    nl,
    halt.

printWire(Wire):-
    get_info(SourceParent,SourceParentName,SourceName,Wire,WN,SinkParent,SinkParentName,SinkName),
    write('('),
    write(SourceParent),
    write(' '),
    write(SourceParentName),
    write(' '),
    write(SourceName),
    write(' '),
    write(Wire),
    write(' '),
    write(WN),
    write(' '),
    write(SinkParent),
    write(' '),
    write(SinkParentName),
    write(' '),
    write(SinkName),
    write(')'),
    nl.

emitMetaData :-
    metadata(_,TextID),
    write('metadata  '),
    text(TextID,Str),
    write(Str),
    nl.

emitMetaData :-
    true.

:- include('tail').





