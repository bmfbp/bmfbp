(in-package :arrowgrams/compiler/rectangle-bounding-boxes)

; (:code rectangle-bounding-boxes (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/rectangle-bounding-boxes::react #'arrowgrams/compiler/rectangle-bounding-boxes::first-time)

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
             

(defmethod make-bounding-boxes ((self e/part:part))
  (let ((bounding-box-rules '((:rectangle-geometry (:? id) (:? cx) (:? cy) (:? w) (:? h))
                              (:rect (:? id))
                              (:geometry_left_x (:? id) (:? cx))
                              (:geometry_top_y (:? id) (:? cy))
                              (:geometry_w (:? id) (:? w))
                              (:geometry_h (:? id) (:? h)))))
    (let ((fb (cons bounding-box-rules (cl-event-passing-user::@get-instance-var self :fb))))
        (let ((r (hprolog:prove nil '((:rectangle-geometry (:? rect-id) (:? cx) (:? cy) (:? w) (:? h))) fb hprolog:*empty* 1 nil fb nil)))
          (mapcar #'(lambda (lis)
                      (assert (= 5 (length lis)))
                      (let ((id (cdr (first lis)))
                            (cx (cdr (second lis)))
                            (cy (cdr (third lis)))
                            (w (cdr (fourth lis)))
                            (h (cdr (fifth lis))))
                        (cl-event-passing-user::@send self :add-fact (list 'bounding_box_left id (- cx w)))
                        (cl-event-passing-user::@send self :add-fact (list 'bounding_box_top id (- cy h)))
                        (cl-event-passing-user::@send self :add-fact (list 'bounding_box_right id (+ cx w)))
                        (cl-event-passing-user::@send self :add-fact (list 'bounding_box_bottom id (+ cy h)))
                        (format *standard-output* "~&added bounding box for rectangle ~A ~A/~A/~A/~A~%"
                                id (- cx w) (- cy h) (+ cx w) (+ cy h))))
                  r)))))

