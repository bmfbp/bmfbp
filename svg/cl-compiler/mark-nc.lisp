
(in-package :arrowgrams/compiler)
(defclass mark-nc (compiler-part) ())
(defmethod e/part:busy-p ((self mark-nc)) (call-next-method))
(defmethod e/part:clone ((self mark-nc)) (call-next-method))

; (:code MARK-NC (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self mark-nc))
  (call-next-method))

(defmethod e/part:react ((self mark-nc) e)
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
            (format nil "MARK-NC in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (mark-nc self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "MARK-NC) in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod mark-nc ((self mark-nc))
  (let ((fb
         (append
          *rules*
          (fb self)))
        (goal '((:mark_nc (:? A)))))
    (run-prolog self goal fb)))
