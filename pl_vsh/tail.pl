
writeterm(Term) :- current_output(Out), write_term(Out, Term, []), write(Out, '.'), nl.


writeFB :-
    forall(bounding_box_left(X,Y), writeterm(bounding_box_left(X,Y))),
    forall(bounding_box_top(X,Y), writeterm(bounding_box_top(X,Y))),
    forall(bounding_box_right(X,Y), writeterm(bounding_box_right(X,Y))),
    forall(bounding_box_bottom(X,Y), writeterm(bounding_box_bottom(X,Y))),
    forall(component(X), writeterm(component(X))),
    forall(edge(X), writeterm(edge(X))),
    forall(eltype(X,Y), writeterm(eltype(X,Y))),
    forall(kind(X,Y), writeterm(kind(X,Y))),
    forall(geometry_h(X,Y), writeterm(geometry_h(X,Y))),
    forall(geometry_w(X,Y), writeterm(geometry_w(X,Y))),
    forall(geometry_x(X,Y), writeterm(geometry_x(X,Y))),
    forall(geometry_y(X,Y), writeterm(geometry_y(X,Y))),
    forall(node(X), writeterm(node(X))),
    forall(portName(X,Y), writeterm(portName(X,Y))),
    forall(source(X,Y), writeterm(source(X,Y))),
    forall(sink(X,Y), writeterm(sink(X,Y))),
    forall(npipes(X), writeterm(npipes(X))),
    forall(pipeNum(X,Y), writeterm(pipeNum(X,Y))),
    forall(sourcefd(X,Y), writeterm(sourcefd(X,Y))),
    forall(sinkfd(X,Y), writeterm(sinkfd(X,Y))),
    forall(parent(X,Y), writeterm(parent(X,Y))).

readFB(Str) :-
    read_term(Str,T0,[]),
    element(T0,Str).

element(end_of_file, _) :- !.
element(eltype(X,Y), Str) :- !,
			   asserta(eltype(X,Y)),
		       readFB(Str).
element(kind(X,Y), Str) :- !,
			   asserta(kind(X,Y)),
		       readFB(Str).
element(portName(X,Y), Str) :- !,
			   asserta(portName(X,Y)),
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

element(parent(X,Y), Str) :- !,
			     asserta(parent(X,Y)),
			     readFB(Str).

element(pipeNum(X,Y), Str) :- !,
			     asserta(pipeNum(X,Y)),
			     readFB(Str).

element(sinkfd(P,F), Str) :- !,
			     asserta(sinkfd(P,F)),
			     readFB(Str).

element(sourcefd(P,F), Str) :- !,
			     asserta(sourcefd(P,F)),
			     readFB(Str).

element(npipes(X), Str) :- !,
			     asserta(npipes(X)),
			     readFB(Str).

%element(Term, _) :-
%     type_error(element, Term).

inc(Var, Value) :-
    g_read(Var, Value),
    X is Value+1,
    g_assign(Var, X).
    
