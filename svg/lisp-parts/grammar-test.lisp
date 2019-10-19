(in-package :prolog)

(defun test1 ()
  (init)
  (esrap:parse 'prolog::pCommaSeparatedListOfExpr "true , fail , ! , 123 , abc , ABC , [] , [A,B,C] , (A) , (A + B)"))

(defun test2 ()
  (init)
  (esrap:parse 'prolog::pCommaSeparatedListOfExpr "true , fail , ! , 123 , abc , ABC , [] , [A,B,C] , (A) , (A + B) , A + (B * C)"))

(defun test3 ()
  (init)
  (esrap:parse 'prolog::pCommaSeparatedListOfExpr "true , fail , ! , 123 , abc , ABC , [] , [A,B,C] , (A) , (A + B) , A + (B * C) - (D / F)"))

(defun test4 ()
  (init)
  (esrap:parse 'prolog::pProgram "test(def, true , fail , ! , 123 , abc , ABC , [] , [A,B,C] , (A) , (A + B) , A + (B * C) - (D / F) )."))

(defun test5 ()
  (init)
  (esrap:parse 'prolog::pProgram "rule1(A) :- test(A,def)."))

(defun test6 ()
  (init)
  (esrap:parse 'prolog::pProgram "rule1(A) :- test1(A,def) , test2(abc, A)."))

(defun test7 ()
  (init)
  (esrap:parse 'prolog::pProgram
               "
:- include('head').
:- initialization(main).
fact(1).
rule1(A) :- test1(A,def) , test2(abc, A).
"))

(defun test8 ()
  (init)
  (esrap:parse 'prolog::pProgram
               "
:- include('head').
:- initialization(main).
fact(1).
rule1(A) :- test1(A,def) , test2(abc, A).
rule2 :- test1(A,def) , test2(abc, A).
"))

(defun test9 ()
  (init)
  (esrap:parse 'prolog::pProgram "rule1(A) :- forall(rect(A),test2(abc, A))."))

(defun test10 ()
  (init)
  (esrap:parse 'prolog::pProgram "rule1(A) :- Right is X + Width."))               

(defun test11 ()
  (init)
  (esrap:parse 'prolog::pProgram "rule1(A) :- PortX =< ELeftX."))

(defun test-all ()
  (format *standard-output* "test1~%")
  (test1)
  (format *standard-output* "test2~%")
  (test2)
  (format *standard-output* "test3~%")
  (test3)
  (format *standard-output* "test4~%")
  (test4)
  (format *standard-output* "test5~%")
  (test5)
  (format *standard-output* "test6~%")
  (test6)
  (format *standard-output* "test7~%")
  (test7)
  (format *standard-output* "test8~%")
  (test8)
  (format *standard-output* "test9~%")
  (test9)
  (format *standard-output* "test10~%")
  (test10)
  (format *standard-output* "test11~%")
  (test11)
  (format *standard-output* "done~%")
)

(defun test13 ()
  ;; NB - escape all backslashes!!! i.e. \ becomes \\
  ;; NB - remove all double-quotes
  (pprint (esrap:parse 'prolog::pProgram
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

main :-
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

marIndexedPorts_main :-
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
    forall(ellipse(EllipseID),makeSelfInputPins(EllipseID)),!.

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


writeterm(Term) :- current_output(Out), write_term(Out, Term, []), write(Out, '.'), nl.


writeFB :-
    forall(arrow(X), writeterm(arrow(X))),
    forall(arrow_x(X,Y), writeterm(arrow_x(X,Y))),
    forall(arrow_y(X,Y), writeterm(arrow_y(X,Y))),
    forall(rect(X), writeterm(rect(X))),
    forall(roundedrect(X), writeterm(roundedrect(X))),
    forall(pinless(X), writeterm(pinless(X))),
    forall(comment(X), writeterm(comment(X))),
    forall(speechbubble(X), writeterm(speechbubble(X))),
    forall(metadata(X,Y), writeterm(metadata(X,Y))),
    forall(ellipse(X), writeterm(ellipse(X))),
    forall(dot(X), writeterm(dot(X))),
    forall(line(X), writeterm(line(X))), 
    forall(line_begin_x(X,Y), writeterm(line_begin_x(X,Y))), 
    forall(line_begin_y(X,Y), writeterm(line_begin_y(X,Y))), 
    forall(line_end_x(X,Y), writeterm(line_end_x(X,Y))), 
    forall(line_end_y(X,Y), writeterm(line_end_y(X,Y))), 
    forall(stroke_absolute_x(X,Y), writeterm(stroke_absolute_x(X,Y))), 
    forall(stroke_absolute_y(X,Y), writeterm(stroke_absolute_y(X,Y))),
    forall(stroke_relative_x(X,Y), writeterm(stroke_relative_x(X,Y))),
    forall(stroke_relative_y(X,Y), writeterm(stroke_relative_y(X,Y))),
    forall(text(X,Y), writeterm(text(X,Y))),
    forall(text_x(X,Y), writeterm(text_x(X,Y))),
    forall(text_y(X,Y), writeterm(text_y(X,Y))),
    forall(text_w(X,Y), writeterm(text_w(X,Y))),
    forall(text_h(X,Y), writeterm(text_h(X,Y))),

    forall(join_centerPair(X,Y), writeterm(join_centerPair(X,Y))),
    forall(join_distance(X,Y), writeterm(join_distance(X,Y))),
    forall(distance_xy(X,Y), writeterm(distance_xy(X,Y))),

    forall(bounding_box_left(X,Y), writeterm(bounding_box_left(X,Y))),
    forall(bounding_box_top(X,Y), writeterm(bounding_box_top(X,Y))),
    forall(bounding_box_right(X,Y), writeterm(bounding_box_right(X,Y))),
    forall(bounding_box_bottom(X,Y), writeterm(bounding_box_bottom(X,Y))),
    forall(center_x(X,Y), writeterm(center_x(X,Y))),
    forall(center_y(X,Y), writeterm(center_y(X,Y))),
    forall(component(X), writeterm(component(X))),
    forall(edge(X), writeterm(edge(X))),
    forall(eltype(X,Y), writeterm(eltype(X,Y))),
    forall(geometry_h(X,Y), writeterm(geometry_h(X,Y))),
    forall(geometry_w(X,Y), writeterm(geometry_w(X,Y))),
    forall(geometry_left_x(X,Y), writeterm(geometry_left_x(X,Y))),
    forall(geometry_top_y(X,Y), writeterm(geometry_top_y(X,Y))),
    forall(geometry_center_x(X,Y), writeterm(geometry_center_x(X,Y))),
    forall(geometry_center_y(X,Y), writeterm(geometry_center_y(X,Y))),
    forall(used(X), writeterm(used(X))),
    forall(kind(X,Y), writeterm(kind(X,Y))),
    forall(selfPort(X,Y), writeterm(selfPort(X,Y))),
    forall(port(X), writeterm(port(X))),
    forall(portName(X,Y), writeterm(portName(X,Y))),
    forall(portNameByID(X,Y), writeterm(portNameByID(X,Y))),
    forall(unassigned(X), writeterm(unassigned(X))),
    forall(source(X,Y), writeterm(source(X,Y))),
    forall(sink(X,Y), writeterm(sink(X,Y))),
    forall(npipes(X), writeterm(npipes(X))),
    forall(pipeNum(X,Y), writeterm(pipeNum(X,Y))),

    forall(nwires(X), writeterm(nwires(X))),
    forall(wireNum(X,Y), writeterm(wireNum(X,Y))),

    forall(sourcefd(X,Y), writeterm(sourcefd(X,Y))),
    forall(sinkfd(X,Y), writeterm(sinkfd(X,Y))),
    forall(inputPin(X,Y), writeterm(inputPin(X,Y))),
    forall(outputPin(X,Y), writeterm(outputPin(X,Y))),
    forall(selfInputPin(X), writeterm(selfInputPin(X))),
    forall(selfOutputPin(X), writeterm(selfOutputPin(X))),
    forall(wireIndex(X,Y), writeterm(wireIndex(X,Y))),
    forall(n_c(X), writeterm(n_c(X))),
    forall(namedSink(X), writeterm(namedSink(X))),
    forall(namedSource(X), writeterm(namedSource(X))),
    forall(parent(X,Y), writeterm(parent(X,Y))),
    writelog.

writelog :-
    forall(log(X),writelog(X)),
    forall(log(Z,Y),writelog(Z,Y)),
    forall(log(A,B,C),writelog(A,B,C)),
    forall(log(D,E,F,G),writelog(D,E,F,G)),
    forall(log(H,I,J,K,L),writelog(H,I,J,K,L)),
    forall(log(M,N,O,P,Q,R),writelog(M,N,O,P,Q,R)),
    forall(log(S,T,U,V,W,X,Y),writelog(S,T,U,V,W,X,Y)),
    forall(log(R,S,T,U,V,W,X,Y),writelog(R,S,T,U,V,W,X,Y)),
    forall(log(R,S,T,U,V,W,X,Y,Z),writelog(R,S,T,U,V,W,X,Y,Z)).

writelog(X) :- writeterm(log(X)).
writelog(Y,Z) :-writeterm(log(Y,Z)).
writelog(X,Y,Z) :-writeterm(log(X,Y,Z)).
writelog(W,X,Y,Z) :-writeterm(log(W,X,Y,Z)).
writelog(A,B,C,D,E) :-writeterm(log(A,B,C,D,E)).
writelog(A,B,C,D,E,F) :-writeterm(log(A,B,C,D,E,F)).
writelog(A,B,C,D,E,F,G) :-writeterm(log(A,B,C,D,E,F,G)).
writelog(A,B,C,D,E,F,G,H) :-writeterm(log(A,B,C,D,E,F,G,H)).
writelog(A,B,C,D,E,F,G,H,I) :-writeterm(log(A,B,C,D,E,F,G,H,I)).


wspc :-
    write(user_error,' ').

nle :- nl(user_error).

we(X) :- write(user_error,X).

wen(X):- we(X),nle.

#readFB(Str) :-
#    read_term(Str,T0,[]),
#    element(T0,Str).

element(end_of_file, _) :- !.
element(eltype(X,Y), Str) :- !,
			   asserta(eltype(X,Y)),
		       readFB(Str).
element(port(X), Str) :- !,
			   asserta(port(X)),
		       readFB(Str).
element(portName(X,Y), Str) :- !,
			   asserta(portName(X,Y)),
		       readFB(Str).
element(portNameByID(X,Y), Str) :- !,
			   asserta(portNameByID(X,Y)),
		       readFB(Str).
element(unassigned(X), Str) :- !,
			   asserta(unassigned(X)),
		       readFB(Str).
element(kind(X,Y), Str) :- !,
			   asserta(kind(X,Y)),
		       readFB(Str).
element(geometry_left_x(X,Y), Str) :- !,
			   asserta(geometry_left_x(X,Y)),
		       readFB(Str).
element(selfPort(X,Y), Str) :- !,
			   asserta(selfPort(X,Y)),
		       readFB(Str).
element(geometry_top_y(X,Y), Str) :- !,
			   asserta(geometry_top_y(X,Y)),
		       readFB(Str).
element(geometry_center_x(X,Y), Str) :- !,
			   asserta(geometry_center_x(X,Y)),
		       readFB(Str).
element(geometry_center_y(X,Y), Str) :- !,
			   asserta(geometry_center_y(X,Y)),
		       readFB(Str).
element(geometry_w(X,Y), Str) :- !,
			   asserta(geometry_w(X,Y)),
		       readFB(Str).
element(geometry_h(X,Y), Str) :- !,
			   asserta(geometry_h(X,Y)),
		       readFB(Str).
element(used(X), Str) :- !,
			   asserta(used(X)),
		       readFB(Str).
element(component(X), Str) :- !,
			   asserta(component(X)),
		       readFB(Str).
element(edge(X), Str) :- !,
			   asserta(edge(X)),
		       readFB(Str).
element(source(X,Y), Str) :- !,
			   asserta(source(X,Y)),
		       readFB(Str).
element(sink(X,Y), Str) :- !,
			   asserta(sink(X,Y)),
		       readFB(Str).

element(geometry_left_x(X,Y), Str) :- !,
				 asserta(geometry_left_x(X,Y)),
				 readFB(Str).

element(geometry_top_y(X,Y), Str) :- !,
				 asserta(geometry_top_y(X,Y)),
				 readFB(Str).

element(geometry_center_x(X,Y), Str) :- !,
				 asserta(geometry_center_x(X,Y)),
				 readFB(Str).

element(geometry_center_y(X,Y), Str) :- !,
				 asserta(geometry_center_y(X,Y)),
				 readFB(Str).

element(geometry_w(X,Y), Str) :- !,
				 asserta(geometry_w(X,Y)),
				 readFB(Str).

element(geometry_y(X,Y), Str) :- !,
				 asserta(geometry_h(X,Y)),
				 readFB(Str).

element(bounding_box_left(X,Y), Str) :- !,
				 asserta(bounding_box_left(X,Y)),
				 readFB(Str).

element(bounding_box_top(X,Y), Str) :- !,
				 asserta(bounding_box_top(X,Y)),
				 readFB(Str).

element(bounding_box_right(X,Y), Str) :- !,
				 asserta(bounding_box_right(X,Y)),
				 readFB(Str).

element(bounding_box_bottom(X,Y), Str) :- !,
				 asserta(bounding_box_bottom(X,Y)),
				 readFB(Str).

element(center_x(X,Y), Str) :- !,
				 asserta(center_x(X,Y)),
				 readFB(Str).

element(center_y(X,Y), Str) :- !,
				 asserta(center_y(X,Y)),
				 readFB(Str).

element(parent(X,Y), Str) :- !,
			     asserta(parent(X,Y)),
			     readFB(Str).

element(wireIndex(X,Y), Str) :- !,
			     asserta(wireIndex(X,Y)),
			     readFB(Str).

element(inputPin(X,Y), Str) :- !,
			     asserta(inputPin(X,Y)),
			     readFB(Str).

element(outputPin(X,Y), Str) :- !,
			     asserta(outputPin(X,Y)),
			     readFB(Str).

element(selfInputPin(X,Y), Str) :- !,
			     asserta(selfInputPin(X,Y)),
			     readFB(Str).

element(selfOutputPin(X,Y), Str) :- !,
			     asserta(selfOutputPin(X,Y)),
			     readFB(Str).


element(selfInputPin(X), Str) :- !,
			     asserta(selfInputPin(X)),
			     readFB(Str).

element(selfOutputPin(X), Str) :- !,
			     asserta(selfOutputPin(X)),
			     readFB(Str).






element(line(X), Str) :- !,
			     asserta(line(X)),
			     readFB(Str).

element(line_begin_x(X,Y), Str) :- !,
			     asserta(line_begin_x(X,Y)),
			     readFB(Str).

element(line_begin_y(X,Y), Str) :- !,
			     asserta(line_begin_y(X,Y)),
			     readFB(Str).

element(line_end_x(X,Y), Str) :- !,
			     asserta(line_end_x(X,Y)),
			     readFB(Str).

element(line_end_y(X,Y), Str) :- !,
			     asserta(line_end_y(X,Y)),
			     readFB(Str).

element(pipeNum(X,Y), Str) :- !,
			     asserta(pipeNum(X,Y)),
			     readFB(Str).

element(wireNum(X,Y), Str) :- !,
			     asserta(wireNum(X,Y)),
			     readFB(Str).

element(arrow(X), Str) :- !,
			     asserta(arrow(X)),
			     readFB(Str).

element(arrow_x(X,Y), Str) :- !,
			     asserta(arrow_x(X,Y)),
			     readFB(Str).

element(arrow_y(X,Y), Str) :- !,
			     asserta(arrow_y(X,Y)),
			     readFB(Str).

element(sinkfd(P,F), Str) :- !,
			     asserta(sinkfd(P,F)),
			     readFB(Str).

element(sourcefd(P,F), Str) :- !,
			     asserta(sourcefd(P,F)),
			     readFB(Str).

element(source(P,F), Str) :- !,
			     asserta(source(P,F)),
			     readFB(Str).

element(npipes(X), Str) :- !,
			     asserta(npipes(X)),
			     readFB(Str).

element(nwires(X), Str) :- !,
			     asserta(nwires(X)),
			     readFB(Str).

element(move_absolute_x(X,Y), Str) :- !,
			     asserta(move_absolute_x(X,Y)),
			     readFB(Str).


element(move_absolute_y(X,Y), Str) :- !,
			     asserta(move_absolute_y(X,Y)),
			     readFB(Str).


element(move_relative_x(X,Y), Str) :- !,
			     asserta(move_relative_x(X,Y)),
			     readFB(Str).

element(move_relative_y(X,Y), Str) :- !,
			     asserta(move_relative_y(X,Y)),
			     readFB(Str).


element(rect(X), Str) :- !,
			     asserta(rect(X)),
			     readFB(Str).
element(roundedrect(X), Str) :- !,
			     asserta(roundedrect(X)),
			     readFB(Str).
element(pinless(X), Str) :- !,
			     asserta(pinless(X)),
			     readFB(Str).
element(speechbubble(X), Str) :- !,
			     asserta(speechbubble(X)),
			     readFB(Str).
element(comment(X), Str) :- !,
			     asserta(comment(X)),
			     readFB(Str).
element(metadata(X,Y), Str) :- !,
			     asserta(metadata(X,Y)),
			     readFB(Str).

element(ellipse(X), Str) :- !,
			     asserta(ellipse(X)),
			     readFB(Str).

element(dot(X), Str) :- !,
			     asserta(dot(X)),
			     readFB(Str).

element(stroke_relative_x(X,Y), Str) :- !,
			     asserta(stroke_relative_x(X,Y)),
			     readFB(Str).

element(stroke_relative_y(X,Y), Str) :- !,
			     asserta(stroke_relative_y(X,Y)),
			     readFB(Str).


element(stroke_absolute_x(X,Y), Str) :- !,
			     asserta(stroke_absolute_x(X,Y)),
			     readFB(Str).

element(stroke_absolute_y(X,Y), Str) :- !,
			     asserta(stroke_absolute_y(X,Y)),
			     readFB(Str).

element(text(X,Y), Str) :- !,
			     asserta(text(X,Y)),
			     readFB(Str).

element(text_x(X,Y), Str) :- !,
			     asserta(text_x(X,Y)),
			     readFB(Str).

element(text_y(X,Y), Str) :- !,
			     asserta(text_y(X,Y)),
			     readFB(Str).

element(text_w(X,Y), Str) :- !,
			     asserta(text_w(X,Y)),
			     readFB(Str).

element(text_h(X,Y), Str) :- !,
			     asserta(text_h(X,Y)),
			     readFB(Str).

element(join_centerPair(X,Y), Str) :- !,
			     asserta(join_centerPair(X,Y)),
			     readFB(Str).

element(join_distance(X,Y), Str) :- !,
			     asserta(join_distance(X,Y)),
			     readFB(Str).

element(distance_xy(X,Y), Str) :- !,
			     asserta(distance_xy(X,Y)),
			     readFB(Str).



element(centerPair(X,Y), Str) :- !,
			     asserta(centerPair(X,Y)),
			     readFB(Str).
element(distance(X,Y), Str) :- !,
			     asserta(distance(X,Y)),
			     readFB(Str).

element(n_c(X), Str) :- !,
			     asserta(n_c(X)),
			     readFB(Str).

element(namedSink(X), Str) :- !,
			     asserta(namedSink(X)),
			     readFB(Str).

element(namedSource(X), Str) :- !,
			     asserta(namedSource(X)),
			     readFB(Str).

element(log(W), Str) :- !,
			     asserta(log(W)),
			     readFB(Str).

element(log(W,X), Str) :- !,
			     asserta(log(W,X)),
			     readFB(Str).

element(log(W,X,Y), Str) :- !,
			     asserta(log(W,X,Y)),
			     readFB(Str).

element(log(W,X,Y,Z), Str) :- !,
			     asserta(log(W,X,Y,Z)),
			     readFB(Str).

element(log(A,W,X,Y,Z), Str) :- !,
			     asserta(log(A,W,X,Y,Z)),
			     readFB(Str).

element(log(A,B,W,X,Y,Z), Str) :- !,
			     asserta(log(A,B,W,X,Y,Z)),
			     readFB(Str).

element(log(A,B,C,W,X,Y,Z), Str) :- !,
			     asserta(log(A,B,C,W,X,Y,Z)),
			     readFB(Str).

element(log(A,B,C,D,W,X,Y,Z), Str) :- !,
			     asserta(log(A,B,C,D,W,X,Y,Z)),
			     readFB(Str).

element(log(A,B,C,D,E,W,X,Y,Z), Str) :- !,
			     asserta(log(A,B,C,D,E,W,X,Y,Z)),
			     readFB(Str).


    
element(Term, _) :-
    write(user_error,'failed read '),
    write(user_error,Term),
    nl(user_error).
    % type_error(element, Term).

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
")))


