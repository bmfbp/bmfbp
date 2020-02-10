(in-package :arrowgrams/compiler)

(defclass ellipse-bounding-boxes (e/part:part) ())
(defmethod e/part:busy-p ((self ellipse-bounding-boxes)) (call-next-method))
; (:code ellipse-bb (:fb :go) (:add-fact :done :request-fb :error)

(defmethod e/part:first-time ((self ellipse-bounding-boxes))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self ellipse-bounding-boxes) e)
  (let ((pin (@pin e))
        (data (@data e)))
    (ecase (@get self :state)
      (:idle
       (if (eq pin :fb)
           (@set self :fb data)
         (if (eq pin :go)
             (progn
               (send-rules self)
               (@send self :request-fb t)
               (@set self :state :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "BOUNDING-BOXES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (format *standard-output* "~&ellipse-bounding-boxes~%")
             (@set self :fb data)
             (make-bounding-boxes self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "BOUNDING-BOXES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method)))
             
         

(defmethod send-rules ((self ellipse-bounding-boxes))
  ; nothing - deprecated
  )

(defmethod make-bounding-boxes ((self ellipse-bounding-boxes))
  (let ((bounding-box-rules '((:ellipse-geometry (:? id) (:? cx) (:? cy) (:? hw) (:? hh))
                              (:ellipse (:? id))
                              (:geometry_center_x (:? id) (:? cx))
                              (:geometry_center_y (:? id) (:? cy))
                              (:geometry_w (:? id) (:? hw))
                              (:geometry_h (:? id) (:? hh)))))
    (let ((fb (cons bounding-box-rules (@get self :fb))))
      (let ((r (hprolog:prove nil '((:ellipse-geometry (:? eid) (:? cx) (:? cy) (:? hw) (:? hh))) fb hprolog:*empty* 1 nil fb nil self)))
        (mapcar #'(lambda (lis)
                    (assert (= 5 (length lis)))
                    (let ((id (cdr (first lis)))
                          (cx (cdr (second lis)))
                          (cy (cdr (third lis)))
                          (hw (cdr (fourth lis)))
                          (hh (cdr (fifth lis))))
                      (@send self :add-fact (list :bounding_box_left id (- cx hw)))
                      (@send self :add-fact (list :bounding_box_top id (- cy hh)))
                      (@send self :add-fact (list :bounding_box_right id (+ cx hw)))
                      (@send self :add-fact (list :bounding_box_bottom id (+ cy hh)))))
                r)))))


