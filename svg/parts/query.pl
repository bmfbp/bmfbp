:- include(head).

logAllEdges :-
    forall(edge(Wire),portsOnWire(_,Wire,_)).

portsOnWire(SourcePort,Wire,SinkPort) :-
    sourceOf(Wire,SourcePort),
    portNameOf(SourcePort,SourceName),
    parentOf(SourcePort,SourceParent),
    kindOf(SourceParent,SourceParentName),
    sinkOf(Wire,SinkPort),
    parentOf(SinkPort,SinkParent),
    kindOf(SinkParent,SinkParentName),
    portNameOf(SinkPort,SinkName),
    asserta(log(parent_source_wire_parent_sink,SourceParent,SourceParentName,SourceName,wire(Wire),SinkParent,SinkParentName,SinkName)).

sourceOf(Wire,Port) :-
    source(Wire,Port),!.
sourceOf(_,Port) :-
    Port = null.

sinkOf(Wire,Port) :-
    sink(Wire,Port),!.
sinkOf(_,Port) :-
    Port = null.


parentOf(Port,Parent) :-
    parent(Port,Parent),!.

parentOf(_,Parent) :-
    Parent = null.


portNameOf(Port,Name) :-
    portName(Port,Name),!.

portNameOf(_,Name) :-
    Name = null.


kindOf(Parent,Name) :-
    kind(Parent,Name),!.

kindOf(_,Name) :-
    Name = null.

