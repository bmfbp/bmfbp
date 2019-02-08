:- initialization(main).
:- include('head').


main :-
    readFB(user_input),
    forall(ellipse(EllipseID),maybeConvertEllipseToDot(EllipseID)),
    writeFB,
    halt.

convertEllipseToDot(EllipseID) :-
    retract(rect(EllipseID,'')),
    retract(eltype(EllipseID,box)),
    asserta(ellipse(EllipseID)),
    asserta(eltype(EllipseID,ellipse)).

maybeConvertEllipseToDot(EllipseID):-
    verySmallSize(EllipseID),
    noKind(EllipseID),
    convertEllipseToDot(EllipseID).

noKind(ID) :-
    kind(ID,_),
    !,
    fail.

noKind(_) :-
    true.

verySmallSize(ID) :-
    bounding_box_left(ID,Left),
    bounding_box_top(ID,Top),
    bounding_box_right(ID,Right),
    bounding_box_bottom(ID,Bottom),
    0.1 >= abs(Right - Left),
    0.1 >= abs(Bottom - Top).    

:- include('tail').
