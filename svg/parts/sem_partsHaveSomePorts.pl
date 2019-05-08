:- initialization(main).
:- include('head').

main :-
    wen('in sem_parts'),
    readFB(user_input),
    forall(eltype(ParentID, box), check_has_port(ParentID)),
    writeFB,
    halt.

check_has_port(ParentID):-
    parent(Port,ParentID),
    eltype(Port,port),
    we('parent / port '),we(ParentID),wspc,wen(Port),
    !.

check_has_port(ParentID):-
    we('parent '),we(ParentID),wen(' has no port').

:- include('tail').

