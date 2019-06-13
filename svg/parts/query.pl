:- include(head).

logAllEdges :-
    %forall(edge(Wire),log(edge,Wire)).
    forall(edge(Wire),logEdge(Wire)).

logEdge(Wire) :-
    asserta(log(wire,Wire)).

portsOnWire(Source,Wire,Sink) :-
    source(Wire,Source),
    sink(Wire,Sink),
    log(wiresourcesink,Source,Wire,Sink).
