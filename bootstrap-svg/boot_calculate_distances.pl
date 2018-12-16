:- initialization(main).
:- include('../common/head').

main :-
    readFB(user_input), 
    g_assign(counter,0),
    forall(eltype(PortID,'port'),makeAllCenterPairs(PortID)),
    writeFB,
    halt.

makeAllCenterPairs(PortID) :-
    % each port gets one centerPair for each unused text item
    % each center pair contains the target text id and a distance from the given port
    % centerPair(Port,Pair)
    % distance(Pair,Text)
    % distance_xy(Pair,dx^2 + dy^2)
    forall(portName('nil',TextID),makeCenterPair(PortID,TextID)).

makeCenterPair(PortID,TextID) :-
    makePairID(PortID,Pair),
    center_x(PortID,Px),
    center_y(PortID,Py),
    center_x(TextID,Tx),
    center_y(TextID,Ty),
    DX is Tx - Px,
    DY is Ty - Py,
    DXsq is DX * DX,
    DYsq is DY * DY,
    Dist is DXsq + DYsq,
    DST is sqrt(Dist),
    asserta(distance(Pair,TextID)),
    asserta(distance_xy(Pair,DST)).

makePairID(PortID,NewID) :-
    g_read(counter,NewID),
    asserta(centerPair(PortID,NewID)),
    inc(counter,_).

:- include('../common/tail').
