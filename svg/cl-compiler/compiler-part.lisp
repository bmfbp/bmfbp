(in-package :arrowgrams/compiler)

(defclass compiler-part (e/part:part) ())

(defmethod e/part:busy-p ((self compiler-part)) (call-next-method))

(defmethod e/part:first-time ((self compiler-part))
  (@set self :state :idle))

;; all compiler parts should inherit from compiler-part and implement (compiler-part-initially self), (compiler-part-run self event) and (compiler-part-name self)
(defgeneric compiler-part-intially (self))
(defgeneric compiler-part-run (self event))
(defgeneric compiler-part-name (self))

(defmethod e/part:first-time ((self compiler-part))
  (compiler-part-initially self))

(defmethod e/part:react ((self compiler-part) e)
  (let ((pin (@pin self e))
        (data (@data self e)))
    (ecase (@get self :state)
      (:idle
       (if (eq pin :fb)
           (@set self :fb data)
         (if (eq pin :go)
             (progn
               (send-rules self)
               (@send self :request-fb t)
               (@set self :state :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "~a in state :idle expected :fb or :go, but got action ~S data ~S" (compiler-part-name self) pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (format *standard-output* "~&compiler-part~%")
             (@set self :fb data)
             (compiler-part-run self e)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "~a in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" (compiler-part-name self) pin (e/event:data e))))))))  
