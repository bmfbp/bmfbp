:- initialization(main).
:- include('../common/head').

main :-
    readFB(user_input), 
    assignPortNames,
    writeFB,
    halt.

findClosestTextForPort(PortID,UnassignedText) :-
    findAllCandidateTextsForGivenPort(PortID,Pairs),
    flatten(Pairs,Ns,I),
    min_list(Ns,Min),
    nth(Position,Ns,Min),
    nth(Position,I,UnassignedTextID),
    unassigned(UnassignedTextID),
    text(UnassignedTextID,UnassignedText).

findAllCandidateTextsForGivenPort(Port,Pairs) :-
    findall(Pair,distanceToTextFromPort(Port,Pair),Pairs).

distanceToTextFromPort(PortId,Pair):-
    % reconstruct the data structure, and return one pair {TextID,distance-to-text-from-port}
    join_centerPair(PortId,CenterPairID),
    join_distance(CenterPairID,TextID),
    distance_xy(CenterPairID,DistanceFromPort),
    Pair = [DistanceFromPort,TextID].

assignTextToPort(PortID,UnassignedText) :-
    findClosestTextForPort(PortID,UnassignedText),
    asserta(portName(PortID,UnassignedText)).
    %% write(user_error,'portName('),write(user_error,PortID),write(user_error,','),write(user_error,UnassignedText),write(user_error,')'),nl(user_error).

assignPortNames:-
    forall(eltype(PortID,'port'),assignTextToPort(PortID,_)).

flatten([],[],[]).
flatten([[N1,ID1]|Tail],Ns,IDs):-
    flatten(Tail,Nlist,IDlist),
    append([N1],Nlist,Ns),
    append([ID1],IDlist,IDs).

unify(X,X).

findID(List,Min,Pos,ID):-
    flatten(List,Ns,IDs),
    min_list(Ns,Min),
    nth(Pos,Ns,Min),
    nth(Pos,IDs,ID).

:- include('../common/tail').
