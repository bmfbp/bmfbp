
(in-package :arrowgrams/compiler)

; (:code ADD-SELF-PORTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod ADD-SELF-PORTS-first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod ADD-SELF-PORTS-react ((self e/part:part) e)
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
            (format nil "ADD-SELF-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&add-self-ports~%")
             (create-self-ports self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "ADD-SELF-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))



(defmethod create-self-ports ((self e/part:part))
  ;;;     % find one port that touches the ellispe (if there are more, then the "coincidentPorts"
  ;;;     % pass will find them), asserta all facts needed by ports downstream - portIndex, sink,
  ;;;     % source, parent

  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (cl-event-passing-user::@get-instance-var self :fb)))
        (goal '((:add_selfports_main))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
