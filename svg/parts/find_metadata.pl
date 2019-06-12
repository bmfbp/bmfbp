:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    condMeta,
    writeFB,
    halt.

condMeta :-
    forall(metadata(MID,_),createMetaDataRect(MID)).

condMeta :-
    true.

createMetaDataRect(MID) :-
    metadata(MID,TextID),
    rect(BoxID),
    metadataCompletelyInsideBoundingBox(TextID,BoxID),
    asserta(used(TextID)),
    asserta(roundedRect(BoxID)),
    retract(rect(BoxID)).

createMetaDataRect(TextID) :-
    wen(' '),we('createMetaDataRect failed '),wen(TextID).

metadataCompletelyInsideBoundingBox(TextID,BoxID) :-
    % we('mtcib: '),we(TextID),wspc,wen(BoxID),
    pointCompletelyInsideBoundingBox(TextID,BoxID).

:- include('tail').
