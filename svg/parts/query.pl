:- include(head).

get_info(SourceParent,SourceParentName,SourceName,Wire,WN,SinkParent,SinkParentName,SinkName):-
    sourceOf(Wire,SourcePort),
    wireNum(Wire,WN),
    number(WN),
    portNameOf(SourcePort,SourceName),
    parentOf(SourcePort,SourceParent),
    kindOf(SourceParent,SourceParentName),
    sinkOf(Wire,SinkPort),
    parentOf(SinkPort,SinkParent),
    kindOf(SinkParent,SinkParentName),
    portNameOf(SinkPort,SinkName).

sourceOf(Wire,Port) :-
    source(Wire,Port),!.
sourceOf(_,Port) :-
    Port = null.

sinkOf(Wire,Port) :-
    sink(Wire,Port),!.
sinkOf(_,Port) :-
    Port = null.


parentOf(Port,Parent) :-
    parent(Parent,Port),!.

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

