:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    condComment,
    writeFB,
    halt.

condComment :-
    forall(speechbubble(ID),createComments(ID)).

condComment :-
    asserta(log('fATAL',commentFinderFailed)),
    true.

createComments(BubbleID) :-
    text(TextID,_),
    textCompletelyInsideBox(TextID,BubbleID),
    asserta(used(TextID)),
    asserta(comment(TextID)).

textCompletelyInsideBox(TextID,BubbleID) :-
    pointCompletelyInsideBoundingBox(TextID,BubbleID).

:- include('tail').
