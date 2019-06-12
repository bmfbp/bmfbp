:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    %forall(eltype(PortID,port),portInfo(PortID)),
    forall(log(Rel1,X,Y),printLog3(Rel1,X,Y)),
    forall(log(Rel,A,B,C),printLog4(Rel,A,B,C)),
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

printLog3(Rel,A,B) :-
    we(3),we(Rel),wspc,we(A),wspc,wen(B),
    !.
printLog3(_,_,_) :-
    !,true.

printLog4(Rel,A,B,C) :-
    we(4),we(Rel),wspc,we(A),wspc,we(B),wspc,wen(C),
    !.
printLog4(_,_,_,_) :-
    !,true.

:- include('tail').
