(ql:quickload :paip-prolog)
(ql:quickload :loops)

#+nil
(defun assert-facts ()
  (<- (arrow id414))
  (<- (arrow id397))
  (<- (arrow id386))
  (<- (arrow id378))
  (<- (arrow id373))
  (<- (arrow-x id414 9810))
  (<- (arrow-x id397 14046300000000001))
  (<- (arrow-x id386 93463))
  (<- (arrow-x id378 9810))
  (<- (arrow-x id373 11946300000000001))
  (<- (arrow-y id414 45363))
  (<- (arrow-y id397 400))
  (<- (arrow-y id386 400))
  (<- (arrow-y id378 21363))
  (<- (arrow-y id373 400))
  (<- (rect id426))
  (<- (rect id415))
  (<- (rect id398))
  (<- (rect id379))
  (<- (roundedrect id429))
  (<- (metadata id427 id430))
  (<- (dot id423))
  (<- (dot id418))
  (<- (dot id403))
  (<- (line id410))
  (<- (line id393))
  (<- (line id382))
  (<- (line id374))
  (<- (line id369))
  (<- (text id430 struidG428))
  (<- (text id424 struidG425))
  (<- (text id421 struidG422))
  (<- (text id419 struidG420))
  (<- (text id416 struidG417))
  (<- (text id408 struidG409))
  (<- (text id406 struidG407))
  (<- (text id404 struidG405))
  (<- (text id401 struidG402))
  (<- (text id399 struidG400))
  (<- (text id391 struidG392))
  (<- (text id389 struidG390))
  (<- (text id387 struidG388))
  (<- (text id380 struidG381))
  (<- (bounding-box-left id412 970))
  (<- (bounding-box-left id411 9610))
  (<- (bounding-box-left id395 1390))
  (<- (bounding-box-left id394 12610))
  (<- (bounding-box-left id384 920))
  (<- (bounding-box-left id383 7310))
  (<- (bounding-box-left id376 970))
  (<- (bounding-box-left id375 9610))
  (<- (bounding-box-left id371 1180))
  (<- (bounding-box-left id370 10010))
  (<- (bounding-box-top id412 440))
  (<- (bounding-box-top id411 2800))
  (<- (bounding-box-top id395 20))
  (<- (bounding-box-top id394 200))
  (<- (bounding-box-top id384 20))
  (<- (bounding-box-top id383 200))
  (<- (bounding-box-top id376 200))
  (<- (bounding-box-top id375 600))
  (<- (bounding-box-top id371 20))
  (<- (bounding-box-top id370 200))
  (<- (bounding-box-right id412 1010))
  (<- (bounding-box-right id411 10010))
  (<- (bounding-box-right id395 1430))
  (<- (bounding-box-right id394 13010))
  (<- (bounding-box-right id384 960))
  (<- (bounding-box-right id383 7710))
  (<- (bounding-box-right id376 1010))
  (<- (bounding-box-right id375 10010))
  (<- (bounding-box-right id371 1220))
  (<- (bounding-box-right id370 10410))
  (<- (bounding-box-bottom id412 480))
  (<- (bounding-box-bottom id411 3200))
  (<- (bounding-box-bottom id395 60))
  (<- (bounding-box-bottom id394 600))
  (<- (bounding-box-bottom id384 60))
  (<- (bounding-box-bottom id383 600))
  (<- (bounding-box-bottom id376 240))
  (<- (bounding-box-bottom id375 1000))
  (<- (bounding-box-bottom id371 60))
  (<- (bounding-box-bottom id370 600))
  (<- (component compile-composites))
  (<- (edge id413))
  (<- (edge id396))
  (<- (edge id385))
  (<- (edge id377))
  (<- (edge id372))
  (<- (eltype id429 roundedrect))
  (<- (eltype id427 metadata))
  (<- (eltype id426 box))
  (<- (eltype id423 dot))
  (<- (eltype id418 dot))
  (<- (eltype id415 box))
  (<- (eltype id412 port))
  (<- (eltype id411 port))
  (<- (eltype id403 dot))
  (<- (eltype id398 box))
  (<- (eltype id395 port))
  (<- (eltype id394 port))
  (<- (eltype id384 port))
  (<- (eltype id383 port))
  (<- (eltype id379 box))
  (<- (eltype id376 port))
  (<- (eltype id375 port))
  (<- (eltype id371 port))
  (<- (eltype id370 port))
  (<- (geometry-h id430 12))
  (<- (geometry-h id429 22))
  (<- (geometry-h id426 2300))
  (<- (geometry-h id424 12))
  (<- (geometry-h id423 400))
  (<- (geometry-h id421 12))
  (<- (geometry-h id419 12))
  (<- (geometry-h id418 400))
  (<- (geometry-h id416 12))
  (<- (geometry-h id415 800))
  (<- (geometry-h id408 12))
  (<- (geometry-h id406 12))
  (<- (geometry-h id404 12))
  (<- (geometry-h id403 400))
  (<- (geometry-h id401 12))
  (<- (geometry-h id399 12))
  (<- (geometry-h id398 800))
  (<- (geometry-h id391 12))
  (<- (geometry-h id389 12))
  (<- (geometry-h id387 12))
  (<- (geometry-h id380 12))
  (<- (geometry-h id379 800))
  (<- (geometry-w id430 10))
  (<- (geometry-w id429 20))
  (<- (geometry-w id426 9800))
  (<- (geometry-w id424 13))
  (<- (geometry-w id423 400))
  (<- (geometry-w id421 13))
  (<- (geometry-w id419 21))
  (<- (geometry-w id418 400))
  (<- (geometry-w id416 19))
  (<- (geometry-w id415 800))
  (<- (geometry-w id408 7))
  (<- (geometry-w id406 4))
  (<- (geometry-w id404 3))
  (<- (geometry-w id403 400))
  (<- (geometry-w id401 7))
  (<- (geometry-w id399 19))
  (<- (geometry-w id398 800))
  (<- (geometry-w id391 7))
  (<- (geometry-w id389 22))
  (<- (geometry-w id387 11))
  (<- (geometry-w id380 13))
  (<- (geometry-w id379 800))
  (<- (geometry-left-x id429 11705))
  (<- (geometry-left-x id426 6910))
  (<- (geometry-left-x id415 9410))
  (<- (geometry-left-x id398 12010))
  (<- (geometry-left-x id379 9410))
  (<- (geometry-top-y id430 7285))
  (<- (geometry-top-y id429 7185))
  (<- (geometry-top-y id426 6100))
  (<- (geometry-top-y id424 435))
  (<- (geometry-top-y id423 400))
  (<- (geometry-top-y id421 335))
  (<- (geometry-top-y id419 5035))
  (<- (geometry-top-y id418 5000))
  (<- (geometry-top-y id416 2635))
  (<- (geometry-top-y id415 2200))
  (<- (geometry-top-y id408 3135))
  (<- (geometry-top-y id406 2035))
  (<- (geometry-top-y id404 435))
  (<- (geometry-top-y id403 400))
  (<- (geometry-top-y id401 335))
  (<- (geometry-top-y id399 435))
  (<- (geometry-top-y id398 00))
  (<- (geometry-top-y id391 335))
  (<- (geometry-top-y id389 1035))
  (<- (geometry-top-y id387 335))
  (<- (geometry-top-y id380 435))
  (<- (geometry-top-y id379 00))
  (<- (geometry-center-x id430 11855))
  (<- (geometry-center-x id424 14505))
  (<- (geometry-center-x id423 14510))
  (<- (geometry-center-x id421 13205))
  (<- (geometry-center-x id419 9805))
  (<- (geometry-center-x id418 9810))
  (<- (geometry-center-x id416 9805))
  (<- (geometry-center-x id408 10005))
  (<- (geometry-center-x id406 9605))
  (<- (geometry-center-x id404 7105))
  (<- (geometry-center-x id403 7110))
  (<- (geometry-center-x id401 11755))
  (<- (geometry-center-x id399 12405))
  (<- (geometry-center-x id391 10505))
  (<- (geometry-center-x id389 9955))
  (<- (geometry-center-x id387 9055))
  (<- (geometry-center-x id380 9805))
  (<- (used id430))
  (<- (port id412))
  (<- (port id411))
  (<- (port id395))
  (<- (port id394))
  (<- (port id384))
  (<- (port id383))
  (<- (port id376))
  (<- (port id375))
  (<- (port id371))
  (<- (port id370))
  (<- (source id413 id411))
  (<- (source id396 id394))
  (<- (source id385 id383))
  (<- (source id377 id375))
  (<- (source id372 id370))
  (<- (sink id413 id412))
  (<- (sink id396 id395))
  (<- (sink id385 id384))
  (<- (sink id377 id376))
  (<- (sink id372 id371)))



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
