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
           
(defparameter testfb-old
  '(((:roundedrect :id497))
    ((:metadata :id495 :id498))
    ((:ellipse :id568))
    ((:ellipse :id491))
    ((:ellipse :id476))))

(defparameter testfb
  '(((:roundedrect :id497))
    ((:metadata :id495 :id498))
    ((:ellipse :id568))
    ((:ellipse :id491))
    ((:ellipse :id476))
    ((:geometry_h :id589 12))
    ((:geometry_h :id587 12))
    ((:geometry_h :id585 12))
    ((:geometry_h :id583 12))
    ((:geometry_h :id581 12))
    ((:geometry_h :id579 12))
    ((:geometry_h :id577 12))
    ((:geometry_h :id575 12))
    ((:geometry_h :id573 12))
    ((:geometry_h :id571 12))
    ((:geometry_h :id569 12))
    ((:geometry_h :id568 40.0))
    ((:geometry_h :id561 12))
    ((:geometry_h :id559 12))
    ((:geometry_h :id557 12))
    ((:geometry_h :id555 12))
    ((:geometry_h :id553 12))
    ((:geometry_h :id552 80.0))
    ((:geometry_h :id540 12))
    ((:geometry_h :id538 12))
    ((:geometry_h :id536 12))
    ((:geometry_h :id534 12))
    ((:geometry_h :id532 12))
    ((:geometry_h :id531 80.0))
    ((:geometry_h :id509 12))
    ((:geometry_h :id507 12))
    ((:geometry_h :id505 12))
    ((:geometry_h :id504 80.0))
    ((:geometry_h :id498 12))
    ((:geometry_h :id497 22))
    ((:geometry_h :id494 270.0))
    ((:geometry_h :id492 12))
    ((:geometry_h :id491 40.0))
    ((:geometry_h :id489 12))
    ((:geometry_h :id488 80.0))
    ((:geometry_h :id481 12))
    ((:geometry_h :id479 12))
    ((:geometry_h :id477 12))
    ((:geometry_h :id476 40.0))
    ((:geometry_h :id464 12))
    ((:geometry_h :id462 12))
    ((:geometry_h :id460 12))
    ((:geometry_h :id459 80.0))
    ((:geometry_h :id452 12))
    ((:geometry_h :id450 12))
    ((:geometry_h :id449 80.0))
    ((:geometry_h :id437 12))
    ((:geometry_h :id435 12))
    ((:geometry_h :id433 12))
    ((:geometry_h :id431 12))
    ((:geometry_h :id424 12))
    ((:geometry_h :id423 80.0))
    ((:geometry_h :id416 12))
    ((:geometry_h :id415 80.0))
    ((:geometry_h :id408 12))
    ((:geometry_h :id406 12))
    ((:geometry_h :id405 80.0))
    ((:geometry_h :id393 12))
    ((:geometry_h :id391 12))
    ((:geometry_h :id389 12))
    ((:geometry_h :id387 12))
    ((:geometry_h :id385 12))
    ((:geometry_h :id384 80.0))
    ((:geometry_w :id589 13))
    ((:geometry_w :id587 14))
    ((:geometry_w :id585 5))
    ((:geometry_w :id583 21))
    ((:geometry_w :id581 14))
    ((:geometry_w :id579 22))
    ((:geometry_w :id577 17))
    ((:geometry_w :id575 17))
    ((:geometry_w :id573 4))
    ((:geometry_w :id571 9))
    ((:geometry_w :id569 14))
    ((:geometry_w :id568 40.0))
    ((:geometry_w :id561 12))
    ((:geometry_w :id559 8))
    ((:geometry_w :id557 12))
    ((:geometry_w :id555 17))
    ((:geometry_w :id553 24))
    ((:geometry_w :id552 80.0))
    ((:geometry_w :id540 9))
    ((:geometry_w :id538 14))
    ((:geometry_w :id536 14))
    ((:geometry_w :id534 14))
    ((:geometry_w :id532 22))
    ((:geometry_w :id531 80.0))
    ((:geometry_w :id509 8))
    ((:geometry_w :id507 17))
    ((:geometry_w :id505 14))
    ((:geometry_w :id504 80.0))
    ((:geometry_w :id498 10))
    ((:geometry_w :id497 20))
    ((:geometry_w :id494 960.0))
    ((:geometry_w :id492 22))
    ((:geometry_w :id491 40.0))
    ((:geometry_w :id489 18))
    ((:geometry_w :id488 80.0))
    ((:geometry_w :id481 13))
    ((:geometry_w :id479 12))
    ((:geometry_w :id477 13))
    ((:geometry_w :id476 40.0))
    ((:geometry_w :id464 17))
    ((:geometry_w :id462 18))
    ((:geometry_w :id460 24))
    ((:geometry_w :id459 80.0))
    ((:geometry_w :id452 13))
    ((:geometry_w :id450 18))
    ((:geometry_w :id449 80.0))
    ((:geometry_w :id437 8))
    ((:geometry_w :id435 10))
    ((:geometry_w :id433 4))
    ((:geometry_w :id431 4))
    ((:geometry_w :id424 8))
    ((:geometry_w :id423 80.0))
    ((:geometry_w :id416 9))
    ((:geometry_w :id415 80.0))
    ((:geometry_w :id408 3))
    ((:geometry_w :id406 17))
    ((:geometry_w :id405 80.0))
    ((:geometry_w :id393 7))
    ((:geometry_w :id391 13))
    ((:geometry_w :id389 10))
    ((:geometry_w :id387 11))
    ((:geometry_w :id385 19))
    ((:geometry_w :id384 80.0))
    ((:geometry_left_x :id552 3585.0))
    ((:geometry_left_x :id531 4145.0))
    ((:geometry_left_x :id504 3585.0))
    ((:geometry_left_x :id497 3514.5))
    ((:geometry_left_x :id494 3045.0))
    ((:geometry_left_x :id488 4365.0))
    ((:geometry_left_x :id459 2930.0))
    ((:geometry_left_x :id449 3585.0))
    ((:geometry_left_x :id423 3175.0))
    ((:geometry_left_x :id415 4055.0))
    ((:geometry_left_x :id405 3585.0))
    ((:geometry_left_x :id384 3585.0))
    ((:geometry_top_y :id589 163.5))
    ((:geometry_top_y :id587 853.5))
    ((:geometry_top_y :id585 253.5))
    ((:geometry_top_y :id583 223.5))
    ((:geometry_top_y :id581 248.5))
    ((:geometry_top_y :id579 298.5))
    ((:geometry_top_y :id577 318.5))
    ((:geometry_top_y :id575 293.5))
    ((:geometry_top_y :id573 358.5))
    ((:geometry_top_y :id571 248.5))
    ((:geometry_top_y :id569 43.5))
    ((:geometry_top_y :id561 973.5))
    ((:geometry_top_y :id559 913.5))
    ((:geometry_top_y :id557 913.5))
    ((:geometry_top_y :id555 813.5))
    ((:geometry_top_y :id553 863.5))
    ((:geometry_top_y :id552 820.0))
    ((:geometry_top_y :id540 963.5))
    ((:geometry_top_y :id538 358.5))
    ((:geometry_top_y :id536 338.5))
    ((:geometry_top_y :id534 683.5))
    ((:geometry_top_y :id532 1023.5))
    ((:geometry_top_y :id531 980.0))
    ((:geometry_top_y :id509 743.5))
    ((:geometry_top_y :id507 633.5))
    ((:geometry_top_y :id505 693.5))
    ((:geometry_top_y :id504 650.0))
    ((:geometry_top_y :id498 1408.5))
    ((:geometry_top_y :id497 1398.5))
    ((:geometry_top_y :id494 1270.0))
    ((:geometry_top_y :id492 303.5))
    ((:geometry_top_y :id489 303.5))
    ((:geometry_top_y :id488 260.0))
    ((:geometry_top_y :id481 1083.5))
    ((:geometry_top_y :id479 293.5))
    ((:geometry_top_y :id477 173.5))
    ((:geometry_top_y :id464 413.5))
    ((:geometry_top_y :id462 1033.5))
    ((:geometry_top_y :id460 353.5))
    ((:geometry_top_y :id459 310.0))
    ((:geometry_top_y :id452 973.5))
    ((:geometry_top_y :id450 1023.5))
    ((:geometry_top_y :id449 980.0))
    ((:geometry_top_y :id437 363.5))
    ((:geometry_top_y :id435 373.5))
    ((:geometry_top_y :id433 323.5))
    ((:geometry_top_y :id431 283.5))
    ((:geometry_top_y :id424 303.5))
    ((:geometry_top_y :id423 260.0))
    ((:geometry_top_y :id416 303.5))
    ((:geometry_top_y :id415 260.0))
    ((:geometry_top_y :id408 163.5))
    ((:geometry_top_y :id406 173.5))
    ((:geometry_top_y :id405 130.0))
    ((:geometry_top_y :id393 483.5))
    ((:geometry_top_y :id391 553.5))
    ((:geometry_top_y :id389 513.5))
    ((:geometry_top_y :id387 443.5))
    ((:geometry_top_y :id385 493.5))
    ((:geometry_top_y :id384 450.0))
    ((:geometry_center_x :id589 3704.5))
    ((:geometry_center_x :id587 3714.5))
    ((:geometry_center_x :id585 3234.5))
    ((:geometry_center_x :id583 3645.5))
    ((:geometry_center_x :id581 4414.5))
    ((:geometry_center_x :id579 4514.5))
    ((:geometry_center_x :id577 4314.5))
    ((:geometry_center_x :id575 4184.5))
    ((:geometry_center_x :id573 4099.5))
    ((:geometry_center_x :id571 4132.0))
    ((:geometry_center_x :id569 4404.5))
    ((:geometry_center_x :id568 4405.0))
    ((:geometry_center_x :id561 3680.5))
    ((:geometry_center_x :id559 3584.5))
    ((:geometry_center_x :id557 3654.5))
    ((:geometry_center_x :id555 3645.5))
    ((:geometry_center_x :id553 3624.5))
    ((:geometry_center_x :id540 4214.5))
    ((:geometry_center_x :id538 4454.5))
    ((:geometry_center_x :id536 3054.5))
    ((:geometry_center_x :id534 3714.5))
    ((:geometry_center_x :id532 4184.5))
    ((:geometry_center_x :id509 3664.5))
    ((:geometry_center_x :id507 3620.5))
    ((:geometry_center_x :id505 3624.5))
    ((:geometry_center_x :id498 3529.5))
    ((:geometry_center_x :id492 4664.5))
    ((:geometry_center_x :id491 4665.0))
    ((:geometry_center_x :id489 4404.5))
    ((:geometry_center_x :id481 3645.5))
    ((:geometry_center_x :id479 3002.0))
    ((:geometry_center_x :id477 3064.5))
    ((:geometry_center_x :id476 3065.0))
    ((:geometry_center_x :id464 2919.5))
    ((:geometry_center_x :id462 3529.5))
    ((:geometry_center_x :id460 2969.5))
    ((:geometry_center_x :id452 3594.5))
    ((:geometry_center_x :id450 3624.5))
    ((:geometry_center_x :id437 3159.5))
    ((:geometry_center_x :id435 3269.5))
    ((:geometry_center_x :id433 3284.5))
    ((:geometry_center_x :id431 4034.5))
    ((:geometry_center_x :id424 3214.5))
    ((:geometry_center_x :id416 4094.5))
    ((:geometry_center_x :id408 3554.5))
    ((:geometry_center_x :id406 3624.5))
    ((:geometry_center_x :id393 3704.5))
    ((:geometry_center_x :id391 3664.5))
    ((:geometry_center_x :id389 3554.5))
    ((:geometry_center_x :id387 3594.5))
    ((:geometry_center_x :id385 3624.5))
    ((:geometry_center_y :id568 40.0))
    ((:geometry_center_y :id491 300.0))
    ((:geometry_center_y :id476 170.0))))

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

