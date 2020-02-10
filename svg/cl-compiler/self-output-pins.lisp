
(in-package :arrowgrams/compiler)
(defclass self-output-pins (e/part:part) ())
(defmethod e/part:busy-p ((self self-output-pins)) (call-next-method))

; (:code SELF-OUTPUT-PINS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self self-output-pins))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self self-output-pins) e)
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
            (format nil "SELF-OUTPUT-PINS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&self-output-pins~%")
             (self-output-pins self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "SELF-OUTPUT-PINS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method)))

(defmethod self-output-pins ((self self-output-pins))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:sink_ellipse (:? E)))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
