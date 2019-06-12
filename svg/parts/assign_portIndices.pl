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
    %g_assign(fdnum,3),  % non-special case fd's start at 3 and up to maximum
    readFB(user_input),
    forall(portName(P,in),assign_sink_fd(P,0)), % stdin == 0
    forall(portName(P,out),assign_source_fd(P,1)), % stdout == 1
    forall(portName(P,err),assign_source_fd(P,2)), % stderr == 2
    forall(integerSinkPortName(P,N),assign_sink_fd(P,N)),
    forall(integerSourcePortName(P,N),assign_source_fd(P,N)),

    writeFB,
    halt.

integerSinkPortName(P,N) :-
    portName(P,N),
    sink(_,P),
    integer(N).
    %write(user_error,'integer sink '),write(user_error,P),write(user_error,' '),write(user_error,N),nl(user_error).

integerSourcePortName(P,N) :-
    portName(P,N),
    source(_,P),
    integer(N).

assign_source_fd(P,N) :-
    %write(P), write(' '), write(N), nl,
    asserta(log(coincidentSource,P,N)),
    asserta(sourcefd(P,N)).

assign_sink_fd(P,N) :-
    %% we(P), we(' '),we(N),nle,
    asserta(log(coincidentSink,P,N,z)),
    asserta(sinkfd(P,N)).

%has_fd(P) :-
%    ( sourcefd(P,_) ; (sinkfd(P,_) ).
    
:- include('tail').
