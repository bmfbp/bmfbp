:- initialization(main).
:- include('../common/head').


% this has been copied from ../pl_vsh for adding debugs

main :-
    readFB(user_input),
    match_ports,
    writeFB,
    halt.

match_ports :-
    % assign a parent component to every port, port must intersect parent's bounding-box
    % unimplemented semantic check: check that every port has exactly one parent
    forall(eltype(PortID,port),assign_parent_for_port(PortID)).

assign_parent_for_port(PortID) :-
    eltype(ParentID,'box'),
%% write(user_error,'Parent/Port '),write(user_error,ParentID),write(user_error,' '),
%% write(user_error,PortID),nl(user_error),
    bounding_box_left(PortID, Left),
    bounding_box_top(PortID, Top),
    bounding_box_right(PortID, Right),
    bounding_box_bottom(PortID, Bottom),
    bounding_box_left(ParentID, PLeft),
    bounding_box_top(ParentID, PTop),
    bounding_box_right(ParentID, PRight),
    bounding_box_bottom(ParentID, PBottom),
%% write(user_error,ParentID),write(user_error,' '),
%% write(user_error,PortID),write(user_error,' '),
%% write(user_error,PLeft),write(user_error,' '),
%% write(user_error,PTop),write(user_error,' '),
%% write(user_error,PRight),write(user_error,' '),
%% write(user_error,PBottom),write(user_error,' '),
%% write(user_error,Left),write(user_error,' '),
%% write(user_error,Top),write(user_error,' '),
%% write(user_error,Right),write(user_error,' '),
%% write(user_error,Bottom),write(user_error,' '),
%% nl(user_error),
%% write(user_error,'A'),nl(user_error),
    intersects(Left, Top, Right, Bottom, PLeft, PTop, PRight, PBottom),
%% write(user_error,'asserta(parent('),write(user_error,PortID),write(user_error,','),write(user_error,ParentID),write(user_error,')).'),nl(user_error),
    asserta(parent(PortID, ParentID)).

intersects(PortLeft, PortTop, PortRight, PortBottom, ParentLeft, ParentTop, ParentRight, ParentBottom) :-
    % true if child bounding box center intersect parent bounding box
    % bottom is >= top in this coord system
    % the code below only checks to see if all edges of the port are within the parent box
    % this should be tightened up to check that a port actually intersects one of the edges of the parent box
    PortLeft =< ParentRight,
    PortRight >= ParentLeft,
    PortTop =< ParentBottom,
    PortBottom >= ParentTop.

:- include('../common/tail').
