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
            (print(car c) stream))))))))

(defun fetch-value (var alist)
  (let ((cell (assoc var alist)))
    (when cell
      (cdr cell))))

(defun create-bb (id x y right bottom)
      (add-clause `((bounding-box-left ,id ,x)))
      (add-clause `((bounding-box-top ,id ,y)))
      (add-clause `((bounding-box-right ,id ,right)))
      (add-clause `((bounding-box-bottom ,id ,bottom))))
    
(defun create-rect-bb (alist)
  (let ((x (fetch-value '?x alist))
        (y (fetch-value '?y alist)) 
        (w (fetch-value '?w alist)) 
        (h (fetch-value '?h alist))
        (id (fetch-value '?r alist)))
    (let ((right (+ x w))
          (bottom (+ y h)))
      (create-bb id x y right bottom))))

(defun make-bounding-boxes-for-rectangles ()
  (let ((rect-list (prove-all '((rect ?id)
                                (geometry-top-y ?id ?Y)
                                (geometry-left-x ?id ?X)
                                (geometry-w ?id ?W)
                                (geometry-h ?id ?H))
                              no-bindings)))
    (format *error-output* "~&rect-list=~S" (length rect-list))
    (mapc #'(lambda (alist)
              (create-rect-bb alist))
          rect-list)))

(defun make-bounding-boxes-for-speech-bubbles ()
  (let ((speech-list (prove-all '((speech ?id)
                                (geometry-top-y ?id ?Y)
                                (geometry-left-x ?id ?X)
                                (geometry-w ?id ?W)
                                (geometry-h ?id ?H))
                              no-bindings)))
    (format *error-output* "~&speech-list=~S" (length speech-list))
    (mapc #'(lambda (alist)
              (create-rect-bb alist))
          speech-list)))


(defun create-text-bb (alist)
  (let ((x (fetch-value '?x alist))
        (y (fetch-value '?y alist)) 
        (w (fetch-value '?w alist)) 
        (h (fetch-value '?h alist))
        (id (fetch-value '?id alist)))
    (let ((right (+ x w))
          (bottom (+ y h))
	  (left (- x w))
	  (top (- y h)))
      (create-bb id left top right bottom))))
       
(defun make-bounding-boxes-for-text ()
  (let ((text-list (prove-all '((text ?id ?str)
                                (geometry-top-y ?id ?Y)
                                (geometry-center-x ?id ?X)
                                (geometry-w ?id ?W)
                                (geometry-h ?id ?H))
                              no-bindings)))
    (format *error-output* "~&text-list=~S" (length text-list))
    (mapc #'(lambda (alist)
              (create-text-bb alist))
          text-list)))


(defun create-ellipse-bb (alist)
  (let ((x (fetch-value '?x alist))
        (y (fetch-value '?y alist)) 
        (w (fetch-value '?w alist)) 
        (h (fetch-value '?h alist))
        (id (fetch-value '?id alist)))
    (let ((right (+ x w))
          (bottom (+ y h))
	  (left (- x w))
	  (top (- y h)))
      (create-bb id left top right bottom))))
       
(defun make-bounding-boxes-for-ellipses ()
  (let ((ellipse-list (prove-all '((id ?id)
                                (geometry-center-y ?id ?Y)
                                (geometry-center-x ?id ?X)
                                (geometry-w ?id ?W)
                                (geometry-h ?id ?H))
                              no-bindings)))
    (format *error-output* "~&ellipse-list=~S" (length ellipse-list))
    (mapc #'(lambda (alist)
              (create-ellipse-bb alist))
          ellipse-list)))


(defun bounding-boxes ()
  (make-bounding-boxes-for-rectangles)
  (make-bounding-boxes-for-text)
  (make-bounding-boxes-for-speech-bubbles)
  (make-bounding-boxes-for-ellipses))

#+lispworks
(defun main ()
    (let ((in *standard-input*)
	  (out *standard-output*))
      (readfb in)
      (format *error-output* "~&running~%")
      (bounding-boxes)
      (writefb out)))

#+lispworks
(defun deb ()
  (with-open-file (in "~/projects/bmfbp/svg/js-compiler/temp5.lisp")
    (readfb in)
    (format *error-output* "~&running~%")
    (bounding-boxes)))

#+SBCL
(ASSERT NIL)


#|
:- INITIALIZATION(MAIN).
:- INCLUDE('HEAD').

MAIN :-
    READFB(USER_INPUT), 
    CREATEBOUNDINGBOXES,
    WRITEFB,
    HALT.

CREATEBOUNDINGBOXES :-
CONDITIONALCREATEELLIpseBB,
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