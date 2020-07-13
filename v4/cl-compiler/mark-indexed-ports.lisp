
(in-package :arrowgrams/compiler)
(defclass mark-indexed-ports (compiler-part) ())
(defmethod e/part:busy-p ((self mark-indexed-ports)) (call-next-method))
(defmethod e/part:clone ((self mark-indexed-ports)) (call-next-method))

; (:code MARK-INDEXED-PORTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self mark-indexed-ports))
  (call-next-method))

(defmethod e/part:react ((self mark-indexed-ports) e)
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
            (format nil "MARK-INDEXED-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (mark-indexed-ports self)
             (@send self :done t)
             (e/part::first-time self))
         (@send
          self
          :error
          (format nil "MARK-INDEXED-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod mark-indexed-ports ((self mark-indexed-ports))
  (let ((fb
         (append
          *rules*
          (fb self)))
        (goal '((:markIndexedPorts_main))))
    (run-prolog self goal fb)))
