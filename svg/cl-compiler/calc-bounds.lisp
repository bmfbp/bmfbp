(in-package :arrowgrams/compiler/calc-bounds)

; (:code reader (:fb-as-list) (:new-fb-as-list :error)
;   #'arrowgrams/compiler/bounding-boxes::react
;   #'arrowgrams/compiler/bounding-boxes::first-time)



#|
# original V1 version in gprolog:

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

(defmethod first-time ((self e/part:part))
  ;; nothing
  )

(defmethod react ((self e/part:part) (e e/event:event))
  (assert nil)
  #+nil(let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (let ((oldfb data))
      (e/part::ensure-valid-input-pin self pin)
      (ecase pin
        (:fb-as-list
         ;; when we get an fb, we are being told to process it, then output the result (a new fb) to :new-fb-as-list
         (let ((newfb (create-bounding-boxes self oldfb))))))))
  )
           
(defparameter testfb
  '(((:roundedrect :id497))
    ((:metadata :id495 :id498))
    ((:ellipse :id568))
    ((:ellipse :id491))
    ((:ellipse :id476))))

(defmethod create-bounding-boxes ((self e/part:part) fb)
  (let ((newfb (create-bounding-boxes-for-ellipses self fb)))
    newfb))

(defmethod create-bounding-boxes-for-ellipses ((self e/part:part) fb)
  (assert nil)
  #+nil(let ((goals '((:ellipse (:? ID))
                      (:geometry_center_x (:? ID) (:? CX))
                      (:geometry_center_y (:? ID) (:? CY))
                      (:geometry_w (:? ID) (:? HalfW))
                      (:geometry_h (:? ID) (:? HalfH)))))
         (let ((matches (find-matches goals fb)))))
  )


(defun find-matches (goals fb)
    (cl-holm-prolog::prove7 '() goals fb cl-holm-prolog::empty 1 '() nil))

(defun ftest-old ()
  (let ((goals '((:ellipse (:? id))))
        (fb (aa::@get-instance-var
             (second (e/part::internal-parts arrowgrams/compiler::*top*))
             :factbase)))
    (format *standard-output* "~%length of fb ~a~%" (length fb))
    (find-matches goals fb)))

(defun ftest ()
  (let ((goals '((:ellipse (:? id))))
        (fb testfb))
    (format *standard-output* "~%length of fb ~a~%" (length fb))
    (find-matches goals fb)))

