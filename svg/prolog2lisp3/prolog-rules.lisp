(in-package :arrowgrams/parser)

(defparameter *all-prolog*
"
:- initialization(main).
:- include('head').

calc_bounds_main :-
    readFB(user_input), 
    createBoundingBoxes,
    writeFB,
    halt.

createBoundingBoxes :-
    conditionalCreateEllipseBB,
    condRect,
    condSpeech,
    condText.

condRect :-
    forall(rect(ID), createRectBoundingBox(ID)).

condSpeech :-
    forall(speechbubble(ID), createRectBoundingBox(ID)).

condText :-
    forall(text(ID,_), createTextBoundingBox(ID)).

conditionalCreateEllipseBB :-
    ellipse(_),
    forall(ellipse(ID), createEllipseBoundingBox(ID)).

createRectBoundingBox(ID) :-
    geometry_left_x(ID,X),
    geometry_top_y(ID, Y),
    geometry_w(ID, Width),
    geometry_h(ID, Height),
    asserta(bounding_box_left(ID,X)),
    asserta(bounding_box_top(ID,Y)),
    Right is X + Width,
    Bottom is Y + Height,
    asserta(bounding_box_right(ID,Right)),
    asserta(bounding_box_bottom(ID,Bottom)).

createTextBoundingBox(ID) :-
    geometry_center_x(ID,CX),
    geometry_top_y(ID, Y),
    geometry_w(ID, HalfWidth),
    geometry_h(ID, Height),
    X is CX - HalfWidth,
    asserta(bounding_box_left(ID,X)),
    asserta(bounding_box_top(ID,Y)),
    Right is CX + HalfWidth,
    Bottom is Y + Height,
    asserta(bounding_box_right(ID,Right)),
    asserta(bounding_box_bottom(ID,Bottom)).

createEllipseBoundingBox(ID) :-
    geometry_center_x(ID,CX),
    geometry_center_y(ID,CY),
    geometry_w(ID,HalfWidth),
    geometry_h(ID,HalfHeight),
    Left is CX - HalfWidth,
    Top is CY - HalfHeight,
    asserta(bounding_box_left(ID,Left)),
    asserta(bounding_box_top(ID,Top)),
    Right is CX + HalfWidth,
    Bottom is CY + HalfHeight,
    asserta(bounding_box_right(ID,Right)),
    asserta(bounding_box_bottom(ID,Bottom)).

:- include('tail').



:- initialization(main).
:- include('head').

assign_parents_to_ellispses_main :-
    readFB(user_input),
    forall(ellipse(EllipseID),makeParentForEllipse(EllipseID)),
    writeFB,
    halt.

makeParentForEllipse(EllipseID) :-
    component(Comp),
    asserta(parent(Comp,EllipseID)).

:- include('tail').

:- initialization(main).
:- include('head').

find_comments_main :-
    readFB(user_input), 
    condComment,
    writeFB,
    halt.

condComment :-
    forall(speechbubble(ID),createComments(ID)).

createComments(BubbleID) :-
    text(TextID,_),
    textCompletelyInsideBox(TextID,BubbleID),
    !,
    asserta(used(TextID)),
    asserta(comment(TextID)).

createComments(_) :-
    asserta(log('fATAL',commentFinderFailed)),
    true.

textCompletelyInsideBox(TextID,BubbleID) :-
    pointCompletelyInsideBoundingBox(TextID,BubbleID).

:- include('tail').

:- initialization(main).
:- include('head').

find_metadata_main :-
    readFB(user_input), 
    condMeta,
    writeFB,
    halt.

%%%%%%%
%
%% new
%
%%%%%%%

condMeta :-
    metadata(MID,TextID),
    rect(BoxID),
    metadataCompletelyInsideBoundingBox(TextID,BoxID),
!,
    asserta(used(TextID)),
    asserta(roundedrect(BoxID)),
    component(Main),
    asserta(parent(Main,BoxID)),
    asserta(log(BoxID,box_is_meta_data)),
    retract(rect(BoxID)),
fail.

% condMeta :-
%   forall(metadata(MID,_),createMetaDataRect(MID)).

createMetaDataRect(MID) :-
    metadata(MID,TextID),
    rect(BoxID),
    metadataCompletelyInsideBoundingBox(TextID,BoxID),
    asserta(used(TextID)),
    asserta(roundedrect(BoxID)),
    component(Main),
    asserta(parent(Main,BoxID)),
    asserta(log(BoxID,box_is_meta_data)),
    retract(rect(BoxID)).

createMetaDataRect(TextID) :-
    wen(' '),we('createMetaDataRect failed '),wen(TextID).

metadataCompletelyInsideBoundingBox(TextID,BoxID) :-
    centerCompletelyInsideBoundingBox(TextID,BoxID).

:- include('tail').

:- initialization(main).
:- include('head').

add_kinds_main :-
    readFB(user_input), 
    condDoKinds,
    writeFB,
    halt.

% pt
% condDoKinds :-
%     forall(eltype(ID,box),createAllKinds(ID)),
%     !. pt removed ! after forall

% old
% condDoKinds :- eltype(ID,box),createAllKinds(ID),fail.
% condDoKinds :- true.

%%%%%%%
%
%% new
%
%%%%%%%

condDoKinds :-
  eltype(BoxID,box),
  text(TextID,Str),
  not_used(TextID),
  textCompletelyInsideBox(TextID,BoxID),
  !,
  asserta(used(TextID)),
  asserta(kind(BoxID,Str)).

%%%%%%%
%
%% end new
%
%%%%%%%

% createAllKinds(BoxID) :-
%     forall(text(TextID,_),createOneKind(BoxID,TextID)).

createAllKinds(BoxID) :-
    text(TextID,_),
    createOneKind(BoxID,TextID),
    fail.
createAllKinds(_) :- true.

createOneKind(BoxID,TextID) :-
    text(TextID,Str),
    prolog_not_proven(used(TextID)),
    % \\+ used(TextID),
    textCompletelyInsideBox(TextID,BoxID),
    asserta(used(TextID)),
    asserta(kind(BoxID,Str)).

textCompletelyInsideBox(TextID,BoxID) :-
    pointCompletelyInsideBoundingBox(TextID,BoxID).

:- include('tail').

:- initialization(main).
:- include('head').

add_selfPorts_main :-
    readFB(user_input),
    condEllipses,
    writeFB,
    halt.

%%%%%%%
%
%% new
%
%%%%%%%

condEllipses :-
    ellipse(EllipseID),
    port(PortID),
    bounding_box_left(EllipseID,ELeftX),
    bounding_box_top(EllipseID,ETopY),
    bounding_box_right(EllipseID,ERightX),
    bounding_box_bottom(EllipseID,EBottomY),
    bounding_box_left(PortID,PortLeftX),
    bounding_box_top(PortID,PortTopY),
    bounding_box_right(PortID,PortRightX),
    bounding_box_bottom(PortID,PortBottomY),
    portTouchesEllipse(PortLeftX,PortTopY,PortRightX,PortBottomY,ELeftX,ETopY,ERightX,EBottomY),
    !,
    text(NameID,Name),
    textCompletelyInside(NameID,EllipseID),
    asserta(parent(EllipseID,PortID)),
    asserta(used(NameID)),
    asserta(portNameByID(PortID,NameID)),
    asserta(portName(PortID,Name)),
fail.

%%%%%%%
%
%% end new
%
%%%%%%%

% condEllipses :-
%    forall(ellipse(EllipseID),createSelfPorts(EllipseID)).

% createSelfPorts(EllipseID) :-
%     % find one port that touches the ellispe (if there are more, then the 'coincidentPorts'
%     % pass will find them), asserta all facts needed by ports downstream - portIndex, sink,
%     % source, parent
%     port(PortID),
%     bounding_box_left(EllipseID,ELeftX),
%     bounding_box_top(EllipseID,ETopY),
%     bounding_box_right(EllipseID,ERightX),
%     bounding_box_bottom(EllipseID,EBottomY),
%     bounding_box_left(PortID,PortLeftX),
%     bounding_box_top(PortID,PortTopY),
%     bounding_box_right(PortID,PortRightX),
%     bounding_box_bottom(PortID,PortBottomY),
%     portTouchesEllipse(PortLeftX,PortTopY,PortRightX,PortBottomY,ELeftX,ETopY,ERightX,EBottomY),
%     text(NameID,Name),
%     textCompletelyInside(NameID,EllipseID),
%     !,
%     asserta(parent(EllipseID,PortID)),
%     asserta(used(NameID)),
%     asserta(portNameByID(PortID,NameID)),
%     asserta(portName(PortID,Name)).

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

:- initialization(main).
:- include('head').

% make_unknown_port_names_main :-
%     readFB(user_input), 
%     forall(unused_text(TextID),createPortNameIfNotAKindName(TextID)),
%     writeFB,
%     halt.

%%%%%%%%%%%
%
% new
%
%%%%%%%%%%%

make_unknown_port_names_main :- text(TextID,_),not_used(TextID),asserta(unassigned(TextID)),fail.

%%%%%%%%%%%
%
% end new
%
%%%%%%%%%%%

unused_text(TextID) :-
    text(TextID,_),
    prolog_not_proven(used(TextID)).
    % \\+ used(TextID).

createPortNameIfNotAKindName(TextID) :-
    asserta(unassigned(TextID)).

:- include('tail').

:- initialization(main).
:- include('head').

% create_centers_main :-
%    readFB(user_input), 
%    forall(unassigned(TextID),createCenter(TextID)),
%    conditionalEllipseCenters,
%    forall(eltype(PortID,'port'),createCenter(PortID)),
%    writeFB,
%    halt.


%%%%%%%%%%%
%
% new
%
%%%%%%%%%%%

create_centers_main :-
  createTextCenters,
  createEllipseCenters,
  createPortCenters,
  fail.

createTextCenters :- unassigned(TextID),createCenter(TextID).

createEllipseCenters :- ellipse(EID),createCenter(EID).

createPortCenters :- eltype(PortID,port),createCenter(PortID).

%%%%%%%%%%%
%
% end new
%
%%%%%%%%%%%

conditionalEllipseCenters :-
    ellipse(_),
    forall(ellipse(ID),createCenter(ID)).

createCenter(ID) :-
    bounding_box_left(ID,Left),
    bounding_box_top(ID,Top),
    bounding_box_right(ID,Right),
    bounding_box_bottom(ID,Bottom),
    W is Right - Left,
    Temp is W / 2,
    X is Left + Temp,
    asserta(center_x(ID,X)),
    H is Bottom - Top,
    Temph is H / 2,
    Y is Top + Temph,
    asserta(center_y(ID,Y)).


:- include('tail').
:- initialization(main).
:- include('head').

% calculate_distances_main :-
%     readFB(user_input), 
%     g_assign(counter,0),
%     forall(eltype(PortID,'port'),makeAllCenterPairs(PortID)),
%     writeFB,
%     halt.

%%%%%%%
%
% new
%
%%%%%%%

calculate_distances_main :-
    g_assign(counter,0),
!,
    eltype(PortID,port),
    unassigned(TextID),
    g_read(counter,NewID),
    asserta(join_centerPair(PortID,NewID)),
    inc(counter,_),
    center_x(PortID,Px),
    center_y(PortID,Py),
    center_x(TextID,Tx),
    center_y(TextID,Ty),
    DX is Tx - Px,
    DY is Ty - Py,
    DXsq is DX * DX,
    DYsq is DY * DY,
    Sum is DXsq + DYsq,
    DISTANCE is sqrt(Sum),
    asserta(join_distance(NewID,TextID)),
    asserta(distance_xy(NewID,DISTANCE)),
fail.

%%%%%%%
%
% end new
%
%%%%%%%


makeAllCenterPairs(PortID) :-
    % each port gets one centerPair for each unused text item
    % each center pair contains the target text id and a distance from the given port
    % join_centerPair(Port,Pair)
    % join_distance(Pair,Text)
    % distance_xy(Pair,dx^2 + dy^2)
    forall(unassigned(TextID),makeCenterPair(PortID,TextID)).

old_makeCenterPair(PortID,TextID) :-
    makePairID(PortID,JoinPairID),
    center_x(PortID,Px),
    center_y(PortID,Py),
    center_x(TextID,Tx),
    center_y(TextID,Ty),
    DX is Tx - Px,
    DY is Ty - Py,
    DXsq is DX * DX,
    DYsq is DY * DY,
    Sum is DXsq + DYsq,
    DISTANCE is sqrt(Sum),
    asserta(join_distance(JoinPairID,TextID)),
    asserta(distance_xy(JoinPairID,DISTANCE)).

makePairID(PortID,NewID) :-
    g_read(counter,NewID),
    asserta(join_centerPair(PortID,NewID)),
    inc(counter,_).

:- include('tail').


% HISTORY: this used to work only with numeric indices
% cut over to use port names, not indices

:- initialization(main).
:- include('head').
%%%%%%%%%%%
%
% new
%
%%%%%%%%%%%

collect_unassigned_text(TextID,StrID) :- text(TextID,StrID), unassigned(TextID).

collect_port(PortID) :- port(PortID).

collect_joins(JoinID,TextID,PortID,Distance,StrID) :-   
  join_distance(JoinID,TextID),
  join_centerPair(PortID,JoinID),
  distance_xy(JoinID,Distance),
  text(TextID,StrID).

%%%%%%%%%%%
%
% end new
%
%%%%%%%%%%%

:- include('tail').

% markIndexedPorts_main :-
%     readFB(user_input), 
%     forall(portName(P,_),markNamed(P)),
%     writeFB,
%     halt.

%%%%%%%%%%%
%
% new
%
%%%%%%%%%%%

markIndexedPorts_main :-portName(P,_),markNamed(P),fail.

markNamed(P) :-
    sink(_,P),
!,
    asserta(namedSink(P)).

markNamed(P) :-
    source(_,P),
!,
    asserta(namedSource(P)).

%%%%%%%%%%%
%
% end new
%
%%%%%%%%%%%

% markNamed(P) :-
%     sink(_,P),
%     asserta(namedSink(P)).
% 
% markNamed(P) :-
%     source(_,P),
%     asserta(namedSource(P)).
% 
% markName(P) :-
%     we('port '),
%     we(P),
%     wen(' has no name!').

:- initialization(main).
:- include('head').
:- include('tail').

coincidentPorts_main :-
    readFB(user_input), 
    coincidentSinks,
    coincidentSources,
    writeFB,
    halt.


coincidentSinks:-
    forall(namedSink(X),findAllCoincidentSinks(X)).

findAllCoincidentSinks(A) :-
    forall(sink(_,B),findCoincidentSink(A,B)).

findCoincidentSink(A,B):-
    center_y(A,Ay),
    center_y(B,By),
    center_x(A,Ax),
    center_x(B,Bx),
    prolog_not_equal_equal(A,B),
    % A \\== B,
    sink(_,B),
    notNamedSink(B),
    closeTogether(Ax,Bx),
    closeTogether(Ay,By),
    portName(A,N),
    asserta(log(coincidentsink,A,B,N)),
    asserta(portName(B,N)).

notNamedSink(X) :-
    prolog_not_proven(namedSink(X)).
    % \\+ namedSink(X).


coincidentSources:-
    forall(namedSource(X),findAllCoincidentSources(X)).

findAllCoincidentSources(A) :-
    forall(source(_,B),findCoincidentSource(A,B)).

findCoincidentSource(A,B):-
    center_y(A,Ay),
    center_y(B,By),
    center_x(A,Ax),
    center_x(B,Bx),
    prolog_not_equal_equal(A,B),
    % A \\== B,
    source(_,B),
    notNamedSource(B),
    closeTogether(Ax,Bx),
    closeTogether(Ay,By),
    portName(A,N),
    asserta(log(coincidentsource,A,B,N)),
    asserta(portName(B,N)).

notNamedSource(X) :-
    namedSource(X),
    !,
    fail.

notNamedSource(X) :-
    true.



closeTogether(X,Y):-
    Delta is X - Y,
    Abs is abs(Delta),
    20 >= Abs.

closeTogether(_,_) :- 
    fail.


% The point of this pass is to find all sources and sinks attached to any edge
% a 'source' is a component pin that produces events (IPs) and a 'sink' is the destination
% for events.  We avoid the more obvious terms 'input' and 'output' because the terms are
% ambiguous in hierarchical components, e.g. an input pin on the outside of a hierarchial
% component looks like it 'outputs' events to any components contained within the hierarchical component.

% yEd creates edges with clearly delineated sources and sinks, hence, this pass is
% redundant for this particular application (using yEd); just read and re-emit all facts


:- initialization(main).
:- include('head').

mark_directions_main :-
    readFB(user_input),
    writeFB,
    halt.

:- include('tail').


:- initialization(main).
:- include('head').

match_ports_to_components_main :-
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
    parent(_,PortID),!.

assign_parent_for_port(PortID) :-
    ellipse(ParentID),
    portIntersection(PortID,ParentID),
    asserta(parent(ParentID,PortID)),!.

assign_parent_for_port(PortID) :-
    eltype(ParentID, box),
    portIntersection(PortID,ParentID),
    asserta(parent(ParentID,PortID)),!.

assign_parent_for_port(PortID) :-
    portName(PortID,_),
    asserta(log(PortID,'is_nc')),
    asserta(n_c(PortID)),
    !.

assign_parent_for_port(PortID) :-
    asserta(log(PortID,'is_nc')),
    asserta(n_c(PortID)),
    !.

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

:- initialization(main).
:- include('head').

pinless_main :-
    readFB(user_input),
    forall(eltype(ParentID, box), check_has_port(ParentID)),
    writeFB,
    halt.

check_has_port(ParentID):-
    parent(ParentID,PortID),
    port(PortID),
    !.

check_has_port(ParentID):-
    roundedrect(ParentID),
    asserta(pinless(ParentID)).

:- include('tail').

:- initialization(main).
:- include('head').

sem_partsHaveSomePorts_main :-
    readFB(user_input),
    forall(eltype(PartID, box), check_has_port(PartID)),
    writeFB,
    halt.

check_has_port(PartID):-
    parent(PartID,PortID),
    port(PortID),
    !.

check_has_port(PartID):-
    pinless(PartID),!.

check_has_port(PartID):-
    asserta(log(PartID,'error_part_has_no_port','partsHaveSomePorts')).

:- include('tail').

:- initialization(main).
:- include('head').

sem_portsHaveSinkOrSource_main :-
    readFB(user_input),
    forall(port(PortID),hasSinkOrSource(PortID)),
    writeFB,
    halt.

hasSinkOrSource(PortID):-
    sink(_,PortID),!.

hasSinkOrSource(PortID):-
    source(_,PortID),!.

hasSinkOrSource(PortID):-
    asserta(log('fATAL',port_isnt_marked_sink_or_source,PortID)),!.

:- include('tail').

:- initialization(main).
:- include('head').

sem_noDuplicateKinds_main :-
    readFB(user_input),
    forall(eltype(RectID, box), check_has_exactly_one_kind(RectID)),
    writeFB,
    halt.

check_has_exactly_one_kind(RectID) :-
    kind(RectID,Kind1),
    kind(RectID,Kind2),
    prolog_not_equal(Kind1,Kind2),
    % Kind1 \\= Kind2,
    !,
    asserta(log('fATAL_ERRORS_DURING_COMPILATION','noDuplicateKinds')),
    asserta(log('rect ', RectID)),
    asserta(log(Kind1)),
    asserta(log(Kind2)),
    nle,we('ERROR!!! '),we(RectID),we(' has more than one kind '),we(Kind1),wspc,wen(Kind2).

check_has_exactly_one_kind(RectID) :-
    kind(RectID,_),
    !.

check_has_exactly_one_kind(RectID) :-
    % not actually an error if the RectID belongs to metadata
    roundedrect(RectID),
    !.

check_has_exactly_one_kind(RectID) :-
    asserta(log(RectID,'has_no_kind','noDuplicateKinds')),
    !.

:- include('tail').

% check that each speechbubble is a comment

:- initialization(main).
:- include('head').

sem_speechVScomments_main :-
    readFB(user_input),
    g_assign(counter,0),
% pt
    forall(speechbubble(ID),inc(counter,_)),
% pt
    forall(comment(ID),dec(counter,_)),
    g_read(counter,Counter),
    checkZero(Counter),
    writeFB,
    halt.



checkZero(0) :- !.

checkZero(N) :-
    asserta(log('fATAL','speechCountCommentCount',N)).


:- include('tail').

:- initialization(main).
:- include('head').

assign_wire_numbers_to_edges_main :-
    g_assign(counter,0),
    readFB(user_input),
    forall(edge(EdgeID),assign_wire_number(EdgeID)),
    g_read(counter,N),
    asserta(nwires(N)),
    writeFB,
    halt.

assign_wire_number(EdgeID) :-
    g_read(counter,Old),
    asserta(wireNum(EdgeID,Old)),
    inc(counter,_).

:- include('tail').

:- initialization(main).
:- include('head').
:- include('port').

selfInputPins_main :-
    readFB(user_input),
    condSourceEllipse,
    writeFB,
    halt.

%condSourceEllipse :-
%    forall(ellipse(EllipseID),makeSelfInputPins(EllipseID)),
%!.

condSourceEllipse :-
    forall(ellipse(EllipseID),makeSelfInputPins(EllipseID)).

makeSelfInputPins(EllipseID) :-
    parent(Main,EllipseID),
    component(Main),
    portFor(EllipseID,PortID),
    source(_,PortID),
    asserta(selfInputPin(PortID)),!.  % self-input -> is a source (backwards from part inputs)

:- include('tail').

:- initialization(main).
:- include('head').
:- include('port').

selfOutputPins_main :-
    readFB(user_input),
    condSinkEllipse,
    writeFB,
    halt.

%condSinkEllipse :-
%    forall(ellipse(EllipseID),makeSelfOutputPins(EllipseID)),
%    !.

condSinkEllipse :-
    forall(ellipse(EllipseID),makeSelfOutputPins(EllipseID)).

makeSelfOutputPins(EllipseID) :-
    parent(Main,EllipseID),
    component(Main),
    portFor(EllipseID,PortID),
    sink(_,PortID),
    asserta(selfOutputPin(PortID)),!.  % self-output -> is a sink (backwards from part inputs)


:- include('tail').

:- initialization(main).
:- include('head').
:- include('port').

inputPins_main :-
    readFB(user_input),
    condSinkRect,
    writeFB,
    halt.

%condSinkRect :-
%    forall(rect(RectID),makeInputPins(RectID)),
%    !.

condSinkRect :-
    forall(rect(RectID),makeInputPins(RectID)).

makeInputPins(RectID) :-
    portFor(RectID,PortID),
    sink(_,PortID),
    asserta(inputPin(PortID)),!.

:- include('tail').

:- initialization(main).
:- include('head').
:- include('port').

outputPins_main :-
    readFB(user_input),
    condSourceRect,
    writeFB,
    halt.

%condSourceRect :-
%    forall(rect(RectID),makeOutputPins(RectID)),
%    !.

condSourceRect :-
    forall(rect(RectID),makeOutputPins(RectID)).

makeOutputPins(RectID) :-
    portFor(RectID,PortID),
    source(_,PortID),
    asserta(outputPin(PortID)),!.


:- include('tail').



%% pt
%% inc(Var, Value) :-
%%     g_read(Var, Value),
%%     X is Value+1,
%%     g_assign(Var, X).
%% 
%% dec(Var, Value) :-
%%     g_read(Var, Value),
%%     X is Value-1,
%%     g_assign(Var, X).

boundingboxCompletelyInside(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),
    bounding_box_right(ID1,R1),
    bounding_box_bottom(ID1,B1),

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2),

    L1 >= L2,
    T1 >= T2,
    R2 >= R1,
    B2 >= B1.

pointCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2),

    %we('point inside: L1/T1/L2/T2/R2/B2: '),we(L1),wspc,we(T1),wspc,we(L2),wspc,we(T2),wspc,we(R2),wspc,wen(B2),

    L1 >= L2,
    T1 >= T2,
    R2 >= L1,
    B2 >= T1.

centerCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),
    bounding_box_right(ID1,R1),
    bounding_box_bottom(ID1,B1),
    
%    Cx is L1 + R1 - L1,
%    Cy is T1 + B1 - T1,
    Temp1 is R1 - L1,
    Cx is L1 + Temp1,

    Temp2 is B1 - T1,
    Cy is T1 + Temp2,

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2),

    %% we('ccibb id1/center/id2 '),
    %% we(ID1), wspc,
    %% we(L1), wspc,
    %% we(T1), wspc,
    %% we(R1), wspc,
    %% we(B1), wspc,
    %% we(Cx), wspc,
    %% we(Cy), wspc,
    %% we(ID2), wspc,
    %% we(L2), wspc,
    %% we(T2), wspc,
    %% we(R2), wspc,
    %% wen(B2),

    Cx >= L2,
    Cx =< R2,
    Cy >= T2,
    Cy =< B2.

dumplog :-
    forall(log(X),dumplog(X)),
    forall(log(Z,Y),dumplog(Z,Y)),
    forall(log(A,B,C),dumplog(A,B,C)),
    forall(log(D,E,F,G),dumplog(D,E,F,G)),
    forall(log(H,I,J,K,L),dumplog(H,I,J,K,L)),
    forall(log(M,N,O,P,Q,R),dumplog(M,N,O,P,Q,R)),
    forall(log(M1,N1,O1,P1,Q1,R1,S1),dumplog(M1,N1,O1,P1,Q1,R1,S1)),
    forall(log(M2,N2,O2,P2,Q2,R2,S2,T2),dumplog(M2,N2,O2,P2,Q2,R2,S2,T2)),
    forall(log(L3,M3,N3,O3,P3,Q3,R3,S3,T3),dumplog(L3,M3,N3,O3,P3,Q3,R3,S3,T3)).

dumplog(W) :- wen(W).
dumplog(W,X) :- we(W),wspc,wen(X).
dumplog(W,X,Y) :- we(W),wspc,we(X),wspc,wen(Y).
dumplog(W,X,Y,Z) :- we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(V,W,X,Y,Z) :- we(V),wspc,we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(_,_,_,_,_) :- true.
dumplog(U,V,W,X,Y,Z) :- we(U),wspc,we(V),wspc,we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(_,_,_,_,_,_) :- true.
dumplog(T,U,V,W,X,Y,Z) :- we(T),wspc,we(U),wspc,we(V),wspc,we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(_,_,_,_,_,_,_) :- true.
dumplog(S,T,U,V,W,X,Y,Z) :- we(S),wspc,we(T),wspc,we(U),wspc,we(V),wspc,we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(_,_,_,_,_,_,_,_) :- true.
dumplog(R,S,T,U,V,W,X,Y,Z) :- we(R),wspc,we(S),wspc,we(T),wspc,we(U),wspc,we(V),wspc,we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(_,_,_,_,_,_,_,_,_) :- true.

wspc :-
    write(user_error,' ').

nle :- nl(user_error).

we(WE_ARG) :- write(user_error,WE_ARG).

wen(WEN_arg):- we(WEN_arg),nle.


portFor(RectOrEllipseID,PortID):-
    parent(RectOrEllipseID,PortID),
    port(PortID).



%
% manually defined
%

not_same(X,X) :- !, fail.
not_same(X,Y).

not_used(X) :- used(X),!,fail.
not_used(X).

not_namedSink(X) :- namedSink(X),!,fail.
not_namedSink(X).

")
