
(in-package :arrowgrams/compiler)
(defclass output-pins (e/part:part) ())
(defmethod e/part:busy-p ((self output-pins)) (call-next-method))

; (:code OUTPUT-PINS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self output-pins))
  (@set self :state :idle))

(defmethod e/part:react ((self output-pins) e)
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
            (format nil "OUTPUT-PINS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&output-pins~%")
             (output-pins self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "OUTPUT-PINS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod output-pins ((self output-pins))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:source_rect (:? E)))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
