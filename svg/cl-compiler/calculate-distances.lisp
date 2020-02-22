
(in-package :arrowgrams/compiler)
(defclass calculate-distances (e/part:code) ())
(defmethod e/part:busy-p ((self calculate-distances)) (call-next-method))
(defmethod e/part:clone ((self calculate-distances)) (call-next-method))

; (:code CALCULATE-DISTANCES (:fb :go) (:add-fact :done :request-fb :error)

(defmethod e/part:first-time ((self calculate-distances))
  (@set self :state :idle)
  )

(defmethod e/part:react ((self calculate-distances) e)
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
            (format nil "CALCULATE-DISTANCES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&calculate-distances COMMENTED OUT~%")
             ;(calculate-distances self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "CALCULATE-DISTANCES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod calculate-distances ((self calculate-distances))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:calculate_distances_main))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
