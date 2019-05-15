
writeterm(Term) :- current_output(Out), write_term(Out, Term, []), write(Out, '.'), nl.


writeFB :-
    forall(arrow(X), writeterm(arrow(X))),
    forall(arrow_x(X,Y), writeterm(arrow_x(X,Y))),
    forall(arrow_y(X,Y), writeterm(arrow_y(X,Y))),
    forall(rect(X), writeterm(rect(X))),
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
    forall(portIndex(X,Y), writeterm(portIndex(X,Y))),
    forall(portIndexByID(X,Y), writeterm(portIndexByID(X,Y))),
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
    forall(selfInputPin(X,Y), writeterm(selfInputPin(X,Y))),
    forall(selfOutputPin(X,Y), writeterm(selfOutputPin(X,Y))),
    forall(wireIndex(X,Y), writeterm(wireIndex(X,Y))),
    forall(n_c(X), writeterm(n_c(X))),
    forall(indexedSink(X), writeterm(indexedSink(X))),
    forall(indexedSource(X), writeterm(indexedSource(X))),
    forall(parent(X,Y), writeterm(parent(X,Y))).

wspc :-
    write(user_error,' ').

nle :- nl(user_error).

we(X) :- write(user_error,X).

wen(X):- we(X),nle.


inc(Var, Value) :-
    g_read(Var, Value),
    X is Value+1,
    g_assign(Var, X).

boundingboxCompletelyInside(ID1,ID2) :-
    leftTopPointCompletelyInsideBoundingBox(ID1,ID2),
    topRightPointCompletelyInsideBoundingBox(ID1,ID2),
    rightBottomPointCompletelyInsideBoundingBox(ID1,ID2),
    bottomLeftPointCompletelyInsideBoundingBox(ID1,ID2).

leftTopPointCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),
    pointCompletelyInsideBoundingBox(L1,T1,ID2).

topRightPointCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_top(ID1,T1),
    bounding_box_right(ID1,R1),
    pointCompletelyInsideBoundingBox(R1,T1,ID2).

rightBottomPointCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_right(ID1,R1),
    bounding_box_bottom(ID1,B1),
    pointCompletelyInsideBoundingBox(R1,B1,ID2).

bottomLeftPointCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_bottom(ID1,B1),
    pointCompletelyInsideBoundingBox(L1,B1,ID2).

pointCompletelyInsideBoundingBox(X1,Y1,ID2) :-
    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2),

    X1 >= L2,
    R2 >= X1,
    Y1 >= T2,
    B2 >= Y1.

:-include(readFB1).
:-include(readFB2).
