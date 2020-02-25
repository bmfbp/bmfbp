
(in-package :arrowgrams/compiler)
(defclass make-unknown-port-names (compiler-part)
  ())
(defmethod e/part:busy-p ((self make-unknown-port-names)) (call-next-method))
(defmethod e/part:clone ((self make-unknown-port-names)) (call-next-method))

; (:code MAKE-UNKNOWN-PORT-NAMES (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self make-unknown-port-names))
  (call-next-method))

(defmethod e/part:react ((self make-unknown-port-names) e)
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
            (format nil "MAKE-UNKNOWN-PORT-NAMES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (format *standard-output* "~&make-unknown-port-names~%")
             (make-unknown-port-names self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "MAKE-UNKNOWN-PORT-NAMES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod make-unknown-port-names ((self make-unknown-port-names))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (fb self)))
        (goal '((:make_unknown_port_names_main))))
    (run-prolog self goal fb)))
