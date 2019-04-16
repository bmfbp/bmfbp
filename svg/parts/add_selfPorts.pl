:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(eltype(ID,ellipse),createSelfPorts(Ellipse)),
    writeFB,
    halt.

createSelfPorts(Ellipse) :-
    text(TextID,Str),
    textCompletelyInsideBox(TextID,Ellipse),
    asserta(used(TextID)),
    asserta(selfPort(Ellipse,Str)),
    asserta(eltype(OBJ,selfPort)).

textCompletelyInsideBox(TextID,OBJID) :-
    boundingboxCompletelyInside(TextID,OBJID).

:- include('tail').
