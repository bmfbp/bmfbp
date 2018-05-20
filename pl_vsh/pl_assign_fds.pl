:- initialization(main).
:- include(head).

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
    g_assign(fdnum,3),  % non-special case fd's start at 3 and up to maximum
    readFB(user_input),
    forall(portName(P,in),assign_source_fd(P,0)), % stdin == 0
    forall(portName(P,out),assign_sink_fd(P,1)), % stdout == 1
    forall(portName(P,err),assign_sink_fd(P,2)), % stderr == 2

    %-- still thinking about this one - what about non-std fd's?
    %-- are the ports per-component?  Are they named at the architectural level?

    writeFB,
    halt.

assign_source_fd(P,N) :-
    %write(P), write(' '), write(N), nl,
    asserta(sourcefd(P,N)).

assign_sink_fd(P,N) :-
    %write(P), write(' '), write(N), nl,
    asserta(sinkfd(P,N)).

%has_fd(P) :-
%    ( sourcefd(P,_) ; (sinkfd(P,_) ).
    
:- include(tail).
