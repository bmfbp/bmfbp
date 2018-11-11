
% Ye creates "nodes" and "edges"
% by convention, "GenericNodes" represent boxes and other kinds of nodes are pins.
% in this pass, create a bounding box (left,top,right,bottom) for each "node" with geometry

% The point of this pass is to find all sources and sinks attached to any edge
% a "source" is a component pin that produces events (IPs) and a "sink" is the destination
% for events.  We avoid the more obvious terms "input" and "output" because the terms are
% ambiguous in hierarchical components, e.g. an input pin on the outside of a hierarchial
% component looks like it "outputs" events to any components contained within the hierarchical component.

% yEd creates edges with clearly delineated sources and sinks, hence, this pass is
% redundant for this particular application (using yEd); just read and re-emit all facts


:- initialization(main).
:- include(head).

main :-
    readFB(user_input),
    writeFB,
    halt.

:- include(tail).
