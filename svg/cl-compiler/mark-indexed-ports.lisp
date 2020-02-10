
(in-package :arrowgrams/compiler)
(defclass mark-indexed-ports (e/part:part) ())
(defmethod e/part:busy-p ((self mark-indexed-ports)) (call-next-method))

; (:code MARK-INDEXED-PORTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self mark-indexed-ports))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self mark-indexed-ports) e)
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
            (format nil "MARK-INDEXED-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&mark-indexed-ports~%")
             (mark-indexed-ports self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "MARK-INDEXED-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method))

(defmethod mark-indexed-ports ((self mark-indexed-ports))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:markIndexedPorts_main))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
