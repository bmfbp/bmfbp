
(in-package :arrowgrams/compiler)
(defclass make-unknown-port-names (e/part:code) ())
(defmethod e/part:busy-p ((self make-unknown-port-names)) (call-next-method))
(defmethod e/part:clone ((self make-unknown-port-names)) (call-next-method))

; (:code MAKE-UNKNOWN-PORT-NAMES (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self make-unknown-port-names))
  (@set self :state :idle))

(defmethod e/part:react ((self make-unknown-port-names) e)
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
            (format nil "MAKE-UNKNOWN-PORT-NAMES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&make-unknown-port-names~%")
             (make-unknown-port-names self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "MAKE-UNKNOWN-PORT-NAMES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod make-unknown-port-names ((self make-unknown-port-names))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:make_unknown_port_names_main))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
