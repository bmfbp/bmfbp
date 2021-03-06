(in-package :arrowgrams/compiler)

(defclass demux (compiler-part)
  ((counter :accessor counter)))

(defmethod e/part:busy-p ((self demux)) (call-next-method))
(defmethod e/part:clone ((self demux)) (call-next-method))

(defmethod e/part:first-time ((self demux))
  (setf (counter self) 0)
  (call-next-method))

(defmethod e/part:react ((self demux) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (state self)
      (:idle
       (if  (eq pin :go)
           (progn
             (incf (counter self))
             (ecase (counter self)
               (1 (@send self (e/part::get-output-pin self :o1) T))
               (2 (@send self (e/part::get-output-pin self :o2) T))
               (3 (@send self (e/part::get-output-pin self :o3) T))
               (4 (@send self (e/part::get-output-pin self :o4) T))
               (5 (@send self (e/part::get-output-pin self :o5) T))
               (6 (@send self (e/part::get-output-pin self :o6) T))
               (7 (@send self (e/part::get-output-pin self :o7) T))
               (8 (@send self (e/part::get-output-pin self :o8) T))
               (9 (@send self (e/part::get-output-pin self :o9) T))
               (10 (@send self (e/part::get-output-pin self :o10) T))
               (11 (@send self (e/part::get-output-pin self :o11) T))
               (12 (@send self (e/part::get-output-pin self :o12) T))
               (13 (@send self (e/part::get-output-pin self :o13) T))
               (14 (@send self (e/part::get-output-pin self :o14) T))
               (15 (@send self (e/part::get-output-pin self :o15) T))
               (16 (@send self (e/part::get-output-pin self :o16) T))
               (17 (@send self (e/part::get-output-pin self :o17) T))
               (18 (@send self (e/part::get-output-pin self :o18) T))
               (19 (@send self (e/part::get-output-pin self :o19) T))
               (20 (@send self (e/part::get-output-pin self :o20) T))
               (21 (@send self (e/part::get-output-pin self :o21) T))
               (22 (@send self (e/part::get-output-pin self :o22) T))
               (23 (@send self (e/part::get-output-pin self :o23) T))
               (24 (@send self (e/part::get-output-pin self :o24) T))
               (25 (@send self (e/part::get-output-pin self :o25) T))
               (26 (@send self (e/part::get-output-pin self :o26) T))
               (27 (@send self (e/part::get-output-pin self :o27) T))
               (28 (@send self (e/part::get-output-pin self :o28) T))
               (29 (@send self (e/part::get-output-pin self :o29) T))
               (30 
		(e/part::first-time self)
		(@send self (e/part::get-output-pin self :finished-pipeline) T))))
         (@send
          self
          :error
          (format nil "DEMUX in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))))
