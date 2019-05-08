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
    leftTopPointCompletelyInsideBoundingBox(PortID,ParentID).

portIntersection(PortID,ParentID):-
    topRightPointCompletelyInsideBoundingBox(PortID,ParentID).

portIntersection(PortID,ParentID):-
    rightBottomPointCompletelyInsideBoundingBox(PortID,ParentID).

portIntersection(PortID,ParentID):-
    bottomLeftPointCompletelyInsideBoundingBox(PortID,ParentID).


:- include('tail').

