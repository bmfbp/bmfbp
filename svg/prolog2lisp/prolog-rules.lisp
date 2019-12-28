(in-package :arrowgrams/prolog-peg)

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
condRect :-
    true.

condSpeech :-
    forall(speechbubble(ID), createRectBoundingBox(ID)).
condSpeech :-
    true.

condText :-
    forall(text(ID,_), createTextBoundingBox(ID)).
condText :-
    true.

conditionalCreateEllipseBB :-
    ellipse(_),
    forall(ellipse(ID), createEllipseBoundingBox(ID)).

conditionalCreateEllipseBB :- % for pre-ellipse code  
    true.

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
    X is (CX - HalfWidth),
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

condMeta :-
    forall(metadata(MID,_),createMetaDataRect(MID)).

condMeta :-
    true.

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

condDoKinds :-
    forall(eltype(ID,box),createAllKinds(ID)),
    !.

condDoKinds :- true.

createAllKinds(BoxID) :-
    forall(text(TextID,_),createOneKind(BoxID,TextID)).

createOneKind(BoxID,TextID) :-
    text(TextID,Str),
    \\+ used(TextID),
    textCompletelyInsideBox(TextID,BoxID),
    asserta(used(TextID)),
    asserta(kind(BoxID,Str)).

createOneKind(_,_) :-
    true.

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

condEllipses :-
    forall(ellipse(EllipseID),createSelfPorts(EllipseID)).

condEllipses :-
    true.

createSelfPorts(EllipseID) :-
    % find one port that touches the ellispe (if there are more, then the 'coincidentPorts'
    % pass will find them), asserta all facts needed by ports downstream - portIndex, sink,
    % source, parent
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
    text(NameID,Name),
    textCompletelyInside(NameID,EllipseID),
    !,
    asserta(parent(EllipseID,PortID)),
    asserta(used(NameID)),
    asserta(portNameByID(PortID,NameID)),
    asserta(portName(PortID,Name)).

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

make_unknown_port_names_main :-
    readFB(user_input), 
    forall(unused_text(TextID),createPortNameIfNotAKindName(TextID)),
    writeFB,
    halt.

unused_text(TextID) :-
    text(TextID,_),
    \\+ used(TextID).

createPortNameIfNotAKindName(TextID) :-
    asserta(unassigned(TextID)).

:- include('tail').

:- initialization(main).
:- include('head').

create_centers_main :-
    readFB(user_input), 
    forall(unassigned(TextID),createCenter(TextID)),
    conditionalEllipseCenters,
    forall(eltype(PortID,'port'),createCenter(PortID)),
    writeFB,
    halt.

conditionalEllipseCenters :-
    ellipse(_),
    forall(ellipse(ID),createCenter(ID)).

conditionalEllipseCenters:-
    true.

createCenter(ID) :-
    bounding_box_left(ID,Left),
    bounding_box_top(ID,Top),
    bounding_box_right(ID,Right),
    bounding_box_bottom(ID,Bottom),
    W is Right - Left,
    W is W / 2,
    X is Left + W,
    asserta(center_x(ID,X)),
    H is Bottom - Top,
    H is H / 2,
    Y is Top + H,
    asserta(center_y(ID,Y)).


:- include('tail').
:- initialization(main).
:- include('head').

calculate_distances_main :-
    readFB(user_input), 
    g_assign(counter,0),
    forall(eltype(PortID,'port'),makeAllCenterPairs(PortID)),
    writeFB,
    halt.

makeAllCenterPairs(PortID) :-
    % each port gets one centerPair for each unused text item
    % each center pair contains the target text id and a distance from the given port
    % join_centerPair(Port,Pair)
    % join_distance(Pair,Text)
    % distance_xy(Pair,dx^2 + dy^2)
    forall(unassigned(TextID),makeCenterPair(PortID,TextID)).

makeCenterPair(PortID,TextID) :-
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

:- initialization(main).
:- include('head').

assign_portnames_main :-
    readFB(user_input), 
    assignUnassignedTextToPorts,
    writeFB,
    halt.

assignUnassignedTextToPorts :-
    forall(unassigned(TextID),assignPort(TextID)).

assignPort(TextID):-
    minimumDistanceToAPort(TextID,PortID),
    text(TextID,Str),
    asserta(portNameByID(PortID,TextID)),
    asserta(portName(PortID,Str)).

minimumDistanceToAPort(TextID,PortID) :-
    unassigned(TextID),  %% redundant (since the caller asserts this)
    findAllDistancesToPortsFromGivenUnassignedText(TextID,DistancePortIDList),
    splitLists(DistancePortIDList,Distances,PortIDs),
    findMinimumDistanceInList(Distances,Min),
    findPositionOfMinimumInList(Min,Distances,Name),
    findPortWithName(Name,PortIDs,PortID).

findAllDistancesToPortsFromGivenUnassignedText(TextID,DistancePortIDPairList):-
    findall(DistancePortIDPair,findOneDistanceToAPortFromGivenUnassignedText(TextID,DistancePortIDPair),DistancePortIDPairList).

findOneDistanceToAPortFromGivenUnassignedText(TextID,DistancePortIDPair):-
    join_distance(CPID,TextID),
    distance_xy(CPID,Distance),
    join_centerPair(PortID,CPID),
    DistancePortIDPair = [Distance, PortID].


findMinimumDistanceInList(Distances,Min):-
    min_list(Distances,Min).

findPositionOfMinimumInList(Min,List,Position):-
    nth(Position,List,Min).

findPortWithName(Position,Ports,PortID):-
    nth(Position,Ports,PortID).


splitLists([],[],[]).
splitLists([[N1,ID1]|Tail],Ns,IDs):-
    splitLists(Tail,Nlist,IDlist),
    append([N1],Nlist,Ns),
    append([ID1],IDlist,IDs).


:- include('tail').

% HISTORY: this used to work only with numeric indices
% cut over to use port names, not indices

:- initialization(main).
:- include('head').
:- include('tail').

markIndexedPorts_main :-
    readFB(user_input), 
    forall(portName(P,_),markNamed(P)),
    writeFB,
    halt.

markNamed(P) :-
    sink(_,P),
    asserta(namedSink(P)).

markNamed(P) :-
    source(_,P),
    asserta(namedSource(P)).

markName(P) :-
    we('port '),
    we(P),
    wen(' has no name!').

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
    A \\== B,
    sink(_,B),
    notNamedSink(B),
    closeTogether(Ax,Bx),
    closeTogether(Ay,By),
    portName(A,N),
    asserta(log(coincidentsink,A,B,N)),
    asserta(portName(B,N)).

findCoincidentSink(_,_):-
    true.

notNamedSink(X) :-
    \\+ namedSink(X).


coincidentSources:-
    forall(namedSource(X),findAllCoincidentSources(X)).

findAllCoincidentSources(A) :-
    forall(source(_,B),findCoincidentSource(A,B)).

findCoincidentSource(A,B):-
    center_y(A,Ay),
    center_y(B,By),
    center_x(A,Ax),
    center_x(B,Bx),
    A \\== B,
    source(_,B),
    notNamedSource(B),
    closeTogether(Ax,Bx),
    closeTogether(Ay,By),
    portName(A,N),
    asserta(log(coincidentsource,A,B,N)),
    asserta(portName(B,N)).

findCoincidentSource(_,_):-
    true.

notNamedSource(X) :-
    \\+ namedSource(X).



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
    Kind1 \\= Kind2,
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
    forall(speechbubble(ID),xinc(ID)),
    forall(comment(ID),xdec(ID)),
    g_read(counter,Counter),
    checkZero(Counter),
    writeFB,
    halt.

xinc(_) :- inc(counter,_).
xdec(_) :- dec(counter,_).


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

condSourceEllipse :-
    forall(ellipse(EllipseID),makeSelfInputPins(EllipseID)),
!.

condSourceEllispe :- true.

makeSelfInputPins(EllipseID) :-
    parent(Main,EllipseID),
    component(Main),
    portFor(EllipseID,PortID),
    source(_,PortID),
    asserta(selfInputPin(PortID)),!.  % self-input -> is a source (backwards from part inputs)

makeSelfInputPins(_) :-
    true.

:- include('tail').

:- initialization(main).
:- include('head').
:- include('port').

selfOutputPins_main :-
    readFB(user_input),
    condSinkEllipse,
    writeFB,
    halt.

condSinkEllipse :-
    forall(ellipse(EllipseID),makeSelfOutputPins(EllipseID)),
    !.
condSourceEllipse :- true.

makeSelfOutputPins(EllipseID) :-
    parent(Main,EllipseID),
    component(Main),
    portFor(EllipseID,PortID),
    sink(_,PortID),
    asserta(selfOutputPin(PortID)),!.  % self-output -> is a sink (backwards from part inputs)

makeSelfOutputPins(_) :-
    true.

:- include('tail').

:- initialization(main).
:- include('head').
:- include('port').

inputPins_main :-
    readFB(user_input),
    condSinkRect,
    writeFB,
    halt.

condSinkRect :-
    forall(rect(RectID),makeInputPins(RectID)),
    !.
condSinkRect :- true.

makeInputPins(RectID) :-
    portFor(RectID,PortID),
    sink(_,PortID),
    asserta(inputPin(PortID)),!.

makeInputPins(_) :-
    true.

:- include('tail').

:- initialization(main).
:- include('head').
:- include('port').

outputPins_main :-
    readFB(user_input),
    condSourceRect,
    writeFB,
    halt.

condSourceRect :-
    forall(rect(RectID),makeOutputPins(RectID)),
    !.
condSourceRect :- true.

makeOutputPins(RectID) :-
    portFor(RectID,PortID),
    source(_,PortID),
    asserta(outputPin(PortID)),!.

makeOutputPins(_) :-
    true.

:- include('tail').




inc(Var, Value) :-
    g_read(Var, Value),
    X is Value+1,
    g_assign(Var, X).

dec(Var, Value) :-
    g_read(Var, Value),
    X is Value-1,
    g_assign(Var, X).

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
    
    Cx is L1 + (R1 - L1),
    Cy is T1 + (B1 - T1),

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

")