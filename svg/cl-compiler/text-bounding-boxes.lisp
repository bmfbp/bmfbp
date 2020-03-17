(in-package :arrowgrams/compiler)

(defclass text-bounding-boxes (compiler-part) ())
(defmethod e/part:busy-p ((self text-bounding-boxes)) (call-next-method))
(defmethod e/part:clone ((self text-bounding-boxes)) (call-next-method))
; (:code text-bb (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:react ((self text-bounding-boxes) e)
  (let ((pin (@pin self e))
        (data (@data self e)))
    (ecase (state self)
      (:idle
       (if (eq pin :fb)
           (setf (fb self) data)
         (if (eq pin :go)
             (progn
               (@send self :request-fb t)
               (setf (state self) :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "BOUNDING-BOXES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (format *standard-output* "text-bounding-boxes ")
             (text-bb-make-bounding-boxes self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "BOUNDING-BOXES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

             

(defmethod text-bb-make-bounding-boxes ((self text-bounding-boxes))
  (let ((bounding-box-rules '((:text-geometry (:? id) (:? str) (:? cx) (:? y) (:? hw) (:? h))
                              (:text (:? id) (:? str))
                              (:geometry_center_x (:? id) (:? cx))
                              (:geometry_top_y (:? id) (:? y))
                              (:geometry_w (:? id) (:? hw))
                              (:geometry_h (:? id) (:? h)))))
    (let ((fb (cons bounding-box-rules (fb self))))
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

