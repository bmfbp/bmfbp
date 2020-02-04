
(in-package :arrowgrams/compiler/COINCIDENT-PORTS)

; (:code COINCIDENT-PORTS (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/COINCIDENT-PORTS::react #'arrowgrams/compiler/COINCIDENT-PORTS::first-time)

(defmethod first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
      (:idle
       (if (eq pin :fb)
           (cl-event-passing-user::@set-instance-var self :fb data)
         (if (eq pin :go)
             (progn
               (cl-event-passing-user::@send self :request-fb t)
               (cl-event-passing-user::@set-instance-var self :state :waiting-for-new-fb))
           (cl-event-passing-user::@send
            self
            :error
            (format nil "COINCIDENT-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&coincident-ports~%")
             (coincident-ports self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "COINCIDENT-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod coincident-ports ((self e/part:part))
  (let ((local-fb (arrowgrams/compiler/util::fb-keep '(:not_namedsink :namedsink :coincidentsinks :findallcoincidentsinks :sink
                                                       :not_namedsource :namedsource :coincidentsources :findallcoincidentsources :source
                                                       :center_x :center_y :portName)
                   (cl-event-passing-user::@get-instance-var self :fb))))
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

