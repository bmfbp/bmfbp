:- initialization(main).
:- include('../common/head').

main :-
    readFB(user_input), 
    forall(unused_text(TextID),createPortNameIfNotAKindName(TextID)),
    writeFB,
    halt.

unused_text(TextID) :-
    text(TextID,_),
    \+ used(TextID).

createPortNameIfNotAKindName(TextID) :-
    asserta(portName('nil',TextID)).

:- include('../common/tail').
