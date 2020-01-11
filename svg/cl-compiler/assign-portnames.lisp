
(in-package :arrowgrams/compiler/ASSIGN-PORTNAMES)

; (:code ASSIGN-PORTNAMES (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/ASSIGN-PORTNAMES::react #'arrowgrams/compiler/ASSIGN-PORTNAMES::first-time)

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
            (format nil "ASSIGN-PORTNAMES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&assign-portnames~%")
             (assign-portnames self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "ASSIGN-PORTNAMES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod assign-portnames ((self e/part:part))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (cl-event-passing-user::@get-instance-var self :fb)))
        (goal '((:collect_unassigned_text (:? text) (:? str)))))
    (let ((text-results (arrowgrams/compiler/util::run-prolog self goal fb)))
      (format *standard-output* "~&text results=~S~%" text-results)
      (let ((goal '((:collect_joins (:? join) (:? text) (:? port) (:? distance)))))
        (let ((join-results (arrowgrams/compiler/util::run-prolog self goal fb)))
          (format *standard-output* "~&join results=~S~%" join-results)
          (let ((goal '((:collect_joins_for_port (:? port) (:? text) (:? str) (:? join) (:? distance)))))
            (let ((port-join-results (arrowgrams/compiler/util::run-prolog self goal fb)))
              (format *standard-output* "~&port join results=~S~%" port-join-results))))))))
    

