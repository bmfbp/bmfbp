:- initialization(main).
:- include('../common/head').

% with SVG drawings, we have boxes and we have text
% the box "kind" (the shell command name) is denoted by text whose bouding box
% is entirely within the box

main :-
    readFB(user_input),
    createKinds,
    writeFB,
    halt.

createKinds :-
    write(user_error,'0'),nl(user_error),
    forall(rect(ID,_), createKind(ID)).

createKind(ID) :-
    %write(user_error,'1'),nl(user_error),
    bounding_box_left(ID,X),
    %write(user_error,'2'),nl(user_error),
    bounding_box_top(ID,Y),
    %write(user_error,'3'),nl(user_error),
    bounding_box_right(ID,Right),
    %write(user_error,'4'),nl(user_error),
    bounding_box_bottom(ID,Bottom),
    %write(user_error,'5'),nl(user_error),
    text(Tid,KindName),
    %write(user_error,'6'),nl(user_error),
    bounding_box_left(Tid,TX),
    %write(user_error,'7'),nl(user_error),
    bounding_box_top(Tid,TY),
    %write(user_error,'8'),nl(user_error),
    bounding_box_right(Tid,TRight),
    %write(user_error,'9'),nl(user_error),
    bounding_box_bottom(Tid,TBottom),
    write(user_error,ID),write(user_error,' '),write(user_error,Tid),nl(user_error),
    fullyEnclosed(TX,TY,TRight,TBottom,X,Y,Right,Bottom),
    write(user_error,'11'),nl(user_error),
    asserta(kind(ID,KindName)).

createKind(ID) :-
    write(user_error,'box '), write(user_error,ID),
    write(user_error,' has no name'),
    nl(user_error).

fullyEnclosed(X1,Y1,R1,B1,X2,Y2,R2,B2) :-
    write(user_error,X1), write(user_error,' '),
    write(user_error,Y1), write(user_error,' '),
    write(user_error,R1), write(user_error,' '),
    write(user_error,B1), write(user_error,' '),
    write(user_error,X2), write(user_error,' '),
    write(user_error,Y2), write(user_error,' '),
    write(user_error,R2), write(user_error,' '),
    write(user_error,B2), write(user_error,' '),
    nl(user_error),
    X2 =< X1,
    Y2 =< Y1,
    R2 >= R1,
    B2 >= B1.

fullyEnclosed(X1,Y1,R1,B1,X2,Y2,R2,B2) :-
    % bizarre case of text enclosing box
    write(user_error,'enclosed 2'), write(user_error,' '),
    nl(user_error),
    X2 >= X1,
    Y2 >= Y1,
    R2 =< R1,
    B2 =< B1.

:- include('../common/tail').
