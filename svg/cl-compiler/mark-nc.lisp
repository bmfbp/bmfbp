
(in-package :arrowgrams/compiler)
(defclass mark-nc (e/part:code) ())
(defmethod e/part:busy-p ((self mark-nc)) (call-next-method))
(defmethod e/part:clone ((self mark-nc)) (call-next-method))

; (:code MARK-NC (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self mark-nc))
  (@set self :state :idle))

(defmethod e/part:react ((self mark-nc) e)
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
            (format nil "MARK-NC in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&mark-nc~%")
             (mark-nc self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "MARK-NC) in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod mark-nc ((self mark-nc))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:mark_nc (:? A)))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
