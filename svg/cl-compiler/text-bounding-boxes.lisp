(in-package :arrowgrams/compiler/text-bounding-boxes)

; (:code text-bounding-boxes (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/text-bounding-boxes::react #'arrowgrams/compiler/text-bounding-boxes::first-time)

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
  (let ((bounding-box-rules '((:text-geometry (:? id) (:? str) (:? cx) (:? y) (:? hw) (:? h))
                              (:text (:? id) (:? str))
                              (:geometry_center_x (:? id) (:? cx))
                              (:geometry_top_y (:? id) (:? y))
                              (:geometry_w (:? id) (:? hw))
                              (:geometry_h (:? id) (:? h)))))
    (let ((fb (cons bounding-box-rules (cl-event-passing-user::@get-instance-var self :fb))))
      (let ((r (hprolog:prove nil '((:text-geometry (:? id) (:? str) (:? cx) (:? y) (:? hw) (:? h))) fb hprolog:*empty* 1 nil fb nil self)))
        (mapcar #'(lambda (lis)
                    (assert (= 6 (length lis)))
                    (let ((id (cdr (first lis)))
                          (str (cdr (second lis)))
                          (cx (cdr (third lis)))
                          (y (cdr (fourth lis)))
                          (hw (cdr (fifth lis)))
                          (h (cdr (sixth lis))))
                      (cl-event-passing-user::@send self :add-fact (list 'bounding_box_left id (- cx hw)))
                      (cl-event-passing-user::@send self :add-fact (list 'bounding_box_top id y))
                      (cl-event-passing-user::@send self :add-fact (list 'bounding_box_right id (+ cx hw)))
                      (cl-event-passing-user::@send self :add-fact (list 'bounding_box_bottom id (+ y h)))
                      (format *standard-output* "~&added bounding box for text ~A ~A/~A/~A/~A~%"
                              id (- cx hw) y (+ cx hw) (+ y h))))
                r)))))

