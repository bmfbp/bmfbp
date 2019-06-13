:- include(head).

logAllEdges :-
    forall(edge(Wire),portsOnWire(_,Wire,_)).

portsOnWire(Source,Wire,Sink) :-
    sourceOf(Wire,SourcePort),
    portIndexOf(SourcePort,SourceIndex),
    parentOf(SourcePort,SourceParent),
    kindOf(SourceParent,SourceParentName),
    sinkOf(Wire,SinkPort),
    parentOf(SinkPort,SinkParent),
    kindOf(SinkParent,SinkParentName),
    portIndexOf(SinkPort,SinkIndex),
    asserta(log(sourcewiresinkparent,SourceParentName,SourceIndex,Wire,SinkParentName,SinkIndex)).

sourceOf(Wire,Port) :-
    source(Wire,Port),!.
sourceOf(_,Port) :-
    Port = nil.

sinkOf(Wire,Port) :-
    sink(Wire,Port),!.
sinkOf(_,Port) :-
    Port = nil.


parentOf(Port,Parent) :-
    parent(Port,Parent),!.

parentOf(_,Parent) :-
    Parent = nil.


portIndexOf(Port,Index) :-
    portIndex(Port,Index),!.

portIndexOf(_,Index) :-
    Index = nil.


kindOf(Parent,Name) :-
    kind(Parent,Name),!.

kindOf(_,Name) :-
    Name = nil.

