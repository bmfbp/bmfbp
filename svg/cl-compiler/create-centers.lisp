
(in-package :arrowgrams/compiler)
(defclass create-centers (e/part:code) ())
(defmethod e/part:busy-p ((self create-centers)) (call-next-method))
(defmethod e/part:clone ((self create-centers)) (call-next-method))

; (:code CREATE-CENTERS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self create-centers))
  (@set self :state :idle)
  )

(defmethod e/part:react ((self create-centers) e)
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
            (format nil "CREATE-CENTERS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&create-centers COMMENTED OUT~%")
             ;(create-centers self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "CREATE-CENTERS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod create-centers ((self create-centers))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:create_centers_main))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
