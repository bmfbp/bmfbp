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
    portName(PortID,Text),
    asserta(log(nc,PortID)),
    asserta(n_c(PortID)),
    nle,nle,we('no parent box for port '),we(PortID),we(' named '),we(Text),nle,nle,nle.

assign_parent_for_port(PortID) :-
    asserta(log(nc,PortID)),
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

intersects(PortLeft, PortTop, PortRight, PortBottom, ParentLeft, ParentTop, ParentRight, ParentBottom) :-
    % true if child bounding box center intersect parent bounding box
    % bottom is >= top in this coord system
    % the code below only checks to see if all edges of the port are within the parent box
    % this should be tightened up to check that a port actually intersects one of the edges of the parent box
    PortLeft =< ParentRight,
    PortRight >= ParentLeft,
    PortTop =< ParentBottom,
    PortBottom >= ParentTop.

:- include('tail').

