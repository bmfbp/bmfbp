:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(unassigned(TextID),createCenter(TextID)),
    forall(eltype(PortID,'port'),createCenter(PortID)),
    writeFB,
    halt.

createCenter(ID) :-
    bounding_box_left(ID,Left),
    bounding_box_top(ID,Top),
    bounding_box_right(ID,Right),
    bounding_box_bottom(ID,Bottom),
    W is ( Right - Left ) / 2,
    X is Left + W,
    asserta(center_x(ID,X)),
    H is ( Bottom - Top ) / 2,
    Y is Top + H,
    asserta(center_y(ID,Y)).


:- include('tail').
