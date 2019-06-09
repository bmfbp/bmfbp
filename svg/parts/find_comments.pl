:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(speechbubble(ID),createComments(ID)),
    writeFB,
    halt.

createComments(BubbleID) :-
    text(TextID,_),
    textCompletelyInsideBox(TextID,BubbleID),
    asserta(used(TextID)),
    asserta(comment(TextID)).


textCompletelyInsideBox(TextID,BubbleID) :-
    boundingboxCompletelyInside(TextID,BubbleID).

:- include('tail').
