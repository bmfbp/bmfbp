
(in-package :arrowgrams/compiler)
(defclass mark-directions (compiler-part) ())
(defmethod e/part:busy-p ((self mark-directions)) (call-next-method))
(defmethod e/part:clone ((self mark-directions)) (call-next-method))

; (:code MARK-DIRECTIONS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self mark-directions))
  (call-next-method))

(defmethod e/part:react ((self mark-directions) e)
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
            (format nil "MARK-DIRECTIONS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (format *standard-output* "/mark-directions (noop)/ ")
             ;
             (@send self :done t)
             (e/part::first-time self))
         (@send
          self
          :error
          (format nil "MARK-DIRECTIONS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))