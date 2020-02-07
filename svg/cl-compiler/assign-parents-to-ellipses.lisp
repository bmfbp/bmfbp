(in-package :arrowgrams/compiler)

; (:code assign-parents-to-ellipses (:fb :go) (:add-fact :done :request-fb :error))

(defmethod assign-parents-to-ellipses-first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod assign-parents-to-ellipses-react ((self e/part:part) e)
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
            (format nil "ASSIGN PARENTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&assign-parents-to-ellipses~%")
             (assign-parents self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "ASSIGN PARENTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod assign-parents ((self e/part:part))
  (let ((rule '(
                (:make-parent-for-ellipse (:? id) (:? main))
                (:ellipse (:? id))
                (:component (:? main))
                (:lisp-method (arrowgrams/compiler/util::asserta (:parent (:? main) (:? id))))
                )))
    (let ((fb (cons rule (cl-event-passing-user::@get-instance-var self :fb))))
      (hprolog:prove nil '((:make-parent-for-ellipse (:? eid) (:? main-id))) fb hprolog:*empty* 1 nil fb nil self))))
