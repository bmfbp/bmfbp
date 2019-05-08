:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    match_ports,
    writeFB,
    halt.

match_ports :-
    % assign a parent component to every port, port must intersect parent's bounding-box
    % unimplemented semantic check: check that every port has exactly one parent
    forall(eltype(PortID, port),assign_parent_for_port(PortID)).

assign_parent_for_port(PortID) :-
    % if port already has a parent (e.g. ellipse), quit while happy.
    parent(PortID,_).

assign_parent_for_port(PortID) :-
    ellipse(ParentID),
    portIntersection(PortID,ParentID),
    asserta(parent(PortID, ParentID)).

assign_parent_for_port(PortID) :-
    eltype(ParentID, box),
    portIntersection(PortID,ParentID),
    asserta(parent(PortID, ParentID)).

assign_parent_for_port(PortID) :-
    portIndex(PortID,IX),
    asserta(n_c(PortID)),
    nle,nle,we('no parent box for port '),we(PortID),we(' named '),we(IX),nle,nle,nle.

assign_parent_for_port(PortID) :-
    asserta(n_c(PortID)),
    nle,nle,we('no parent box for port '),we(PortID),nle,nle,nle.


portIntersection(PortID,ParentID):-
    bounding_box_left(PortID, Left),
    bounding_box_top(PortID, Top),
    bounding_box_right(PortID, Right),
    bounding_box_bottom(PortID, Bottom),
    bounding_box_left(ParentID, PLeft),
    bounding_box_top(ParentID, PTop),
    bounding_box_right(ParentID, PRight),
    bounding_box_bottom(ParentID, PBottom),
    intersects(Left, Top, Right, Bottom, PLeft, PTop, PRight, PBottom).

intersects(PortLeft,_,_,PortBottom,ParentLeft, ParentTop, ParentRight, ParentBottom) :-
    PortLeft >= ParentLeft,
    PortLeft =< ParentRight,
    PortBottom =< ParentBottom,
    PortBottom >= ParentTop.

intersects(PortLeft,PortTop,_,_,ParentLeft, ParentTop, ParentRight, ParentBottom) :-
    PortLeft >= ParentLeft,
    PortLeft =< ParentRight,
    PortTop >= ParentTop,
    PortTop =< ParentBottom.

intersects(_,_,PortRight,PortBottom,ParentLeft, ParentTop, ParentRight, ParentBottom) :-
    PortRight >= ParentLeft,
    PortRight =< ParentRight,
    PortBottom >= ParentTop,
    PortBottom =< ParentBottom.

intersects(_,PortTop,PortRight,_,ParentLeft, ParentTop, ParentRight, ParentBottom) :-
    PortRight >= ParentLeft,
    PortRight =< ParentRight,
    PortTop >= ParentTop,
    PortTop =< ParentBottom.

:- include('tail').

