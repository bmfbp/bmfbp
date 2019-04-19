:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(eltype(ID,box),createKinds(ID)),
    writeFB,
    halt.

createKinds(Box) :-
we('ck '),we(Box),nle,
    text(TextID,Str),
we(TextID),wspc,we(Str),wspc,
    textCompletelyInsideBox(TextID,Box),
text(TextID,Str),wspc,we(TextID),wspc,wen(Str),
    asserta(used(TextID)),
    asserta(kind(Box,Str)),
we('text '),we(TextID),wspc,we(Str),we(' inside box '),wen(Box).

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
    bounding_box_bottom(ID2,B2),

we(L1), wspc,
we(T1), wspc,
we(R1), wspc,
we(B1), wspc,
we(L2), wspc,
we(T2), wspc,
we(R2), wspc,
we(B2), wspc,
nle,
    L1 >= L2,
we('a'),
    T1 >= T2,
we('b'),
    R2 >= R1,
we('c'),
    B2 >= B1,
we('d'),
nle.    

pointCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2),

we('pcibb id1='), we(ID1),we(' id2='),we(ID2),wspc,
we(L1), wspc,
we(T1), wspc,
we(L2), wspc,
we(T2), wspc,
we(R2), wspc,
we(B2), wspc,
nle,
    L1 >= L2,
we('a'),
    T1 >= T2,
we('b'),
    R2 >= L1,
we('c'),
    B2 >= T1,
we('d'),
nle.    


:- include('tail').
