(in-package :arrowgrams/compiler/util)

(defmethod find-all-text ((self e/part:part))
  (let ((all-text-rules '((:text-id (:? id) (:? str) (:? bb-left) (:? bb-top) (:? bb-right) (:? bb-bottom))
                          (:text (:? id) (:? str))
                          (:bounding-box_left (:? id) (:? bb-left))
                          (:bounding-box_top (:? id) (:? bb-top))
                          (:bounding-box_right (:? id) (:? bb-right))
                          (:bounding-box_bottom (:? id) (:? bb-bottom)))))
    (let ((fb (cons all-text-rules (cl-event-passing-user::@get-instance-var self :fb))))
      (hprolog:prove nil '((:text-id (:? tid) (:? str))) fb hprolog:*empty* 1 nil fb nil self))))

(defmethod find-all-speechbubbles ((self e/part:part))
  (let ((all-speechbubble-rules '((:speechbubble-id (:? id) (:? bb-left) (:? bb-top) (:? bb-right) (:? bb-bottom))
                                  (:speechbubble (:? id))
                                  (:bounding-box_left (:? id) (:? bb-left))
                                  (:bounding-box_top (:? id) (:? bb-top))
                                  (:bounding-box_right (:? id) (:? bb-right))
                                  (:bounding-box_bottom (:? id) (:? bb-bottom)))))
    (let ((fb (cons all-speechbubble-rules (cl-event-passing-user::@get-instance-var self :fb))))
      (hprolog:prove nil '((:text-id (:? tid) (:? str))) fb hprolog:*empty* 1 nil fb nil self))))

(defun bb-contains (left top right bottom L2 T2 R2 B2)
  ;; see that L2 T2 R2 B2 fit inside of left/top/right/bottom
  ;; Draw.io forced us to check only that L2 and T2 fit inside the bounding box - TODO: fix this to use the full bounding box 2
  (and
   (<= left L2 R2)
   (<= top T2 B2)
   (>= right R2 L2)
   (>= bottom B2 T2)))

(defmethod asserta ((self e/part:part) arg1 l g r e n c result)
  (format *standard-output* "~&asserta ~S~%" arg1)
  (cl-event-passing-user::@send self :add-fact arg1)
  (values T l g r e n c result))

