:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
wen(aa),
    forall(eltype(EllipseID,ellipse),createSelfPorts(EllipseID)),
wen(bb),
    writeFB,
    halt.

createSelfPorts(EllipseID) :-
    % find one port that touches the ellispe (if there are more, then the "coincidentPorts"
    % pass will find them), asserta all facts needed by ports downstream - portIndex, sink,
    % source, parent
    eltype(PortID,port),
wen(a),
    bounding_box_left(EllipseID,ELeftX),
wen(b),
    bounding_box_top(EllipseID,ETopY),
wen(c),
    bounding_box_right(EllipseID,ERightX),
wen(d),
    bounding_box_bottom(EllipseID,EBottomY),
wen(e),
    bounding_box_left(PortID,PortLeftX),
wen(f),
    bounding_box_top(PortID,PortTopY),
wen(g),
    bounding_box_right(PortID,PortRightX),
wen(h),
    bounding_box_bottom(PortID,PortBottomY),
wen(i),
    portTouchesEllipse(PortLeftX,PortTopY,PortRightX,PortBottomY,ELeftX,ETopY,ERightX,EBottomY),
wen(j),
    text(IndexID,Index),
wen(k),
    textCompletelyInside(IndexID,EllipseID),
wen(l),
    !,
wen(m),
    number(Index),
wen(n),
    asserta(parent(EllipseID,PortID)),
wen(o),
    asserta(used(IndexID)),
wen(p),
    asserta(portIndexByID(PortID,IndexID)),
wen(q),
    asserta(portIndex(PortID,Index)).

portTouchesEllipse(_,PortTopY,PortRightX,PortBottomY,ELeftX,ETopY,_,EBottomY):-
    % port touches left side of ellipse bounding rect
    PortRightX >= ELeftX,
    PortTopY =< ETopY,
    PortBottomY >= EBottomY.

portTouchesEllipse(PortLeftX,_,PortRightX,PortBottomY,ELeftX,ETopY,ERightX,_):-
    % port touches top of ellipse bounding rect
    PortBottomY >= ETopY,
    PortLeftX >= ELeftX,
    PortRightX =< ERightX.

portTouchesEllipse(PortLeftX,PortTopY,_,PortBottomY,_,ETopY,ERightX,EBottomY):-
    % port touches right side of ellipse bounding rect
    PortLeftX =< ERightX,
    PortTopY =< ETopY,
    PortBottomY >= EBottomY.

portTouchesEllipse(PortLeftX,PortTopY,PortRightX,_,ELeftX,_,ERightX,EBottomY):-
    % port touches bottom of ellipse bounding rect
    PortTopY =< EBottomY,
    PortLeftX >= ELeftX,
    PortRightX =< ERightX.




textCompletelyInside(TextID,OBJID) :-
    boundingboxCompletelyInside(TextID,OBJID).

:- include('tail').
