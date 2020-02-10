
(in-package :arrowgrams/compiler)
(defclass sem-no-duplicate-kinds (e/part:part) ())
(defmethod e/part:busy-p ((self sem-no-duplicate-kinds)) (call-next-method))

; (:code SEM-NO-DUPLICATE-KINDS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self sem-no-duplicate-kinds))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self sem-no-duplicate-kinds) e)
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
            (format nil "SEM-NO-DUPLICATE-KINDS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&sem-no-duplicate-kinds~%")
             ;; put code here
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "SEM-NO-DUPLICATE-KINDS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method)))

