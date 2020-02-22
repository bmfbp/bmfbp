(in-package :arrowgrams/compiler)

(defclass rectangle-bounding-boxes (e/part:code) ())
(defmethod e/part:busy-p ((self rectangle-bounding-boxes)) (call-next-method))
(defmethod e/part:clone ((self rectangle-bounding-boxes)) (call-next-method))
; (:code rectangle-bb (:fb :go) (:add-fact :done :request-fb :error) )

(defmethod e/part:first-time ((self rectangle-bounding-boxes))
  (@set self :state :idle))

(defmethod e/part:react ((self rectangle-bounding-boxes) e)
  (let ((pin (@pin self e))
        (data (@data self e)))
    (ecase (@get self :state)
      (:idle
       (if (eq pin :fb)
           (@set self :fb data)
         (if (eq pin :go)
             (progn
               (@send self :request-fb t)
               (@set self :state :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "BOUNDING-BOXES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&rectangle-bounding-boxes~%")
             (make-bounding-boxes self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "BOUNDING-BOXES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))
             

(defmethod make-bounding-boxes ((self rectangle-bounding-boxes))
  (let ((bounding-box-rules '((:rectangle-geometry (:? id) (:? x) (:? y) (:? w) (:? h))
                              (:rect (:? id))
                              (:geometry_left_x (:? id) (:? x))
                              (:geometry_top_y (:? id) (:? y))
                              (:geometry_w (:? id) (:? w))
                              (:geometry_h (:? id) (:? h)))))
    (let ((fb (cons bounding-box-rules (@get self :fb))))
      (let ((r (hprolog:prove nil '((:rectangle-geometry (:? rect-id) (:? x) (:? y) (:? w) (:? h))) fb hprolog:*empty* 1 nil fb nil self)))
        (mapcar #'(lambda (lis)
                    (assert (= 5 (length lis)))
                    (let ((id (cdr (first lis)))
                          (x (cdr (second lis)))
                          (y (cdr (third lis)))
                          (w (cdr (fourth lis)))
                          (h (cdr (fifth lis))))
                      (@send self :add-fact (list :bounding_box_left id x))
                      (@send self :add-fact (list :bounding_box_top id y))
                      (@send self :add-fact (list :bounding_box_right id (+ x w)))
                      (@send self :add-fact (list :bounding_box_bottom id (+ y h)))))
                r)))))

