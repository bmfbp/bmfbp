(in-package :arrowgrams/compiler)

(defclass speechbubble-bounding-boxes (e/part:part) ())

(defmethod e/part:busy-p ((self speechbubble-bounding-boxes)) (call-next-method))
; (:code speechbubble-bounding-boxes (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self speechbubble-bounding-boxes))
  (@set self :state :idle))

(defmethod e/part:react ((self speechbubble-bounding-boxes) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
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
            (format nil "speech bubble BOUNDING-BOXES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (format *standard-output* "~&speechbubble-bounding-boxes~%")
             (@set self :fb data)
             (make-speechbubble-bounding-boxes self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "speech bubble BOUNDING-BOXES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))
             

(defmethod make-speechbubble-bounding-boxes ((self speechbubble-bounding-boxes))
  ;; same as rect, but matches speechbubble
  (let ((bounding-box-rules '((:speechbubble-geometry (:? id) (:? cx) (:? cy) (:? w) (:? h))
                              (:speechbubble (:? id))
                              (:geometry_left_x (:? id) (:? cx))
                              (:geometry_top_y (:? id) (:? cy))
                              (:geometry_w (:? id) (:? w))
                              (:geometry_h (:? id) (:? h)))))
    (let ((fb (cons bounding-box-rules (@get self :fb))))
        (let ((r (hprolog:prove nil '((:speechbubble-geometry (:? id) (:? cx) (:? cy) (:? w) (:? h))) fb hprolog:*empty* 1 nil fb nil self)))
          (mapcar #'(lambda (lis)
                      (assert (= 5 (length lis)))
                      (let ((id (cdr (first lis)))
                            (cx (cdr (second lis)))
                            (cy (cdr (third lis)))
                            (w (cdr (fourth lis)))
                            (h (cdr (fifth lis))))
                        (@send self :add-fact (list :bounding_box_left id (- cx w)))
                        (@send self :add-fact (list :bounding_box_top id (- cy h)))
                        (@send self :add-fact (list :bounding_box_right id (+ cx w)))
                        (@send self :add-fact (list :bounding_box_bottom id (+ cy h)))))
                  r)))))

