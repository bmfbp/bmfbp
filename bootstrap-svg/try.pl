:- include('../common/head').
:- include('../common/tail').

list_min([L|Ls], Min) :-
    list_min(Ls, L, Min).
list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    list_min(Ls, Min1, Min).

flatten([],[],[]).
flatten([[N|ID]],[N],[ID]).
%% IS is for eval'ing math.
flatten([[N1|I1],[N2|I2]],N,I) :-
    unify(N,[N1,N2]),
    append(I1,I2,I).

flatten([[N1,I1],[N2,I2],[N3,I3]],N,I) :-
    unify(N,[N1,N2,N3]),
    unify(I,[I1,I2,I3]).

unify(X,X).

test1(N,I) :-
    flatten([],N,I).

test2(N,I) :-
    flatten([[1,id1]],N,I).

%% | ?- test3(N,I).
%% I = [id1,id2]
%% N = [1,2]
test3(N,I) :-
    flatten([[1,id1],[2,id2]],N,I).

test4(N,I) :-
    flatten([[1,id1],[2,id2],[3,id3]],N,I).



