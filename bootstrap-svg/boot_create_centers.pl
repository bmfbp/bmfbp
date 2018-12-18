:- initialization(main).
:- include('../common/head').

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
    X is Left + (Right / 2),
    asserta(center_x(ID,X)),
    Y is Top + (Bottom / 2),
    asserta(center_y(ID,Y)).


:- include('../common/tail').
