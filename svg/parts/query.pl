:- include(head).

logAllEdges :-
    forall(edge(Wire),portsOnWire(_,Wire,_)).

portsOnWire(SourcePort,Wire,SinkPort) :-
    sourceOf(Wire,SourcePort),
    portIndexOf(SourcePort,SourceIndex),
    parentOf(SourcePort,SourceParent),
    kindOf(SourceParent,SourceParentName),
    sinkOf(Wire,SinkPort),
    parentOf(SinkPort,SinkParent),
    kindOf(SinkParent,SinkParentName),
    portIndexOf(SinkPort,SinkIndex),
    asserta(log(parent_source_wire_parent_sink,SourceParent,SourceParentName,SourceIndex,wire(Wire),SinkParent,SinkParentName,SinkIndex)).

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


portIndexOf(Port,Index) :-
    portIndex(Port,Index),!.

portIndexOf(_,Index) :-
    Index = null.


kindOf(Parent,Name) :-
    kind(Parent,Name),!.

kindOf(_,Name) :-
    Name = null.

