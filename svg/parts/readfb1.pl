readFB(Stream) :-
    read_term(Stream,T0,[]),
    element(T0,Stream).

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


    
element(Term, _) :-
    write(user_error,'failed read '),
    write(user_error,Term),
    nl(user_error).
