(in-package :arrowgrams/compiler/assign-parents-to-ellipses)

; (:code assign-parents-to-ellipses (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/assign-parents-to-ellipses::react #'arrowgrams/compiler/assign-parents-to-ellipses::first-time)

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
            (format nil "ASSIGN PARENTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (assign-parents self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "ASSIGN PARENTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod assign-parents ((self e/part:part))
  (let ((assign-parents-rules '((:ellipse-id (:? id))
                              (:ellipse (:? id)))))
    (let ((fb (cons assign-parents-rules (cl-event-passing-user::@get-instance-var self :fb))))
      (let ((parent (hprolog:prove nil '((:component (:? pid))) fb hprolog:*empty* 1 nil fb nil)))
        (assert (= 1 (length parent)))
        (let ((pid (cdr (caar parent))))
          (let ((ellipse-list (hprolog:prove nil '((:ellipse-id (:? eid))) fb hprolog:*empty* 1 nil fb nil)))
            (mapcar #'(lambda (lis)
                        (assert (= 1 (length lis)))
                        (let ((id (cdr (first lis))))
                          (cl-event-passing-user::@send self :add-fact (list :parent id pid))
                        (format *standard-output* "~&added parent for ellipse ~A ~S~%" id pid)))
                    ellipse-list)))))))

