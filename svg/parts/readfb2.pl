readFB(Name,Stream) :-
    read_term(Stream,T0,[]),
    we(Name),
    we(' read: '),
    wen(T0),
    element(Name,T0,Stream).

element(_,end_of_file, _) :- !.
element(Name,eltype(X,Y), Str) :- !,
			   asserta(eltype(X,Y)),
		       readFB(Name,Str).
element(Name,portIndex(X,Y), Str) :- !,
			   asserta(portIndex(X,Y)),
		       readFB(Name,Str).
element(Name,portIndexByID(X,Y), Str) :- !,
			   asserta(portIndexByID(X,Y)),
		       readFB(Name,Str).
element(Name,portName(X,Y), Str) :- !,
			   asserta(portName(X,Y)),
		       readFB(Name,Str).
element(Name,portNameByID(X,Y), Str) :- !,
			   asserta(portNameByID(X,Y)),
		       readFB(Name,Str).
element(Name,unassigned(X), Str) :- !,
			   asserta(unassigned(X)),
		       readFB(Name,Str).
element(Name,kind(X,Y), Str) :- !,
			   asserta(kind(X,Y)),
		       readFB(Name,Str).
element(Name,selfPort(X,Y), Str) :- !,
			   asserta(selfPort(X,Y)),
		       readFB(Name,Str).
element(Name,geometry_top_y(X,Y), Str) :- !,
			   asserta(geometry_top_y(X,Y)),
		       readFB(Name,Str).
element(Name,geometry_center_x(X,Y), Str) :- !,
			   asserta(geometry_center_x(X,Y)),
		       readFB(Name,Str).
element(Name,geometry_center_y(X,Y), Str) :- !,
			   asserta(geometry_center_y(X,Y)),
		       readFB(Name,Str).
element(Name,geometry_w(X,Y), Str) :- !,
			   asserta(geometry_w(X,Y)),
		       readFB(Name,Str).
element(Name,geometry_h(X,Y), Str) :- !,
			   asserta(geometry_h(X,Y)),
		       readFB(Name,Str).
element(Name,used(X), Str) :- !,
			   asserta(used(X)),
		       readFB(Name,Str).
element(Name,component(X), Str) :- !,
			   asserta(component(X)),
		       readFB(Name,Str).
element(Name,edge(X), Str) :- !,
			   asserta(edge(X)),
		       readFB(Name,Str).
element(Name,source(X,Y), Str) :- !,
			   asserta(source(X,Y)),
		       readFB(Name,Str).
element(Name,sink(X,Y), Str) :- !,
			   asserta(sink(X,Y)),
		       readFB(Name,Str).

element(Name,geometry_left_x(X,Y), Str) :- !,
				 asserta(geometry_left_x(X,Y)),
				 readFB(Name,Str).

element(Name,geometry_top_y(X,Y), Str) :- !,
				 asserta(geometry_top_y(X,Y)),
				 readFB(Name,Str).

element(Name,geometry_center_x(X,Y), Str) :- !,
				 asserta(geometry_center_x(X,Y)),
				 readFB(Name,Str).

element(Name,geometry_center_y(X,Y), Str) :- !,
				 asserta(geometry_center_y(X,Y)),
				 readFB(Name,Str).

element(Name,geometry_w(X,Y), Str) :- !,
				 asserta(geometry_w(X,Y)),
				 readFB(Name,Str).

element(Name,geometry_y(X,Y), Str) :- !,
				 asserta(geometry_h(X,Y)),
				 readFB(Name,Str).

element(Name,bounding_box_left(X,Y), Str) :- !,
				 asserta(bounding_box_left(X,Y)),
				 readFB(Name,Str).

element(Name,bounding_box_top(X,Y), Str) :- !,
				 asserta(bounding_box_top(X,Y)),
				 readFB(Name,Str).

element(Name,bounding_box_right(X,Y), Str) :- !,
				 asserta(bounding_box_right(X,Y)),
				 readFB(Name,Str).

element(Name,bounding_box_bottom(X,Y), Str) :- !,
				 asserta(bounding_box_bottom(X,Y)),
				 readFB(Name,Str).

element(Name,center_x(X,Y), Str) :- !,
				 asserta(center_x(X,Y)),
				 readFB(Name,Str).

element(Name,center_y(X,Y), Str) :- !,
				 asserta(center_y(X,Y)),
				 readFB(Name,Str).

element(Name,parent(X,Y), Str) :- !,
			     asserta(parent(X,Y)),
			     readFB(Name,Str).

element(Name,wireIndex(X,Y), Str) :- !,
			     asserta(wireIndex(X,Y)),
			     readFB(Name,Str).

element(Name,inputPin(X,Y), Str) :- !,
			     asserta(inputPin(X,Y)),
			     readFB(Name,Str).

element(Name,outputPin(X,Y), Str) :- !,
			     asserta(outputPin(X,Y)),
			     readFB(Name,Str).

element(Name,selfInputPin(X,Y), Str) :- !,
			     asserta(selfInputPin(X,Y)),
			     readFB(Name,Str).

element(Name,selfOutputPin(X,Y), Str) :- !,
			     asserta(selfOutputPin(X,Y)),
			     readFB(Name,Str).

element(Name,line(X), Str) :- !,
			     asserta(line(X)),
			     readFB(Name,Str).

element(Name,line_begin_x(X,Y), Str) :- !,
			     asserta(line_begin_x(X,Y)),
			     readFB(Name,Str).

element(Name,line_begin_y(X,Y), Str) :- !,
			     asserta(line_begin_y(X,Y)),
			     readFB(Name,Str).

element(Name,line_end_x(X,Y), Str) :- !,
			     asserta(line_end_x(X,Y)),
			     readFB(Name,Str).

element(Name,line_end_y(X,Y), Str) :- !,
			     asserta(line_end_y(X,Y)),
			     readFB(Name,Str).

element(Name,pipeNum(X,Y), Str) :- !,
			     asserta(pipeNum(X,Y)),
			     readFB(Name,Str).

element(Name,wireNum(X,Y), Str) :- !,
			     asserta(wireNum(X,Y)),
			     readFB(Name,Str).

element(Name,arrow(X), Str) :- !,
			     asserta(arrow(X)),
			     readFB(Name,Str).

element(Name,arrow_x(X,Y), Str) :- !,
			     asserta(arrow_x(X,Y)),
			     readFB(Name,Str).

element(Name,arrow_y(X,Y), Str) :- !,
			     asserta(arrow_y(X,Y)),
			     readFB(Name,Str).

element(Name,sinkfd(P,F), Str) :- !,
			     asserta(sinkfd(P,F)),
			     readFB(Name,Str).

element(Name,sourcefd(P,F), Str) :- !,
			     asserta(sourcefd(P,F)),
			     readFB(Name,Str).

element(Name,source(P,F), Str) :- !,
			     asserta(source(P,F)),
			     readFB(Name,Str).

element(Name,npipes(X), Str) :- !,
			     asserta(npipes(X)),
			     readFB(Name,Str).

element(Name,nwires(X), Str) :- !,
			     asserta(nwires(X)),
			     readFB(Name,Str).

element(Name,move_absolute_x(X,Y), Str) :- !,
			     asserta(move_absolute_x(X,Y)),
			     readFB(Name,Str).


element(Name,move_absolute_y(X,Y), Str) :- !,
			     asserta(move_absolute_y(X,Y)),
			     readFB(Name,Str).


element(Name,move_relative_x(X,Y), Str) :- !,
			     asserta(move_relative_x(X,Y)),
			     readFB(Name,Str).

element(Name,move_relative_y(X,Y), Str) :- !,
			     asserta(move_relative_y(X,Y)),
			     readFB(Name,Str).


element(Name,rect(X), Str) :- !,
			     asserta(rect(X)),
			     readFB(Name,Str).

element(Name,ellipse(X), Str) :- !,
			     asserta(ellipse(X)),
			     readFB(Name,Str).

element(Name,dot(X), Str) :- !,
			     asserta(dot(X)),
			     readFB(Name,Str).

element(Name,stroke_relative_x(X,Y), Str) :- !,
			     asserta(stroke_relative_x(X,Y)),
			     readFB(Name,Str).

element(Name,stroke_relative_y(X,Y), Str) :- !,
			     asserta(stroke_relative_y(X,Y)),
			     readFB(Name,Str).


element(Name,stroke_absolute_x(X,Y), Str) :- !,
			     asserta(stroke_absolute_x(X,Y)),
			     readFB(Name,Str).

element(Name,stroke_absolute_y(X,Y), Str) :- !,
			     asserta(stroke_absolute_y(X,Y)),
			     readFB(Name,Str).

element(Name,text(X,Y), Str) :- !,
			     asserta(text(X,Y)),
			     readFB(Name,Str).

element(Name,text_x(X,Y), Str) :- !,
			     asserta(text_x(X,Y)),
			     readFB(Name,Str).

element(Name,text_y(X,Y), Str) :- !,
			     asserta(text_y(X,Y)),
			     readFB(Name,Str).

element(Name,text_w(X,Y), Str) :- !,
			     asserta(text_w(X,Y)),
			     readFB(Name,Str).

element(Name,text_h(X,Y), Str) :- !,
			     asserta(text_h(X,Y)),
			     readFB(Name,Str).

element(Name,join_centerPair(X,Y), Str) :- !,
			     asserta(join_centerPair(X,Y)),
			     readFB(Name,Str).

element(Name,join_distance(X,Y), Str) :- !,
			     asserta(join_distance(X,Y)),
			     readFB(Name,Str).

element(Name,distance_xy(X,Y), Str) :- !,
			     asserta(distance_xy(X,Y)),
			     readFB(Name,Str).



element(Name,centerPair(X,Y), Str) :- !,
			     asserta(centerPair(X,Y)),
			     readFB(Name,Str).
element(Name,distance(X,Y), Str) :- !,
			     asserta(distance(X,Y)),
			     readFB(Name,Str).

element(Name,n_c(X), Str) :- !,
			     asserta(n_c(X)),
			     readFB(Name,Str).

element(Name,indexedSink(X), Str) :- !,
			     asserta(indexedSink(X)),
			     readFB(Name,Str).

element(Name,indexedSource(X), Str) :- !,
			     asserta(indexedSource(X)),
			     readFB(Name,Str).


    
element(_,Term, _) :-
    write(user_error,'failed read '),
    write(user_error,Term),
    nl(user_error).
