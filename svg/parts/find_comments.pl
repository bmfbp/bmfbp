:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    condComment,
    writeFB,
    halt.

condComment :-
    forall(speechbubble(ID),createComments(ID)).

createComments(BubbleID) :-
    text(TextID,_),
    textCompletelyInsideBox(TextID,BubbleID),
    !,
    asserta(used(TextID)),
    asserta(comment(TextID)).

createComments(_) :-
    asserta(log('fATAL',commentFinderFailed)),
    true.

textCompletelyInsideBox(TextID,BubbleID) :-
    pointCompletelyInsideBoundingBox(TextID,BubbleID).

:- include('tail').
