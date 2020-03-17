
(in-package :arrowgrams/compiler)
(defclass pinless (compiler-part) ())
(defmethod e/part:busy-p ((self pinless)) (call-next-method))
(defmethod e/part:clone ((self pinless)) (call-next-method))

; (:code PINLESS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self pinless))
  (call-next-method))

(defmethod e/part:react ((self pinless) e)
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
            (format nil "PINLESS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (state self) data)
             (format *standard-output* "pinless ")
             (mark-pinless self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "PINLESS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod mark-pinless ((self pinless))
  (let ((fb
         (append
          *rules*
          (fb self)))
        (goal '((:mark_pinless (:? A)))))
    (run-prolog self goal fb)))
