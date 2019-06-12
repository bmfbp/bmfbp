:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(eltype(PortID,port),portInfo(PortID)),
    halt.

portInfo(PortID) :-
    infoName(PortID),
    infoIndex(PortID),
    !.


portInfo(PortID) :-
    infoName(PortID).

portInfo(PortID) :-
    infoIndex(PortID).

portInfo(PortID) :-
    true.


infoName(PortID) :-
    portName(PortID,Str),
    we('port '),we(PortID),we(' has name '),wen(Str).

infoIndex(PortID) :-
    portIndex(PortID,Index),
    we('port '),we(PortID),we(' has Index '),wen(Index).
    
:- include('tail').
