(in-package :arrowgrams/compiler)

(defclass text-bounding-boxes (e/part:part) ())
(defmethod e/part:busy-p ((self text-bounding-boxes)) (call-next-method))
; (:code text-bb (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self text-bounding-boxes))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self text-bounding-boxes) e)
  (let ((pin (@pin e))
        (data (@data e)))
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
             (format *standard-output* "~&text-bounding-boxes~%")
             (text-bb-make-bounding-boxes self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "BOUNDING-BOXES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method)))
             

(defmethod text-bb-make-bounding-boxes ((self text-bounding-boxes))
  (let ((bounding-box-rules '((:text-geometry (:? id) (:? str) (:? cx) (:? y) (:? hw) (:? h))
                              (:text (:? id) (:? str))
                              (:geometry_center_x (:? id) (:? cx))
                              (:geometry_top_y (:? id) (:? y))
                              (:geometry_w (:? id) (:? hw))
                              (:geometry_h (:? id) (:? h)))))
    (let ((fb (cons bounding-box-rules (@get self :fb))))
      (let ((r (hprolog:prove nil '((:text-geometry (:? id) (:? str) (:? cx) (:? y) (:? hw) (:? h))) fb hprolog:*empty* 1 nil fb nil self)))
        (mapcar #'(lambda (lis)
                    (assert (= 6 (length lis)))
                    (let ((id (cdr (first lis)))
                          (str (cdr (second lis)))
                          (cx (cdr (third lis)))
                          (y (cdr (fourth lis)))
                          (hw (cdr (fifth lis)))
                          (h (cdr (sixth lis))))
                      (@send self :add-fact (list :bounding_box_left id (- cx hw)))
                      (@send self :add-fact (list :bounding_box_top id y))
                      (@send self :add-fact (list :bounding_box_right id (+ cx hw)))
                      (@send self :add-fact (list :bounding_box_bottom id (+ y h)))))
                r)))))

