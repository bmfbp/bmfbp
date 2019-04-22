:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    g_assign(counter,0),
    forall(eltype(PortID,'port'),makeAllCenterPairs(PortID)),
    conditionalEllipseCenterPairs,
    writeFB,
    halt.

conditionalEllipseCenterPairs :-
    ellipse(_),
    forall(ellipse(PortID),makeAllCenterPairs(PortID)).

conditionalEllipseCenterPairs :-
    true.

makeAllCenterPairs(PortID) :-
    % each port gets one centerPair for each unused text item
    % each center pair contains the target text id and a distance from the given port
    % join_centerPair(Port,Pair)
    % join_distance(Pair,Text)
    % distance_xy(Pair,dx^2 + dy^2)
    forall(unassigned(TextID),makeCenterPair(PortID,TextID)).

makeCenterPair(PortID,TextID) :-
    makePairID(PortID,JoinPairID),
    center_x(PortID,Px),
    center_y(PortID,Py),
    center_x(TextID,Tx),
    center_y(TextID,Ty),
    DX is Tx - Px,
    DY is Ty - Py,
    DXsq is DX * DX,
    DYsq is DY * DY,
    Sum is DXsq + DYsq,
    DISTANCE is sqrt(Sum),
    asserta(join_distance(JoinPairID,TextID)),
    asserta(distance_xy(JoinPairID,DISTANCE)).

makePairID(PortID,NewID) :-
    g_read(counter,NewID),
    asserta(join_centerPair(PortID,NewID)),
    inc(counter,_).

:- include('tail').
