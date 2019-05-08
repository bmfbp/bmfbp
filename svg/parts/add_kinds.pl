:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(eltype(ID,box),createKinds(ID)),
    writeFB,
    halt.

createKinds(BoxID) :-
    text(TextID,Str),
    textCompletelyInsideBox(TextID,BoxID),
    asserta(used(TextID)),
    asserta(kind(BoxID,Str)).

textCompletelyInsideBox(TextID,BoxID) :-
    leftTopPointCompletelyInsideBoundingBox(TextID,BoxID).
%    boundingboxCompletelyInside(TextID,BoxID).

:- include('tail').
