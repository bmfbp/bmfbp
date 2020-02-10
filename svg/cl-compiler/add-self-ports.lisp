
(in-package :arrowgrams/compiler)
(defclass add-self-ports (e/part:part) ())
(defmethod e/part:busy-p ((self add-self-ports)) (call-next-method))

; (:code ADD-SELF-PORTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self add-self-ports))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self add-self-ports) e)
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
            (format nil "ADD-SELF-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&add-self-ports~%")
             (create-self-ports self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "ADD-SELF-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method)))

(defmethod create-self-ports ((self add-self-ports))
  ;;;     % find one port that touches the ellispe (if there are more, then the "coincidentPorts"
  ;;;     % pass will find them), asserta all facts needed by ports downstream - portIndex, sink,
  ;;;     % source, parent

  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:add_selfports_main))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
