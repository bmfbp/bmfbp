
(in-package :arrowgrams/compiler)
(defclass sem-parts-have-some-ports (e/part:part) ())
(defmethod e/part:busy-p ((self sem-parts-have-some-ports)) (call-next-method))

; (:code SEM-PARTS-HAVE-SOME-PORTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self sem-parts-have-some-ports))
  (@set self :state :idle))

(defmethod e/part:react ((self sem-parts-have-some-ports) e)
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
            (format nil "SEM-PARTS-HAVE-SOME-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&COMMENTED OUT sem-parts-have-some-ports~%")
             ;(sem-parts-have-some-ports self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "SEM-PARTS-HAVE-SOME-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e)))))))

(defmethod sem-parts-have-some-ports ((self sem-parts-have-some-ports))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:new_sem_partsHaveSomePorts_main (:? R)))))
    (let ((result (arrowgrams/compiler/util::run-prolog self goal fb)))
      (format *standard-output* "~&result=~S~%" result))))
