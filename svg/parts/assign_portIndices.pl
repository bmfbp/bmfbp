:- initialization(main).
:- include('head').

% 8. assign-fds
% 
% Assigns FD's to each port.  Special cases: "in" is assigned 0, "out"
% is assigned 1, "err" is assigned 2 and beyond that a new fd number is
% generated starting at 3 (untested at this time).
% 
% Augments factbase with:
% 
% (source-fds <id> ((pipe . fd) (pipe . fd) ...))
% (sink-fds <id> ((pipe . fd) (pipe . fd) ...))
% 
% where "pipe" and "fd" are integers.  The (x . y) notation represents a
% pair (2-tuple).
% 

main :-
    readFB(user_input),
    forall(portName(P,in),assign_sink_fd(P,0)), % stdin == 0
    forall(portName(P,out),assign_source_fd(P,1)), % stdout == 1
    forall(portName(P,err),assign_source_fd(P,2)), % stderr == 2
    forall(sinkPortName(P,N),assign_sink_fd(P,N)),
    forall(sourcePortName(P,N),assign_source_fd(P,N)),
    writeFB,
    halt.

sinkPortName(P,N) :-
    portName(P,N),
    sink(_,P),
    integer(N).

sourcePortName(P,N) :-
    portName(P,N),
    source(_,P),
    integer(N).

integerSinkPortName(P,N) :-
    portName(P,N),
    sink(_,P),
    integer(N).

integerSourcePortName(P,N) :-
    portName(P,N),
    source(_,P),
    integer(N).

assign_source_fd(P,N) :-
    asserta(sourcefd(P,N)).

assign_sink_fd(P,N) :-
    asserta(sinkfd(P,N)).

:- include('tail').
