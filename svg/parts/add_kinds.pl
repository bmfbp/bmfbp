:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    condDoKinds,
    writeFB,
    halt.

condDoKinds :-
    forall(eltype(ID,box),createAllKinds(ID)),
    !.

condDoKinds :- true.

createAllKinds(BoxID) :-
    forall(text(TextID,_),createOneKind(BoxID,TextID)).

createOneKind(BoxID,TextID) :-
    text(TextID,Str),
    \+ used(TextID),
    textCompletelyInsideBox(TextID,BoxID),
    asserta(used(TextID)),
    asserta(kind(BoxID,Str)).

createOneKind(_,_) :-
    true.

textCompletelyInsideBox(TextID,BoxID) :-
    pointCompletelyInsideBoundingBox(TextID,BoxID).

:- include('tail').
