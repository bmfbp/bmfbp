:- include('../common/head').
:- include('../common/tail').

list_min([L|Ls], Min) :-
    list_min(Ls, L, Min).
list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    list_min(Ls, Min1, Min).

flatten([],[],[]).
flatten([[N|ID]],[N],ID).
flatten([[N1|I1]|Tail],[N1],I1,Tail).

test1(N,I) :-
    flatten([],N,I).

test2(N,I) :-
    flatten([[1,id1]],N,I).

test3(N,I,Tail) :-
    flatten([[1,id1],[2,id2]],N,I,Tail).


%% (6 ms) yes
%% | ?- test4(N,I,T).

%% I = [id1]
%% N = [1]
%% T = [[2,id2],[3,id3]]

%% (1 ms) yes

test4(N,I,Tail) :-
    flatten([[1,id1],[2,id2],[3,id3]],N,I,Tail).


