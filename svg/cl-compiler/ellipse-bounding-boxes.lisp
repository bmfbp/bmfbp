(in-package :arrowgrams/compiler)

(defclass ellipse-bounding-boxes (compiler-part) ())
(defmethod e/part:busy-p ((self ellipse-bounding-boxes)) (call-next-method))
(defmethod e/part:clone ((self ellipse-bounding-boxes)) (call-next-method))
; (:code ellipse-bb (:fb :go) (:add-fact :done :request-fb :error)

(defmethod e/part:first-time ((self ellipse-bounding-boxes))
  (call-next-method))

(defmethod e/part:react ((self ellipse-bounding-boxes) e)
  (let ((pin (@pin self e))
        (data (@data self e)))
    (ecase (state self)
      (:idle
       (if (eq pin :fb)
           (setf (fb self) data)
         (if (eq pin :go)
             (progn
               (send-rules self)
               (@send self :request-fb t)
               (setf (state self) :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "BOUNDING-BOXES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (format *standard-output* "~&ellipse-bounding-boxes~%")
             (setf (fb self) data)
             (make-bounding-boxes self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "BOUNDING-BOXES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))  

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
    (let ((fb (cons bounding-box-rules (fb self))))
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


