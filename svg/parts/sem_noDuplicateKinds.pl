:- initialization(main).
:- include('head').

main :-
    readFB(user_input),
    forall(eltype(RectID, box), check_has_exactly_one_kind(RectID)),
    writeFB,
    halt.

check_has_exactly_one_kind(RectID) :-
    kind(RectID,Kind1),
    kind(RectID,Kind2),
    Kind1 \= Kind2,
    !,
    asserta(log('fATAL_ERRORS_DURING_COMPILATION')),
    nle,we('ERROR!!! '),we(RectID),we(' has more than one kind '),we(Kind1),wspc,wen(Kind2).

check_has_exactly_one_kind(RectID) :-
    kind(RectID,_),
    !.

check_has_exactly_one_kind(RectID) :-
    nle,we('ERROR!!! '),we(RectID),wen(' has no kind'),
    !,
    asserta(log('fATAL_ERRORS_DURING_COMPILATION')).

:- include('tail').

