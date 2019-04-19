:- initialization(main).
:- include('head').

% yEd creates "nodes" and "edges
% by convention, "GenericNodes" represent boxes and other kinds of nodes are pins.
% in this pass, create a bounding box (left,top,right,bottom) for each "node" with geometry

main :-
    readFB(user_input), 
    createBoundingBoxes,
    writeFB,
    halt.

createBoundingBoxes :-
    forall(rect(ID,_), createRectBoundingBox(ID)),
    forall(text(ID,_), createTextBoundingBox(ID)).

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

    text(ID,Str),
    we(ID),wspc,wen(Str),
    we(ID),wspc,we(CX),wspc,we(Y),wspc,we(HalfWidth),wspc,wen(Height),
    we(ID),wspc,we(X),wspc,we(Y),wspc,we(Right),wspc,wen(Bottom),
    nle,

    asserta(bounding_box_right(ID,Right)),
    asserta(bounding_box_bottom(ID,Bottom)).

:- include('tail').
