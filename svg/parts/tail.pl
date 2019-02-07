
writeterm(Term) :- current_output(Out), write_term(Out, Term, []), write(Out, '.'), nl.


writeFB :-
    forall(arrow(X,_), writeterm(arrow(X,nil))),
    forall(arrow_x(X,Y), writeterm(arrow_x(X,Y))),
    forall(arrow_y(X,Y), writeterm(arrow_y(X,Y))),
    forall(rect(X,_), writeterm(rect(X,nil))),
    forall(ellipse(X), writeterm(ellipse(X))),
    forall(line(X,_), writeterm(line(X,nil))), 
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
    forall(geometry_x(X,Y), writeterm(geometry_x(X,Y))),
    forall(geometry_y(X,Y), writeterm(geometry_y(X,Y))),
    forall(node(X), writeterm(node(X))),
    forall(used(X), writeterm(used(X))),
    forall(kind(X,Y), writeterm(kind(X,Y))),
    forall(portName(X,Y), writeterm(portName(X,Y))),
    forall(portNameByID(X,Y), writeterm(portNameByID(X,Y))),
    forall(unassigned(X), writeterm(unassigned(X))),
    forall(source(X,Y), writeterm(source(X,Y))),
    forall(sink(X,Y), writeterm(sink(X,Y))),
    forall(npipes(X), writeterm(npipes(X))),
    forall(pipeNum(X,Y), writeterm(pipeNum(X,Y))),
    forall(sourcefd(X,Y), writeterm(sourcefd(X,Y))),
    forall(sinkfd(X,Y), writeterm(sinkfd(X,Y))),
    forall(parent(X,Y), writeterm(parent(X,Y))).

wspc :-
    write(user_error,' ').

nle :- nl(user_error).

we(X) :- write(user_error,X).

wen(X):- we(X),nle.

readFB(Str) :-
    read_term(Str,T0,[]),
    %write(user_error,T0),nl(user_error),flush_output(user_error),
    element(T0,Str).

element(end_of_file, _) :- !.
element(eltype(X,Y), Str) :- !,
			   asserta(eltype(X,Y)),
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
element(geometry_x(X,Y), Str) :- !,
			   asserta(geometry_x(X,Y)),
		       readFB(Str).
element(geometry_y(X,Y), Str) :- !,
			   asserta(geometry_y(X,Y)),
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
element(node(X), Str) :- !,
			   asserta(node(X)),
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

element(geometry_x(X,Y), Str) :- !,
				 asserta(geometry_x(X,Y)),
				 readFB(Str).

element(geometry_y(X,Y), Str) :- !,
				 asserta(geometry_y(X,Y)),
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

element(line(X,Y), Str) :- !,
			     asserta(line(X,Y)),
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

element(arrow(X,Y), Str) :- !,
			     asserta(arrow(X,Y)),
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


element(rect(X,Y), Str) :- !,
			     asserta(rect(X,Y)),
			     readFB(Str).

element(ellipse(X), Str) :- !,
			     asserta(ellipse(X)),
			     readFB(Str).

element(rect_x(X,Y), Str) :- !,
			     asserta(rect_x(X,Y)),
			     readFB(Str).

element(rect_y(X,Y), Str) :- !,
			     asserta(rect_y(X,Y)),
			     readFB(Str).

element(rect_w(X,Y), Str) :- !,
			     asserta(rect_w(X,Y)),
			     readFB(Str).

element(rect_h(X,Y), Str) :- !,
			     asserta(rect_h(X,Y)),
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
element(distanc(X,Y), Str) :- !,
			     asserta(distanc(X,Y)),
			     readFB(Str).
element(distanc_xy(X,Y), Str) :- !,
			     asserta(distance_xy(X,Y)),
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
    
