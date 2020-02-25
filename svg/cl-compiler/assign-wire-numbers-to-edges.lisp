
(in-package :arrowgrams/compiler)
(defclass assign-wire-numbers-to-edges (compiler-part) ())
(defmethod e/part:busy-p ((self assign-wire-numbers-to-edges)) (call-next-method))
(defmethod e/part:clone ((self assign-wire-numbers-to-edges)) (call-next-method))

; (:code ASSIGN-WIRE-NUMBERS-TO-EDGES (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self assign-wire-numbers-to-edges))
  (call-next-method))

(defmethod e/part:react ((self assign-wire-numbers-to-edges) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (state self)
      (:idle
       (if (eq pin :fb)
           (setf (fb self) data)
         (if (eq pin :go)
             (progn
               (@send self :request-fb t)
               (setf (state self) :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "ASSIGN-WIRE-NUMBERS-TO-EDGES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (format *standard-output* "~&assign-wire-numbers-to-edges~%")
             (assign-wire-numbers-to-edges self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "ASSIGN-WIRE-NUMBERS-TO-EDGES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod assign-wire-numbers-to-edges ((self assign-wire-numbers-to-edges))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (fb self)))
        (goal '((:assign_wire_numbers_to_edges_main (:? A)))))
    (let ((result (run-prolog self goal fb)))
      ;(format *standard-output* "~&counter is ~a result is ~S~%" arrowgrams/compiler::*counter* result))))
      (asserta self `(:nwires ,*counter*) nil nil nil nil nil nil nil))))
