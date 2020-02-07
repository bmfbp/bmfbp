(in-package :arrowgrams/compiler)

; (:code sequencer (:finished-reading :finished-pipeline :finished-writing) (:poke-fb :run-pipeline :write :error))

;; read a string fact, output as a lisp fact with all symbols converted to keywords

(defmethod sequencer-first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod sequencer-react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (string-fact (e/event:data e))
        (new-list nil))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
      (:idle
       (if (eq pin :finished-reading)
           (progn
             (cl-event-passing-user::@send self :poke-fb t)
             (cl-event-passing-user::@send self :run-pipeline t)
             ;(cl-event-passing-user::@send self :show t)
             (cl-event-passing-user::@set-instance-var self :state :waiting-for-pipeline))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "SEQUENCER in state :idle expected :finished-reading, but got action ~S data ~S" pin (e/event:data e)))))
      
         (:waiting-for-pipeline
          (if (eq pin :finished-pipeline)
              (progn
                (cl-event-passing-user::@send self :write t)
                (cl-event-passing-user::@set-instance-var self :state :waiting-for-write))
            (cl-event-passing-user::@send
             self
             :error
             (format nil "SEQUENCER in state :waiting-for-pipeline expected :finished-pipeline, but got action ~S data ~S" pin (e/event:data e)))))

         (:waiting-for-write
          (if (eq pin :finished-writing)
              (progn
                (cl-event-passing-user::@set-instance-var self :state :idle))
            (cl-event-passing-user::@send
             self
             :error
             (format nil "SEQUENCER in state :waiting-for-write expected :finished-writing, but got action ~S data ~S" pin (e/event:data e)))))
         
         )))
