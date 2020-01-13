
(in-package :arrowgrams/compiler/ASSIGN-WIRE-NUMBERS-TO-EDGES)

; (:code ASSIGN-WIRE-NUMBERS-TO-EDGES (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/ASSIGN-WIRE-NUMBERS-TO-EDGES::react #'arrowgrams/compiler/ASSIGN-WIRE-NUMBERS-TO-EDGES::first-time)

(defmethod first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
      (:idle
       (if (eq pin :fb)
           (cl-event-passing-user::@set-instance-var self :fb data)
         (if (eq pin :go)
             (progn
               (cl-event-passing-user::@send self :request-fb t)
               (cl-event-passing-user::@set-instance-var self :state :waiting-for-new-fb))
           (cl-event-passing-user::@send
            self
            :error
            (format nil "ASSIGN-WIRE-NUMBERS-TO-EDGES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&assign-wire-numbers-to-edges~%")
             (assign-wire-numbers-to-edges self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "ASSIGN-WIRE-NUMBERS-TO-EDGES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod assign-wire-numbers-to-edges ((self e/part:part))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (cl-event-passing-user::@get-instance-var self :fb)))
        (goal '((:assign_wire_numbers_to_edges_main (:? A)))))
    (let ((result (arrowgrams/compiler/util::run-prolog self goal fb)))
      ;(format *standard-output* "~&counter is ~a result is ~S~%" arrowgrams/compiler::*counter* result))))
      (arrowgrams/compiler/util::asserta self `(:nwires ,arrowgrams/compiler::*counter* nil nil nil nil nil nil nil)))))
