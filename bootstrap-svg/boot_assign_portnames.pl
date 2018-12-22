:- initialization(main).
:- include('../common/head').

main :-
    readFB(user_input), 
    assignUnassignedTextToPorts,
    writeFB,
    halt.

assignUnassignedTextToPorts :-
    forall(unassigned(TextID),minimumDistanceToAPort(TextID,PortID)),
    asserta(portNameByID(PortID,TextID)),
    text(TextID,Str),
    asserta(portName(portID,Str)).

minimumDistanceToAPort(TextID,PortID) :-
    unassigned(TextID),  %% redundant (since the caller asserts this)
    findAllDistancesToPortsFromGivenUnassignedText(TextID,DistancePortIDList),
    splitLists(DistancePortIDList,Distances,PortIDs),
    findMinimumDistanceInList(Distances,Min),
    findPositionOfMinimumInList(Min,Distances,Index),
    findPortAtIndex(Index,PortIDs,PortID).

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
