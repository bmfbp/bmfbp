
(in-package :arrowgrams/compiler)
(defclass output-pins (compiler-part) ())
(defmethod e/part:busy-p ((self output-pins)) (call-next-method))
(defmethod e/part:clone ((self output-pins)) (call-next-method))

; (:code OUTPUT-PINS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self output-pins))
  (call-next-method))

(defmethod e/part:react ((self output-pins) e)
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
            (format nil "OUTPUT-PINS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (output-pins self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "OUTPUT-PINS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod output-pins ((self output-pins))
  (let ((fb
         (append
          *rules*
          (fb self)))
        (goal '((:source_rect (:? E)))))
    (run-prolog self goal fb)))
