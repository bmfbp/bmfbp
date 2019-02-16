:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    forall(eltype(Part,box),makeInputPins(Part)),
    forall(eltype(Part,box),makeOutputPins(Part)),
    writeFB,
    halt.

makeInputPins(Part) :-
    sink(Wire,Pin),
    eltype(Pin,port),
    parent(Pin,Part),
    pipeNum(Pin,WireIndex),
    asserta(inputPin(Part,Pin)),
    asserta(wireIndex(Pin,WireIndex)).

makeInputPins(_) :-
    true.

makeOutputPins(Part) :-
    sink(Wire,Pin),
    eltype(Pin,port),
    parent(Pin,Part),
    pipeNum(Pin,WireIndex),
    asserta(outputPin(Part,Pin)),
    asserta(wireIndex(Pin,WireIndex)).

makeOutputPins(_) :-
    true.

:- include('tail').
