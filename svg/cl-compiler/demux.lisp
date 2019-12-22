(in-package :arrowgrams/compiler/demux)

; (:code demux (:go) (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 :error) #'arrowgrams/compiler/demux::react #'arrowgrams/compiler/demux::first-time)


(defparameter *counter* 0)

(defmethod first-time ((self e/part:part))
  (setf *counter* 0)
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
      (:idle
       (if  (eq pin :go)
           (progn
             (incf *counter*)
             (ecase *counter*
               (1 (cl-event-passing-user::@send self (e/part::get-output-pin self 1) T))
               (2 (cl-event-passing-user::@send self (e/part::get-output-pin self 2) T))
               (3 (cl-event-passing-user::@send self (e/part::get-output-pin self 3) T))
               (4 (cl-event-passing-user::@send self (e/part::get-output-pin self 4) T))
               (5 (cl-event-passing-user::@send self (e/part::get-output-pin self 5) T))
               (6 (cl-event-passing-user::@send self (e/part::get-output-pin self 6) T))
               (7 (cl-event-passing-user::@send self (e/part::get-output-pin self 7) T))
               (8 (cl-event-passing-user::@send self (e/part::get-output-pin self 8) T))
               (9 (cl-event-passing-user::@send self (e/part::get-output-pin self 9) T))
               (10 (cl-event-passing-user::@send self (e/part::get-output-pin self 10) T))
               (11 (cl-event-passing-user::@send self (e/part::get-output-pin self 11) T))
               (12 (cl-event-passing-user::@send self (e/part::get-output-pin self 12) T))
               (13 (cl-event-passing-user::@send self (e/part::get-output-pin self 13) T))
               (14 (cl-event-passing-user::@send self (e/part::get-output-pin self 14) T))
               (15 (cl-event-passing-user::@send self (e/part::get-output-pin self 15) T))
               (16 (cl-event-passing-user::@send self (e/part::get-output-pin self 16) T))
               (17 (cl-event-passing-user::@send self (e/part::get-output-pin self 17) T))
               (18 (cl-event-passing-user::@send self (e/part::get-output-pin self 18) T))
               (19 (cl-event-passing-user::@send self (e/part::get-output-pin self 19) T))
               (20 (cl-event-passing-user::@send self (e/part::get-output-pin self 20) T))
               (21 (cl-event-passing-user::@send self (e/part::get-output-pin self 21) T))
               (22 (cl-event-passing-user::@send self (e/part::get-output-pin self 22) T))
               (23 (cl-event-passing-user::@send self (e/part::get-output-pin self 23) T))
               (24 (cl-event-passing-user::@send self (e/part::get-output-pin self 24) T))
               (25 (cl-event-passing-user::@send self (e/part::get-output-pin self 25) T))
               (26 (cl-event-passing-user::@send self (e/part::get-output-pin self 26) T))
               (27 (cl-event-passing-user::@send self (e/part::get-output-pin self 27) T))))
         (cl-event-passing-user::@send
            self
            :error
            (format nil "BOUNDING-BOXES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))))
             
