:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    assignUnassignedTextToPorts,
    writeFB,
    halt.

assignUnassignedTextToPorts :-
    forall(unassigned(TextID),assignPort(TextID)).

assignPort(TextID):-
    minimumDistanceToAPort(TextID,PortID),
    text(TextID,Str),
    asserta(portNameByID(PortID,TextID)),
    asserta(portName(PortID,Str)),
    tryIndex(PortID,TextID,Str).

tryIndex(PortID,NumericID,Num):-
    number(Num),
    asserta(portIndexByID(PortID,NumericID)),
    asserta(portIndex(PortID,Num)).
    
tryIndex(PortID,NumericID,Num):-
   we(PortID),we(' nonnumeric name '),we(NumericID),wspc,wen(Num),
%    asserta(log(PortID,' nonnumeric name ',NumericID, Num)),
    true.

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


:- include('tail').
