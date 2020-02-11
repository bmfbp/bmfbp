
(in-package :arrowgrams/compiler)
(defclass coincident-ports (e/part:part) ())
(defmethod e/part:busy-p ((self coincident-ports)) (call-next-method))

; (:code COINCIDENT-PORTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self coincident-ports))
  (@set self :state :idle))

(defmethod e/part:react ((self coincident-ports) e)
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
            (format nil "COINCIDENT-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&coincident-ports~%")
             (coincident-ports self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "COINCIDENT-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod coincident-ports ((self coincident-ports))
  (let ((local-fb (arrowgrams/compiler/util::fb-keep '(:not_namedsink :namedsink :coincidentsinks :findallcoincidentsinks :sink
                                                       :not_namedsource :namedsource :coincidentsources :findallcoincidentsources :source
                                                       :center_x :center_y :portName)
                   (@get self :fb))))
    (let ((fb
           (append
            arrowgrams/compiler::*rules*
            local-fb))
          (goal '((:coincidentSinks (:? A) (:? B)))))
(format *standard-output* ":coinincidentSinks~%")
    (arrowgrams/compiler/util::run-prolog self goal local-fb))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          local-fb))
        (goal '((:coincidentSources (:? A) (:? B)))))
(format *standard-output* ":coincidentSource~%")
    (arrowgrams/compiler/util::run-prolog self goal fb))))

