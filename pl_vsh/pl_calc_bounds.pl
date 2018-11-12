:- initialization(main).
:- include('../common/head').

% yEd creates "nodes" and "edges
% by convention, "GenericNodes" represent boxes and other kinds of nodes are pins.
% in this pass, create a bounding box (left,top,right,bottom) for each "node" with geometry

main :-
    % write(user_error,'cb 00'), nl(user_error),
    readFB(user_input), 
    % write(user_error,'cb 0'), nl(user_error),
    createBoundingBoxes,
    writeFB,
    halt.

createBoundingBoxes :-
    % write(user_error,'cb 1'), nl(user_error),
    forall(geometry_x(ID, X), createBoundingBox(ID, X)).

createBoundingBox(ID, X) :-
    % write(user_error,'cb 2'), nl(user_error),
    geometry_y(ID, Y),
    % write(user_error,'cb 3'), nl(user_error),
    geometry_w(ID, Width),
    % write(user_error,'cb 4'), nl(user_error),
    geometry_h(ID, Height),
    % write(user_error,'cb 5'), nl(user_error),
    asserta(bounding_box_left(ID,X)),
    % write(user_error,'cb 6'), nl(user_error),
    asserta(bounding_box_top(ID,Y)),
    % write(user_error,'cb 7'), nl(user_error),
    Right is X + Width,
    % write(user_error,'cb 8'), nl(user_error),
    Bottom is Y + Height,
    % write(user_error,'cb 9'), nl(user_error),
    asserta(bounding_box_right(ID,Right)),
    % write(user_error,'cb 10'), % write(user_error,ID), % write(user_error,' '), % write(user_error,Bottom),nl(user_error),
    asserta(bounding_box_bottom(ID,Bottom)).
    % write(user_error,'cb 11'), nl(user_error).


:- include('../common/tail').
