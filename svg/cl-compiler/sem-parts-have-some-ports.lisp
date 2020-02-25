
(in-package :arrowgrams/compiler)
(defclass sem-parts-have-some-ports (compiler-part) ())
(defmethod e/part:busy-p ((self sem-parts-have-some-ports)) (call-next-method))
(defmethod e/part:clone ((self sem-parts-have-some-ports)) (call-next-method))

; (:code SEM-PARTS-HAVE-SOME-PORTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self sem-parts-have-some-ports))
  (call-next-method))

(defmethod e/part:react ((self sem-parts-have-some-ports) e)
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
            (format nil "SEM-PARTS-HAVE-SOME-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (format *standard-output* "~&COMMENTED OUT sem-parts-have-some-ports~%")
             ;(sem-parts-have-some-ports self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "SEM-PARTS-HAVE-SOME-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod sem-parts-have-some-ports ((self sem-parts-have-some-ports))
  (let ((fb
         (append
          *rules*
          (fb self)))
        (goal '((:new_sem_partsHaveSomePorts_main (:? R)))))
    (let ((result (run-prolog self goal fb)))
      (format *standard-output* "~&result=~S~%" result))))
