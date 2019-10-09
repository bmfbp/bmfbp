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
    asserta(log('fATAL_ERRORS_DURING_COMPILATION','noDuplicateKinds')),
    asserta(log('rect ', RectID)),
    asserta(log(Kind1)),
    asserta(log(Kind2)),
    nle,we('ERROR!!! '),we(RectID),we(' has more than one kind '),we(Kind1),wspc,wen(Kind2).

check_has_exactly_one_kind(RectID) :-
    kind(RectID,_),
    !.

check_has_exactly_one_kind(RectID) :-
    % not actually an error if the RectID belongs to metadata
    roundedrect(RectID),
    !.

check_has_exactly_one_kind(RectID) :-
    asserta(log(RectID,'has_no_kind','noDuplicateKinds')),
    !.

:- include('tail').

