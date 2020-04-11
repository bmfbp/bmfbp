
(in-package :arrowgrams/compiler)
(defclass input-pins (compiler-part) ())
(defmethod e/part:busy-p ((self input-pins)) (call-next-method))
(defmethod e/part:clone ((self input-pins)) (call-next-method))

; (:code INPUT-PINS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self input-pins))
  (call-next-method))

(defmethod e/part:react ((self input-pins) e)
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
            (format nil "INPUT-PINS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (input-pins self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "INPUT-PINS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod input-pins ((self input-pins))
  (let ((fb
         (append
          *rules*
          (fb self)))
        (goal '((:sink_rect (:? E)))))
    (run-prolog self goal fb)))
