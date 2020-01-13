
(in-package :arrowgrams/compiler/MATCH-PORTS-TO-COMPONENTS)

; (:code MATCH-PORTS-TO-COMPONENTS (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/MATCH-PORTS-TO-COMPONENTS::react #'arrowgrams/compiler/MATCH-PORTS-TO-COMPONENTS::first-time)

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
            (format nil "MATCH-PORTS-TO-COMPONENTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&match-ports-to-components~%")
             (match-ports-to-components self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "MATCH-PORTS-TO-COMPONENTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod match-ports-to-components ((self e/part:part))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (cl-event-passing-user::@get-instance-var self :fb)))
        (goal '((:match_ports_to_components (:? A)))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
