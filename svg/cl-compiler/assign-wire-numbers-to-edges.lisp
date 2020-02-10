
(in-package :arrowgrams/compiler)
(defclass assign-wire-numbers-to-edges (e/part:part) ())
(defmethod e/part:busy-p ((self assign-wire-numbers-to-edges)) (call-next-method))

; (:code ASSIGN-WIRE-NUMBERS-TO-EDGES (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self assign-wire-numbers-to-edges))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self assign-wire-numbers-to-edges) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (@get self :state)
      (:idle
       (if (eq pin :fb)
           (@set self :fb data)
         (if (eq pin :go)
             (progn
               (@send self :request-fb t)
               (@set self :state :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "ASSIGN-WIRE-NUMBERS-TO-EDGES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&assign-wire-numbers-to-edges~%")
             (assign-wire-numbers-to-edges self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "ASSIGN-WIRE-NUMBERS-TO-EDGES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method)))

(defmethod assign-wire-numbers-to-edges ((self assign-wire-numbers-to-edges))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:assign_wire_numbers_to_edges_main (:? A)))))
    (let ((result (arrowgrams/compiler/util::run-prolog self goal fb)))
      ;(format *standard-output* "~&counter is ~a result is ~S~%" arrowgrams/compiler::*counter* result))))
      (arrowgrams/compiler/util::asserta self `(:nwires ,arrowgrams/compiler::*counter*) nil nil nil nil nil nil nil))))
