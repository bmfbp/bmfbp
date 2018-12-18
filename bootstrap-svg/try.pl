:- include('../common/head').
:- include('../common/tail').
:- include('bootstrap-output').


findClosestTextForPort(PortID,Pairs) :-	    
    findAllCandidateTextsForGivenPort(PortID,Pairs).
%    flatten(Pairs,Ns,I).
%    min_list(Ns,Min).

test(Pairs) :-
    findClosestTextForPort(id423,Pairs).

findAllCandidateTextsForGivenPort(Port,Pairs) :-
    findall(Pair,distanceToTextFromPort(Port,Pair),Pairs).

distanceToTextFromPort(PortId,Pair):-
    % reconstruct the data structure, and return one pair {TextID,distance-to-text-from-port}
    join_centerPair(PortId,CenterPairID),
    join_distance(CenterPairID,TextID),
    distance_xy(CenterPairID,DistanceFromPort),
    Pair = [DistanceFromPort,TextID].


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

test1(N,I) :-
    flatten([],N,I).

test2(N,I) :-
    flatten([[1,id1]],N,I).

test3(N,I) :-
    flatten([[2,id2],[1,id1]],N,I).

test4(N,I) :-
    flatten([[3,id3],[4,id4],[2,id2],[1,id1]],N,I).

test5(Min) :-
    flatten([[3,id3],[4,id4],[2,id2],[1,id1]],N,_),
    min_list(N,Min).

test6(Min,POS) :-
    flatten([[3,id3],[4,id4],[2,id2],[1,id1]],N,_),
    min_list(N,Min),
    nth(Min,N,POS).

test7(Min,POS,ID) :-
    findID([[3,id3],[4,id4],[2,id2],[1,id1]],Min,POS,ID).

test8(Min,POS,ID) :-
    findID([[3,id3],[4,id4],[55,id55],[2,id2],[666,id666],[1,id1],[777,id777]],Min,POS,ID).

%% | ?- test9(M,P,I).
%% I = id430
%% M = 226.82894000766305
%% P = 5 ? ;
test9(Min,POS,ID) :-
    findAllCandidateTextsForGivenPort(id423,Pairs),
    findID(Pairs,Min,POS,ID).

test10(Min,ID) :-
    findAllCandidateTextsForGivenPort(id423,Pairs),
    findID(Pairs,Min,_,ID).

test11(PortID,ID) :-
    findClosestTextForPort(PortID,ID).
