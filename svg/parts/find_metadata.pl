:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(metadata(TextID),createMetaDataRect(TextID)),
    writeFB,
    halt.

createMetaDataRect(TextID) :-
    rect(BoxID),
    metadataCompletelyInsideBoundingBox(TextID,BoxID),
    asserta(used(TextID)),
    asserta(roundedRect(BoxID)),
    retract(rect(BoxID)).


metadataCompletelyInsideBoundingBox(TextID,BoxID) :-
    we('mtcib: '),we(TextID),wspc,wen(BoxID),
    pointCompletelyInsideBoundingBox(TextID,BoxID).

:- include('tail').
