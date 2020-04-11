
(in-package :arrowgrams/compiler)
(defclass coincident-ports (compiler-part) ())
(defmethod e/part:busy-p ((self coincident-ports)) (call-next-method))
(defmethod e/part:clone ((self coincident-ports)) (call-next-method))

; (:code COINCIDENT-PORTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self coincident-ports))
  (call-next-method))

(defmethod e/part:react ((self coincident-ports) e)
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
            (format nil "COINCIDENT-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (coincident-ports self)
             (@send self :done t)
             (e/part::first-time self))
         (@send
          self
          :error
          (format nil "COINCIDENT-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod coincident-ports ((self coincident-ports))
  (let ((local-fb (fb-keep '(:not_namedsink :namedsink :coincidentsinks :findallcoincidentsinks :sink
                                                       :not_namedsource :namedsource :coincidentsources :findallcoincidentsources :source
                                                       :center_x :center_y :portName)
                                                     (fb self))))
    (let ((fb
           (append
            arrowgrams/compiler::*rules*
            local-fb))
          (goal '((:coincidentSinks (:? A) (:? B)))))
    (run-prolog self goal local-fb))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          local-fb))
        (goal '((:coincidentSources (:? A) (:? B)))))
    (run-prolog self goal fb))))

