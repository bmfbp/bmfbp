:- initialization(main).
:- include(head).

% yEd creates "nodes" and "edges
% by convention, "GenericNodes" represent boxes and other kinds of nodes are pins.
% in this pass, create a bounding box (left,top,right,bottom) for each "node" with geometry

main :-
    readFB(user_input),
    createBoundingBoxes,
    writeFB,
    halt.

createBoundingBoxes :-
    forall(geometry_x(ID, X), createBoundingBox(ID, X)).

createBoundingBox(ID, X) :-
    geometry_y(ID, Y),
    geometry_w(ID, Width),
    geometry_h(ID, Height),
    asserta(bounding_box_left(ID,X)),
    asserta(bounding_box_top(ID,Y)),
    Right is X + Width,
    Bottom is Y + Height,
    asserta(bounding_box_right(ID,Right)),
    asserta(bounding_box_bottom(ID,Bottom)).


:- include(tail).
