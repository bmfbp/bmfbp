:- initialization(main).
:- include('../common/head').

main :-
    readFB(user_input), 
    assignUnassignedTextToPorts,
    writeFB,
    halt.

wspc :-
    write(user_error,' ').

nlu :- nl(user_error).

we(X) :- write(user_error,X).

assignUnassignedTextToPorts :-
    forall(unassigned(TextID),assignPort(TextID)).

assignPort(TextID):-
    minimumDistanceToAPort(TextID,PortID),
%  write(user_error,'0 '),write(user_error,TextID),wspc,write(user_error,PortID),nl(user_error),
    asserta(portNameByID(PortID,TextID)),
    text(TextID,Str),
%  write(user_error,TextID),wspc,write(user_error,PortID),wspc,write(user_error,Str),nlu,
    asserta(portName(PortID,Str)).

minimumDistanceToAPort(TextID,PortID) :-
%  write(user_error,'1 '),write(user_error,TextID),nl(user_error),
    unassigned(TextID),  %% redundant (since the caller asserts this)
%  write(user_error,'2 '),write(user_error,TextID),nl(user_error),
    findAllDistancesToPortsFromGivenUnassignedText(TextID,DistancePortIDList),
%  write(user_error,'3 '),write(user_error,TextID),nl(user_error),
    splitLists(DistancePortIDList,Distances,PortIDs),
%  write(user_error,'4 '),write(user_error,TextID),nl(user_error),
%  write(user_error,'5 '),write(user_error,TextID),nl(user_error),
    findMinimumDistanceInList(Distances,Min),
%  write(user_error,'6 '),write(user_error,TextID),nl(user_error),
    findPositionOfMinimumInList(Min,Distances,Index),
%  write(user_error,'7 '),write(user_error,TextID),nl(user_error),
    findPortAtIndex(Index,PortIDs,PortID).
%  we('8 '),we(TextID),wspc,we(Index),wspc,we(PortID),nl(user_error).

findAllDistancesToPortsFromGivenUnassignedText(TextID,DistancePortIDPairList):-
    findall(DistancePortIDPair,findOneDistanceToAPortFromGivenUnassignedText(TextID,DistancePortIDPair),DistancePortIDPairList).

findOneDistanceToAPortFromGivenUnassignedText(TextID,DistancePortIDPair):-
    join_distance(CPID,TextID),
    distance_xy(CPID,Distance),
    join_centerPair(PortID,CPID),
    DistancePortIDPair = [Distance, PortID].


findMinimumDistanceInList(Distances,Min):-
    min_list(Distances,Min).

findPositionOfMinimumInList(Min,List,Position):-
    nth(Position,List,Min).

findPortAtIndex(Position,Ports,PortID):-
    nth(Position,Ports,PortID).


splitLists([],[],[]).
splitLists([[N1,ID1]|Tail],Ns,IDs):-
    splitLists(Tail,Nlist,IDlist),
    append([N1],Nlist,Ns),
    append([ID1],IDlist,IDs).


:- include('../common/tail').
