:- initialization(main).
:- include('../common/head').

main :-
    readFB(user_input), 
    forall(text(TextID,_),createPortNameIfNotAKindName(TextID)),
    writeFB,
    halt.

createPortNameIfNotAKindName(TextID) :-
    text(TextID,Text),
    kind(_,Text),  % ignore if already a kind
write(user_error,'already a kind '),write(user_error,' '),write(user_error,TextID),nl(user_error),
    !.

createPortNameIfNotAKindName(TextID) :-
    asserta(portName('nil',TextID)),!.

:- include('../common/tail').
