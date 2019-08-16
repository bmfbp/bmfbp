
writeterm(Term) :- current_output(Out), write_term(Out, Term, []), write(Out, '.'), nl.


writeFB :-
    forall(arrow(X), writeterm(arrow(X))),
    forall(arrow_x(X,Y), writeterm(arrow_x(X,Y))),
    forall(arrow_y(X,Y), writeterm(arrow_y(X,Y))),
    forall(rect(X), writeterm(rect(X))),
    forall(roundedrect(X), writeterm(roundedrect(X))),
    forall(pinless(X), writeterm(pinless(X))),
    forall(comment(X), writeterm(comment(X))),
    forall(speechbubble(X), writeterm(speechbubble(X))),
    forall(metadata(X,Y), writeterm(metadata(X,Y))),
    forall(ellipse(X), writeterm(ellipse(X))),
    forall(dot(X), writeterm(dot(X))),
    forall(line(X), writeterm(line(X))), 
    forall(line_begin_x(X,Y), writeterm(line_begin_x(X,Y))), 
    forall(line_begin_y(X,Y), writeterm(line_begin_y(X,Y))), 
    forall(line_end_x(X,Y), writeterm(line_end_x(X,Y))), 
    forall(line_end_y(X,Y), writeterm(line_end_y(X,Y))), 
    forall(stroke_absolute_x(X,Y), writeterm(stroke_absolute_x(X,Y))), 
    forall(stroke_absolute_y(X,Y), writeterm(stroke_absolute_y(X,Y))),
    forall(stroke_relative_x(X,Y), writeterm(stroke_relative_x(X,Y))),
    forall(stroke_relative_y(X,Y), writeterm(stroke_relative_y(X,Y))),
    forall(text(X,Y), writeterm(text(X,Y))),
    forall(text_x(X,Y), writeterm(text_x(X,Y))),
    forall(text_y(X,Y), writeterm(text_y(X,Y))),
    forall(text_w(X,Y), writeterm(text_w(X,Y))),
    forall(text_h(X,Y), writeterm(text_h(X,Y))),

    forall(join_centerPair(X,Y), writeterm(join_centerPair(X,Y))),
    forall(join_distance(X,Y), writeterm(join_distance(X,Y))),
    forall(distance_xy(X,Y), writeterm(distance_xy(X,Y))),

    forall(bounding_box_left(X,Y), writeterm(bounding_box_left(X,Y))),
    forall(bounding_box_top(X,Y), writeterm(bounding_box_top(X,Y))),
    forall(bounding_box_right(X,Y), writeterm(bounding_box_right(X,Y))),
    forall(bounding_box_bottom(X,Y), writeterm(bounding_box_bottom(X,Y))),
    forall(center_x(X,Y), writeterm(center_x(X,Y))),
    forall(center_y(X,Y), writeterm(center_y(X,Y))),
    forall(component(X), writeterm(component(X))),
    forall(edge(X), writeterm(edge(X))),
    forall(eltype(X,Y), writeterm(eltype(X,Y))),
    forall(geometry_h(X,Y), writeterm(geometry_h(X,Y))),
    forall(geometry_w(X,Y), writeterm(geometry_w(X,Y))),
    forall(geometry_left_x(X,Y), writeterm(geometry_left_x(X,Y))),
    forall(geometry_top_y(X,Y), writeterm(geometry_top_y(X,Y))),
    forall(geometry_center_x(X,Y), writeterm(geometry_center_x(X,Y))),
    forall(geometry_center_y(X,Y), writeterm(geometry_center_y(X,Y))),
    forall(used(X), writeterm(used(X))),
    forall(kind(X,Y), writeterm(kind(X,Y))),
    forall(selfPort(X,Y), writeterm(selfPort(X,Y))),
    forall(portIndex(X,Y), writeterm(portIndex(X,Y))),
    forall(portIndexByID(X,Y), writeterm(portIndexByID(X,Y))),
    forall(portName(X,Y), writeterm(portName(X,Y))),
    forall(portNameByID(X,Y), writeterm(portNameByID(X,Y))),
    forall(unassigned(X), writeterm(unassigned(X))),
    forall(source(X,Y), writeterm(source(X,Y))),
    forall(sink(X,Y), writeterm(sink(X,Y))),
    forall(npipes(X), writeterm(npipes(X))),
    forall(pipeNum(X,Y), writeterm(pipeNum(X,Y))),

    forall(nwires(X), writeterm(nwires(X))),
    forall(wireNum(X,Y), writeterm(wireNum(X,Y))),

    forall(sourcefd(X,Y), writeterm(sourcefd(X,Y))),
    forall(sinkfd(X,Y), writeterm(sinkfd(X,Y))),
    forall(inputPin(X,Y), writeterm(inputPin(X,Y))),
    forall(outputPin(X,Y), writeterm(outputPin(X,Y))),
    forall(selfInputPin(X,Y), writeterm(selfInputPin(X,Y))),
    forall(selfOutputPin(X,Y), writeterm(selfOutputPin(X,Y))),
    forall(wireIndex(X,Y), writeterm(wireIndex(X,Y))),
    forall(n_c(X), writeterm(n_c(X))),
    forall(indexedSink(X), writeterm(indexedSink(X))),
    forall(indexedSource(X), writeterm(indexedSource(X))),
    forall(parent(X,Y), writeterm(parent(X,Y))),
    writelog.

writelog :-
    forall(log(X),writelog(X)),
    forall(log(Z,Y),writelog(Z,Y)),
    forall(log(A,B,C),writelog(A,B,C)),
    forall(log(D,E,F,G),writelog(D,E,F,G)),
    forall(log(H,I,J,K,L),writelog(H,I,J,K,L)),
    forall(log(M,N,O,P,Q,R),writelog(M,N,O,P,Q,R)),
    forall(log(S,T,U,V,W,X,Y),writelog(S,T,U,V,W,X,Y)),
    forall(log(R,S,T,U,V,W,X,Y),writelog(R,S,T,U,V,W,X,Y)).

writelog(X) :- writeterm(log(X)).
writelog(Y,Z) :-writeterm(log(Y,Z)).
writelog(X,Y,Z) :-writeterm(log(X,Y,Z)).
writelog(W,X,Y,Z) :-writeterm(log(W,X,Y,Z)).
writelog(A,B,C,D,E) :-writeterm(log(A,B,C,D,E)).
writelog(A,B,C,D,E,F) :-writeterm(log(A,B,C,D,E,F)).
writelog(A,B,C,D,E,F,G) :-writeterm(log(A,B,C,D,E,F,G)).
writelog(A,B,C,D,E,F,G,H) :-writeterm(log(A,B,C,D,E,F,G,H)).


wspc :-
    write(user_error,' ').

nle :- nl(user_error).

we(X) :- write(user_error,X).

wen(X):- we(X),nle.

readFB(Str) :-
    read_term(Str,T0,[]),
    element(T0,Str).

element(end_of_file, _) :- !.
element(eltype(X,Y), Str) :- !,
			   asserta(eltype(X,Y)),
		       readFB(Str).
element(portIndex(X,Y), Str) :- !,
			   asserta(portIndex(X,Y)),
		       readFB(Str).
element(portIndexByID(X,Y), Str) :- !,
			   asserta(portIndexByID(X,Y)),
		       readFB(Str).
element(portName(X,Y), Str) :- !,
			   asserta(portName(X,Y)),
		       readFB(Str).
element(portNameByID(X,Y), Str) :- !,
			   asserta(portNameByID(X,Y)),
		       readFB(Str).
element(unassigned(X), Str) :- !,
			   asserta(unassigned(X)),
		       readFB(Str).
element(kind(X,Y), Str) :- !,
			   asserta(kind(X,Y)),
		       readFB(Str).
element(geometry_left_x(X,Y), Str) :- !,
			   asserta(geometry_left_x(X,Y)),
		       readFB(Str).
element(selfPort(X,Y), Str) :- !,
			   asserta(selfPort(X,Y)),
		       readFB(Str).
element(geometry_top_y(X,Y), Str) :- !,
			   asserta(geometry_top_y(X,Y)),
		       readFB(Str).
element(geometry_center_x(X,Y), Str) :- !,
			   asserta(geometry_center_x(X,Y)),
		       readFB(Str).
element(geometry_center_y(X,Y), Str) :- !,
			   asserta(geometry_center_y(X,Y)),
		       readFB(Str).
element(geometry_w(X,Y), Str) :- !,
			   asserta(geometry_w(X,Y)),
		       readFB(Str).
element(geometry_h(X,Y), Str) :- !,
			   asserta(geometry_h(X,Y)),
		       readFB(Str).
element(used(X), Str) :- !,
			   asserta(used(X)),
		       readFB(Str).
element(component(X), Str) :- !,
			   asserta(component(X)),
		       readFB(Str).
element(edge(X), Str) :- !,
			   asserta(edge(X)),
		       readFB(Str).
element(source(X,Y), Str) :- !,
			   asserta(source(X,Y)),
		       readFB(Str).
element(sink(X,Y), Str) :- !,
			   asserta(sink(X,Y)),
		       readFB(Str).

element(geometry_left_x(X,Y), Str) :- !,
				 asserta(geometry_left_x(X,Y)),
				 readFB(Str).

element(geometry_top_y(X,Y), Str) :- !,
				 asserta(geometry_top_y(X,Y)),
				 readFB(Str).

element(geometry_center_x(X,Y), Str) :- !,
				 asserta(geometry_center_x(X,Y)),
				 readFB(Str).

element(geometry_center_y(X,Y), Str) :- !,
				 asserta(geometry_center_y(X,Y)),
				 readFB(Str).

element(geometry_w(X,Y), Str) :- !,
				 asserta(geometry_w(X,Y)),
				 readFB(Str).

element(geometry_y(X,Y), Str) :- !,
				 asserta(geometry_h(X,Y)),
				 readFB(Str).

element(bounding_box_left(X,Y), Str) :- !,
				 asserta(bounding_box_left(X,Y)),
				 readFB(Str).

element(bounding_box_top(X,Y), Str) :- !,
				 asserta(bounding_box_top(X,Y)),
				 readFB(Str).

element(bounding_box_right(X,Y), Str) :- !,
				 asserta(bounding_box_right(X,Y)),
				 readFB(Str).

element(bounding_box_bottom(X,Y), Str) :- !,
				 asserta(bounding_box_bottom(X,Y)),
				 readFB(Str).

element(center_x(X,Y), Str) :- !,
				 asserta(center_x(X,Y)),
				 readFB(Str).

element(center_y(X,Y), Str) :- !,
				 asserta(center_y(X,Y)),
				 readFB(Str).

element(parent(X,Y), Str) :- !,
			     asserta(parent(X,Y)),
			     readFB(Str).

element(wireIndex(X,Y), Str) :- !,
			     asserta(wireIndex(X,Y)),
			     readFB(Str).

element(inputPin(X,Y), Str) :- !,
			     asserta(inputPin(X,Y)),
			     readFB(Str).

element(outputPin(X,Y), Str) :- !,
			     asserta(outputPin(X,Y)),
			     readFB(Str).

element(selfInputPin(X,Y), Str) :- !,
			     asserta(selfInputPin(X,Y)),
			     readFB(Str).

element(selfOutputPin(X,Y), Str) :- !,
			     asserta(selfOutputPin(X,Y)),
			     readFB(Str).

element(line(X), Str) :- !,
			     asserta(line(X)),
			     readFB(Str).

element(line_begin_x(X,Y), Str) :- !,
			     asserta(line_begin_x(X,Y)),
			     readFB(Str).

element(line_begin_y(X,Y), Str) :- !,
			     asserta(line_begin_y(X,Y)),
			     readFB(Str).

element(line_end_x(X,Y), Str) :- !,
			     asserta(line_end_x(X,Y)),
			     readFB(Str).

element(line_end_y(X,Y), Str) :- !,
			     asserta(line_end_y(X,Y)),
			     readFB(Str).

element(pipeNum(X,Y), Str) :- !,
			     asserta(pipeNum(X,Y)),
			     readFB(Str).

element(wireNum(X,Y), Str) :- !,
			     asserta(wireNum(X,Y)),
			     readFB(Str).

element(arrow(X), Str) :- !,
			     asserta(arrow(X)),
			     readFB(Str).

element(arrow_x(X,Y), Str) :- !,
			     asserta(arrow_x(X,Y)),
			     readFB(Str).

element(arrow_y(X,Y), Str) :- !,
			     asserta(arrow_y(X,Y)),
			     readFB(Str).

element(sinkfd(P,F), Str) :- !,
			     asserta(sinkfd(P,F)),
			     readFB(Str).

element(sourcefd(P,F), Str) :- !,
			     asserta(sourcefd(P,F)),
			     readFB(Str).

element(source(P,F), Str) :- !,
			     asserta(source(P,F)),
			     readFB(Str).

element(npipes(X), Str) :- !,
			     asserta(npipes(X)),
			     readFB(Str).

element(nwires(X), Str) :- !,
			     asserta(nwires(X)),
			     readFB(Str).

element(move_absolute_x(X,Y), Str) :- !,
			     asserta(move_absolute_x(X,Y)),
			     readFB(Str).


element(move_absolute_y(X,Y), Str) :- !,
			     asserta(move_absolute_y(X,Y)),
			     readFB(Str).


element(move_relative_x(X,Y), Str) :- !,
			     asserta(move_relative_x(X,Y)),
			     readFB(Str).

element(move_relative_y(X,Y), Str) :- !,
			     asserta(move_relative_y(X,Y)),
			     readFB(Str).


element(rect(X), Str) :- !,
			     asserta(rect(X)),
			     readFB(Str).
element(roundedrect(X), Str) :- !,
			     asserta(roundedrect(X)),
			     readFB(Str).
element(pinless(X), Str) :- !,
			     asserta(pinless(X)),
			     readFB(Str).
element(speechbubble(X), Str) :- !,
			     asserta(speechbubble(X)),
			     readFB(Str).
element(comment(X), Str) :- !,
			     asserta(comment(X)),
			     readFB(Str).
element(metadata(X,Y), Str) :- !,
			     asserta(metadata(X,Y)),
			     readFB(Str).

element(ellipse(X), Str) :- !,
			     asserta(ellipse(X)),
			     readFB(Str).

element(dot(X), Str) :- !,
			     asserta(dot(X)),
			     readFB(Str).

element(stroke_relative_x(X,Y), Str) :- !,
			     asserta(stroke_relative_x(X,Y)),
			     readFB(Str).

element(stroke_relative_y(X,Y), Str) :- !,
			     asserta(stroke_relative_y(X,Y)),
			     readFB(Str).


element(stroke_absolute_x(X,Y), Str) :- !,
			     asserta(stroke_absolute_x(X,Y)),
			     readFB(Str).

element(stroke_absolute_y(X,Y), Str) :- !,
			     asserta(stroke_absolute_y(X,Y)),
			     readFB(Str).

element(text(X,Y), Str) :- !,
			     asserta(text(X,Y)),
			     readFB(Str).

element(text_x(X,Y), Str) :- !,
			     asserta(text_x(X,Y)),
			     readFB(Str).

element(text_y(X,Y), Str) :- !,
			     asserta(text_y(X,Y)),
			     readFB(Str).

element(text_w(X,Y), Str) :- !,
			     asserta(text_w(X,Y)),
			     readFB(Str).

element(text_h(X,Y), Str) :- !,
			     asserta(text_h(X,Y)),
			     readFB(Str).

element(join_centerPair(X,Y), Str) :- !,
			     asserta(join_centerPair(X,Y)),
			     readFB(Str).

element(join_distance(X,Y), Str) :- !,
			     asserta(join_distance(X,Y)),
			     readFB(Str).

element(distance_xy(X,Y), Str) :- !,
			     asserta(distance_xy(X,Y)),
			     readFB(Str).



element(centerPair(X,Y), Str) :- !,
			     asserta(centerPair(X,Y)),
			     readFB(Str).
element(distance(X,Y), Str) :- !,
			     asserta(distance(X,Y)),
			     readFB(Str).

element(n_c(X), Str) :- !,
			     asserta(n_c(X)),
			     readFB(Str).

element(indexedSink(X), Str) :- !,
			     asserta(indexedSink(X)),
			     readFB(Str).

element(indexedSource(X), Str) :- !,
			     asserta(indexedSource(X)),
			     readFB(Str).

element(log(W), Str) :- !,
			     asserta(log(W)),
			     readFB(Str).

element(log(W,X), Str) :- !,
			     asserta(log(W,X)),
			     readFB(Str).

element(log(W,X,Y), Str) :- !,
			     asserta(log(W,X,Y)),
			     readFB(Str).

element(log(W,X,Y,Z), Str) :- !,
			     asserta(log(W,X,Y,Z)),
			     readFB(Str).

element(log(A,W,X,Y,Z), Str) :- !,
			     asserta(log(A,W,X,Y,Z)),
			     readFB(Str).

element(log(A,B,W,X,Y,Z), Str) :- !,
			     asserta(log(A,B,W,X,Y,Z)),
			     readFB(Str).

element(log(A,B,C,W,X,Y,Z), Str) :- !,
			     asserta(log(A,B,C,W,X,Y,Z)),
			     readFB(Str).

element(log(A,B,C,D,W,X,Y,Z), Str) :- !,
			     asserta(log(A,B,C,D,W,X,Y,Z)),
			     readFB(Str).


    
element(Term, _) :-
    write(user_error,'failed read '),
    write(user_error,Term),
    nl(user_error).
    % type_error(element, Term).

inc(Var, Value) :-
    g_read(Var, Value),
    X is Value+1,
    g_assign(Var, X).

boundingboxCompletelyInside(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),
    bounding_box_right(ID1,R1),
    bounding_box_bottom(ID1,B1),

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2),

    L1 >= L2,
    T1 >= T2,
    R2 >= R1,
    B2 >= B1.

pointCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2),

    % we('point inside: L1/T1/L2/T2/R2/B2: '),we(L1),wspc,we(T1),wspc,we(L2),wspc,we(T2),wspc,we(R2),wspc,wen(B2),

    L1 >= L2,
    T1 >= T2,
    R2 >= L1,
    B2 >= T1.

centerCompletelyInsideBoundingBox(ID1,ID2) :-
    bounding_box_left(ID1,L1),
    bounding_box_top(ID1,T1),
    bounding_box_right(ID1,R1),
    bounding_box_bottom(ID1,B1),
    
    Cx is L1 + (R1 - L1),
    Cy is T1 + (B1 - T1),

    bounding_box_left(ID2,L2),
    bounding_box_top(ID2,T2),
    bounding_box_right(ID2,R2),
    bounding_box_bottom(ID2,B2),

    %% we('ccibb id1/center/id2 '),
    %% we(ID1), wspc,
    %% we(L1), wspc,
    %% we(T1), wspc,
    %% we(R1), wspc,
    %% we(B1), wspc,
    %% we(Cx), wspc,
    %% we(Cy), wspc,
    %% we(ID2), wspc,
    %% we(L2), wspc,
    %% we(T2), wspc,
    %% we(R2), wspc,
    %% wen(B2),

    Cx >= L2,
    Cx =< R2,
    Cy >= T2,
    Cy =< B2.

dumplog :-
    forall(log(X),dumplog(X)),
    forall(log(Z,Y),dumplog(Z,Y)),
    forall(log(A,B,C),dumplog(A,B,C)),
    forall(log(D,E,F,G),dumplog(D,E,F,G)),
    forall(log(H,I,J,K,L),dumplog(H,I,J,K,L)),
    forall(log(M,N,O,P,Q,R),dumplog(M,N,O,P,Q,R)),
    forall(log(M1,N1,O1,P1,Q1,R1,S1),dumplog(M1,N1,O1,P1,Q1,R1,S1)),
    forall(log(M2,N2,O2,P2,Q2,R2,S2,T2),dumplog(M2,N2,O2,P2,Q2,R2,S2,T2)).

dumplog(W) :- wen(W).
dumplog(W,X) :- we(W),wspc,wen(X).
dumplog(W,X,Y) :- we(W),wspc,we(X),wspc,wen(Y).
dumplog(W,X,Y,Z) :- we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(V,W,X,Y,Z) :- we(V),wspc,we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(U,V,W,X,Y,Z) :- we(U),wspc,we(V),wspc,we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(T,U,V,W,X,Y,Z) :- we(T),wspc,we(U),wspc,we(V),wspc,we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
dumplog(S,T,U,V,W,X,Y,Z) :- we(S),wspc,we(T),wspc,we(U),wspc,we(V),wspc,we(W),wspc,we(X),wspc,we(Y),wspc,wen(Z).
