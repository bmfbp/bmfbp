(ql:quickload :paip-prolog)
(ql:quickload :loops)





(defun readfb (stream)
  (flet ((read1 ()
           (read stream nil 'eof)))
    (clear-db)
    (let ((clause (read1)))
      (@:loop
        (@:exit-when (eq 'eof clause))
        (add-clause (replace-?-vars (list clause)))
        (setf clause (read1))))))

(defun writefb (stream)
  (let ((preds *db-predicates*))
    (@:loop
     (@:exit-when (null preds))
     (let ((p (pop preds)))
       (let ((clauses (get p 'clauses)))
         (@:loop
          (@:exit-when (null clauses))
          (let ((c (pop clauses)))
            (assert (= 1 (length c)))
            (write (car c) :stream stream))))))))

(defun fetch-value (var alist)
  (let ((cell (assoc var alist)))
    (when cell
      (cdr cell))))

(defun create-rect-bb (alist)
  (let ((x (fetch-value '?x alist))
        (y (fetch-value '?y alist)) 
        (w (fetch-value '?w alist)) 
        (h (fetch-value '?h alist))
        (id (fetch-value '?r alist)))
    (assert (not (null id)))
    (assert (not (null x)))
    (assert (not (null y)))
    (assert (not (null w)))
    (assert (not (null h)))
    (format *standard-output* "~&id=~S x=~S y=~S w=~S h=~S~%" id x y w h)
    (let ((right (+ x w))
          (bottom (+ y h)))
      (add-clause `((bounding-box-left ,id ,x)))
      (add-clause `((bounding-box-top ,id ,y)))
      (add-clause `((bounding-box-right ,id ,right)))
      (add-clause `((bounding-box-bottom ,id ,bottom))))))
    
        
(defun main ()
  (with-open-file (in "~/projects/bmfbp/svg/lparts/fb5.lisp" :direction :input)
    (with-open-file (out "~/projects/bmfbp/svg/lparts/fb6.lisp" :direction :output :if-exists :supersede)
      (readfb in)
      (let ((rect-list (prove-all '((rect ?R)
                                    (geometry-top-y ?R ?Y)
                                    (geometry-left-x ?R ?X)
                                    (geometry-w ?R ?W)
                                    (geometry-h ?R ?H))
                                  no-bindings)))
        (format *standard-output* "~&rect-list=~S" rect-list)
        (mapc #'(lambda (alist)
                  (create-rect-bb alist))
              rect-list)
        (writefb out)))))



#|
:- initialization(main).
:- include('head').

main :-
    readFB(user_input), 
    createBoundingBoxes,
    writeFB,
    halt.

createBoundingBoxes :-
    conditionalCreateEllipseBB,
    condRect,
    condSpeech,
    condText.

condRect :-
    forall(rect(ID), createRectBoundingBox(ID)).
condRect :-
    true.

condSpeech :-
    forall(speechbubble(ID), createRectBoundingBox(ID)).
condSpeech :-
    true.

condText :-
    forall(text(ID,_), createTextBoundingBox(ID)).
condText :-
    true.

conditionalCreateEllipseBB:-
    ellipse(_),
    forall(ellipse(ID), createEllipseBoundingBox(ID)).

conditionalCreateEllipseBB :- % for pre-ellipse code  
    true.

createRectBoundingBox(ID) :-
    geometry_left_x(ID,X),
    geometry_top_y(ID, Y),
    geometry_w(ID, Width),
    geometry_h(ID, Height),
    asserta(bounding_box_left(ID,X)),
    asserta(bounding_box_top(ID,Y)),
    Right is X + Width,
    Bottom is Y + Height,
    asserta(bounding_box_right(ID,Right)),
    asserta(bounding_box_bottom(ID,Bottom)).

createTextBoundingBox(ID) :-
    geometry_center_x(ID,CX),
    geometry_top_y(ID, Y),
    geometry_w(ID, HalfWidth),
    geometry_h(ID, Height),
    X is (CX - HalfWidth),
    asserta(bounding_box_left(ID,X)),
    asserta(bounding_box_top(ID,Y)),
    Right is CX + HalfWidth,
    Bottom is Y + Height,
    asserta(bounding_box_right(ID,Right)),
    asserta(bounding_box_bottom(ID,Bottom)).

createEllipseBoundingBox(ID) :-
    geometry_center_x(ID,CX),
    geometry_center_y(ID,CY),
    geometry_w(ID,HalfWidth),
    geometry_h(ID,HalfHeight),
    Left is CX - HalfWidth,
    Top is CY - HalfHeight,
    asserta(bounding_box_left(ID,Left)),
    asserta(bounding_box_top(ID,Top)),
    Right is CX + HalfWidth,
    Bottom is CY + HalfHeight,
    asserta(bounding_box_right(ID,Right)),
    asserta(bounding_box_bottom(ID,Bottom)).

:- include('tail').
|#
