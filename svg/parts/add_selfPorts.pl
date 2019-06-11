:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(eltype(EllipseID,ellipse),createSelfPorts(EllipseID)),
    writeFB,
    halt.

createSelfPorts(EllipseID) :-
    % find one port that touches the ellispe (if there are more, then the "coincidentPorts"
    % pass will find them), asserta all facts needed by ports downstream - portIndex, sink,
    % source, parent
    eltype(PortID,port),
    bounding_box_left(EllipseID,ELeftX),
    bounding_box_top(EllipseID,ETopY),
    bounding_box_right(EllipseID,ERightX),
    bounding_box_bottom(EllipseID,EBottomY),
    bounding_box_left(PortID,PortLeftX),
    bounding_box_top(PortID,PortTopY),
    bounding_box_right(PortID,PortRightX),
    bounding_box_bottom(PortID,PortBottomY),
    portTouchesEllipse(PortLeftX,PortTopY,PortRightX,PortBottomY,ELeftX,ETopY,ERightX,EBottomY),
    text(IndexID,Index),
    textCompletelyInside(IndexID,EllipseID),
    !,
    number(Index),
    asserta(parent(EllipseID,PortID)),
    asserta(used(IndexID)),
    asserta(portIndexByID(PortID,IndexID)),
    asserta(portIndex(PortID,Index)).

portTouchesEllipse(PortLeftX,PortTopY,PortRightX,PortBottomY,ELeftX,ETopY,_,EBottomY):-
    % port touches left side of ellipse bounding rect
    PortLeftX =< ELeftX,
    PortRightX >= ELeftX,
    PortTopY >= ETopY,
    PortBottomY =< EBottomY.

portTouchesEllipse(PortLeftX,PortTopY,PortRightX,PortBottomY,ELeftX,ETopY,ERightX,_):-
    % port touches top of ellipse bounding rect
    PortTopY =< ETopY,
    PortBottomY >= ETopY,
    PortLeftX >= ELeftX,
    PortRightX =< ERightX.

portTouchesEllipse(PortLeftX,PortTopY,PortRightX,PortBottomY,_,ETopY,ERightX,EBottomY):-
    % port touches right side of ellipse bounding rect
    PortLeftX =< ERightX,
    PortRightX >= ERightX,
    PortTopY >= ETopY,
    PortBottomY =< EBottomY.

portTouchesEllipse(PortLeftX,PortTopY,PortRightX,PortBottomY,ELeftX,_,ERightX,EBottomY):-
    % port touches bottom of ellipse bounding rect
    PortTopY =< EBottomY,
    PortBottomY >= EBottomY,
    PortLeftX >= ELeftX,
    PortRightX =< ERightX.




textCompletelyInside(TextID,OBJID) :-
    boundingboxCompletelyInside(TextID,OBJID).

:- include('tail').
