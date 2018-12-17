:- include('../common/head').
:- include('../common/tail').

flatten([],[],[]).
flatten([[N1,ID1]|Tail],Ns,IDs):-
    flatten(Tail,Nlist,IDlist),
    append([N1],Nlist,Ns),
    append([ID1],IDlist,IDs).

unify(X,X).

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





