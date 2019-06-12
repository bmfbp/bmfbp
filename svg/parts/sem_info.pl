:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(eltype(PortID,port),portInfo(PortID)),
    forall(log(Rel,A,_,_),printLog(Rel,A)),
    halt.

portInfo(PortID) :-
    infoName(PortID),
    infoIndex(PortID),
    !.


portInfo(PortID) :-
    infoName(PortID).

portInfo(PortID) :-
    infoIndex(PortID).

portInfo(_) :-
    true.


infoName(PortID) :-
    portName(PortID,Str),
    we('port '),we(PortID),we(' has name '),wen(Str).

infoIndex(PortID) :-
    portIndex(PortID,Index),
    we('port '),we(PortID),we(' has Index '),wen(Index).

printLog(Rel,A) :-
    log(Rel,A,B,I),
    we(Rel),wspc,we(A),wspc,we(B),wspc,wen(I),
    !.

printLog(_,_) :-
    true.

:- include('tail').
