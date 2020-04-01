
(in-package :arrowgrams/compiler)
(defclass sem-no-duplicate-kinds (compiler-part) ())
(defmethod e/part:busy-p ((self sem-no-duplicate-kinds)) (call-next-method))
(defmethod e/part:clone ((self sem-no-duplicate-kinds)) (call-next-method))

; (:code SEM-NO-DUPLICATE-KINDS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self sem-no-duplicate-kinds))
  (call-next-method))

(defmethod e/part:react ((self sem-no-duplicate-kinds) e)
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
            (format nil "SEM-NO-DUPLICATE-KINDS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (format *standard-output* "/COMMENTED OUT sem-no-duplicate-kinds/ ")
             ;; put code here
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "SEM-NO-DUPLICATE-KINDS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

