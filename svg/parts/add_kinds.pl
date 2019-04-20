:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(eltype(ID,box),createKinds(ID)),
    writeFB,
    halt.

createKinds(Box) :-
    text(TextID,Str),
    textCompletelyInsideBox(TextID,Box),
    asserta(used(TextID)),
    asserta(kind(Box,Str)).

textCompletelyInsideBox(TextID,BoxID) :-
    pointCompletelyInsideBoundingBox(TextID,BoxID).
%    boundingboxCompletelyInside(TextID,BoxID).

boundingboxCompletelyInside(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),
    bounding_box_right(ID1,R1),
    bounding_box_bottom(ID1,B1),

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2).

pointCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2).

:- include('tail').
