
(in-package :arrowgrams/compiler)
(defclass calculate-distances (compiler-part) ())
(defmethod e/part:busy-p ((self calculate-distances)) (call-next-method))
(defmethod e/part:clone ((self calculate-distances)) (call-next-method))

; (:code CALCULATE-DISTANCES (:fb :go) (:add-fact :done :request-fb :error)

(defmethod e/part:first-time ((self calculate-distances))
  (call-next-method))

(defmethod e/part:react ((self calculate-distances) e)
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
            (format nil "CALCULATE-DISTANCES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (format *standard-output* "~&calculate-distances COMMENTED OUT~%")
             ;(calculate-distances self)
             (@send self :done t)
             (e/part::first-time self))
         (@send
          self
          :error
          (format nil "CALCULATE-DISTANCES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod calculate-distances ((self calculate-distances))
  (let ((fb
         (append
          *rules*
          (fb self)))
        (goal '((:calculate_distances_main))))
    (run-prolog self goal fb)))
