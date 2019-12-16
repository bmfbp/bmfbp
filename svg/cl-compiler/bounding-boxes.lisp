(in-package :arrowgrams/compiler/bounding-boxes)

; (:code bounding-boxes (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/bounding-boxes::react #'arrowgrams/compiler/bounding-boxes::first-time)

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
               (send-rules self)
               (cl-event-passing-user::@send self :request-fb t)
               (cl-event-passing-user::@set-instance-var self :state :waiting-for-new-fb))
           (cl-event-passing-user::@send
            self
            :error
            (format nil "BOUNDING-BOXES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (make-bounding-boxes self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "BOUNDING-BOXES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))
             
         
           

(defmethod send-rules ((self e/part:part))
  (let ((bounding-box-rules '((:ellipse-geometry (:? id) (:? cx) (:? cy) (:? hw) (:? hh))
                              (:ellipse (:? id))
                              (:geometry_center_x (:? id) (:? cx))
                              (:geometry_center_y (:? id) (:? cy))
                              (:geometry_w (:? id) (:? hw))
                              (:geometry_h (:? id) (:? hh)))))
    (cl-event-passing-user::@send self :add-fact bounding-box-rules)))

(defmethod make-bounding-boxes ((self e/part:part))
    (let ((fb (cl-event-passing-user::@get-instance-var self :fb)))
      (let ((r (hprolog:prove nil '((:ellipse-geometry (:? eid) (:? cx) (:? cy) (:? hw) (:? hh))) fb hprolog:*empty* 1 nil fb nil)))
        (mapcar #'(lambda (lis)
                    (assert (= 5 (length lis)))
                    (let ((id (cdr (first lis)))
                          (cx (cdr (second lis)))
                          (cy (cdr (third lis)))
                          (hw (cdr (fourth lis)))
                          (hh (cdr (fifth lis))))
                      (cl-event-passing-user::@send self :add-fact (list 'bounding_box_left id (- cx hw)))
                      (cl-event-passing-user::@send self :add-fact (list 'bounding_box_top id (- cy hh)))
                      (cl-event-passing-user::@send self :add-fact (list 'bounding_box_right id (+ cx hw)))
                      (cl-event-passing-user::@send self :add-fact (list 'bounding_box_bottom id (+ cy hh)))))
                r))))

