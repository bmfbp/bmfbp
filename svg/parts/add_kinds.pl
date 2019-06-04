:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    condDoKinds,
    writeFB,
    halt.

condDoKinds :-
    forall(eltype(ID,box),createKinds(ID)),
    !.

condDoKinds :- true.

createKinds(BoxID) :-
    text(TextID,Str),
    textCompletelyInsideBox(TextID,BoxID),
    asserta(used(TextID)),
    asserta(kind(BoxID,Str)).

textCompletelyInsideBox(TextID,BoxID) :-
    pointCompletelyInsideBoundingBox(TextID,BoxID).
%    boundingboxCompletelyInside(TextID,BoxID).

:- include('tail').
