:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(eltype(ID,box),createKinds(ID)),
    writeFB,
    halt.

createKinds(OBJ) :-
    text(TextID,Str),
    textCompletelyInsideBox(TextID,OBJ),
    asserta(used(TextID)),
    asserta(kind(Box,Str)).

textCompletelyInsideBox(TextID,BoxID) :-
    pointCompletelyInsideBoundingBox(TextID,BoxID).
%    boundingboxCompletelyInside(TextID,BoxID).

:- include('tail').
