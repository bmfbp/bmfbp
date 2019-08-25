:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    logAllEdges,
    writeFB,
    halt.

logAllEdges :-
    forall(edge(Wire),portsOnWire(_,Wire,_)).

portsOnWire(SourcePort,Wire,SinkPort) :-
    get_info(SourceParent,SourceParentName,SourceName,Wire,WN,SinkParent,SinkParentName,SinkName),
    asserta(log(parent_source_wire_parent_sink,SourceParent,SourceParentName,SourceName,wire(Wire),wireNum(WN),SinkParent,SinkParentName,SinkName)).

:- include('query').
:- include('tail').

