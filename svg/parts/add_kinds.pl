:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(eltype(ID,box),createKinds(ID)),
    writeFB,
    halt.

createKinds(Box) :-
%    write(user_error,'ck '),write(user_error,Box),nl(user_error),
    text(TextID,Str),
%    write(user_error,TextID),write(user_error,' '),write(user_error,Str),write(user_error,' '),
    textCompletelyInsideBox(TextID,Box),
%    write(user_error,' '),write(user_error,Text),write(user_error,' '),
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
    bounding_box_bottom(ID2,B2),

%write(user_error,'inside '), write(user_error,' '),
%write(user_error,L1), write(user_error,' '),
%write(user_error,T1), write(user_error,' '),
%write(user_error,R1), write(user_error,' '),
%write(user_error,B1), write(user_error,' '),
%write(user_error,L2), write(user_error,' '),
%write(user_error,T2), write(user_error,' '),
%write(user_error,R2), write(user_error,' '),
%write(user_error,B2), write(user_error,' '),
%nl(user_error),
    L1 >= L2,
%write(user_error,'a'),
    T1 >= T2,
%write(user_error,'b'),
    R2 >= R1,
%write(user_error,'c'),
    B2 >= B1.
%write(user_error,'d'),
%nl(user_error).    

pointCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2),

%write(user_error,'inside '), write(user_error,' '),
%write(user_error,L1), write(user_error,' '),
%write(user_error,T1), write(user_error,' '),
%write(user_error,L2), write(user_error,' '),
%write(user_error,T2), write(user_error,' '),
%write(user_error,R2), write(user_error,' '),
%write(user_error,B2), write(user_error,' '),
%nl(user_error),
    L1 >= L2,
%write(user_error,'a'),
    T1 >= T2,
%write(user_error,'b'),
    R2 >= L1,
%write(user_error,'c'),
    B2 >= T1.
%write(user_error,'d'),
%nl(user_error).    


:- include('tail').
