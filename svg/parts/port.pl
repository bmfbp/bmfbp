portFor(RectOrEllipseID,PortID):-
    parent(RectOrEllipseID,PortID),
    port(PortID).

