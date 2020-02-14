(in-package :arrowgrams/compiler/util)

(defmethod find-all-text ((self e/part:part))
  (let ((all-text-rules '((:text-id (:? id) (:? str) (:? bb-left) (:? bb-top) (:? bb-right) (:? bb-bottom))
                          (:text (:? id) (:? str))
                          (:bounding-box_left (:? id) (:? bb-left))
                          (:bounding-box_top (:? id) (:? bb-top))
                          (:bounding-box_right (:? id) (:? bb-right))
                          (:bounding-box_bottom (:? id) (:? bb-bottom)))))
    (let ((fb (cons all-text-rules (cl-event-passing-user::@get self :fb))))
      (hprolog:prove nil '((:text-id (:? tid) (:? str))) fb hprolog:*empty* 1 nil fb nil self))))

(defmethod find-all-speechbubbles ((self e/part:part))
  (let ((all-speechbubble-rules '((:speechbubble-id (:? id) (:? bb-left) (:? bb-top) (:? bb-right) (:? bb-bottom))
                                  (:speechbubble (:? id))
                                  (:bounding-box_left (:? id) (:? bb-left))
                                  (:bounding-box_top (:? id) (:? bb-top))
                                  (:bounding-box_right (:? id) (:? bb-right))
                                  (:bounding-box_bottom (:? id) (:? bb-bottom)))))
    (let ((fb (cons all-speechbubble-rules (cl-event-passing-user::@get self :fb))))
      (hprolog:prove nil '((:text-id (:? tid) (:? str))) fb hprolog:*empty* 1 nil fb nil self))))

(defun bb-contains (left top right bottom L2 T2 R2 B2)
  ;; see that L2 T2 R2 B2 fit inside of left/top/right/bottom
  ;; Draw.io forced us to check only that L2 and T2 fit inside the bounding box - TODO: fix this to use the full bounding box 2
  (and
   (<= left L2 R2)
   (<= top T2 B2)
   (>= right R2 L2)
   (>= bottom B2 T2)))

(defun remove-fact (fact fb)
  (assert (listp fact))
  (if (= 2 (length fact))
      ;; changing remove to delete needs thought - at present, the list is shared with the FB component and all other components
      (remove-if #'(lambda (x)
                     (and (listp x)
                          (= 1 (length x))
                          (let ((x-fact (first x)))
                            (and (eq (first fact) (first x-fact))
                                 (eq (second fact) (second x-fact))))))
                 fb)
    (if (= 3 (length fact))
      (remove-if #'(lambda (x)
                     (and (listp x)
                          (= 1 (length x))
                          (let ((x-fact (first x)))
                            (and (eq (first fact) (first x-fact))
                                 (eq (second fact) (second x-fact))
                                 (eq (third fact) (third x-fact))))))
                 fb)
      (error "UTIL remove-fact ERROR: expected 2 or 3 items, but got ~S" fact))))

(defmethod retract ((self e/part:part) arg1 l g r e n c result)
  ;; TODO: rewrite complete-fb in the return values ; make the change immediate so it affects the current searches
  (let ((local-fb (cl-event-passing-user::@get self :fb)))
    (cl-event-passing-user::@set self :fb (remove-fact arg1 local-fb)))
  (cl-event-passing-user::@send self :retract-fact arg1)
  (values T l g r e n c result))

(defmethod asserta ((self e/part:part) arg1 l g r e n c result)
  (cl-event-passing-user::@send self :add-fact arg1)
  (values T l g r e n c result))

(defmethod run-prolog ((self e/part:part) goal fb)
  (hprolog:prove nil goal fb hprolog:*empty* 1 nil fb nil self))

(defmethod printf ((self e/part:part) arg l g r e n c result)
  (declare (ignore self g))
  (format *standard-output* "~&printf ~S~%" arg)
  (values T l g r e n c result))

(defun fb-keep (keep-list fb)
  ;; return a list that only has items from keep-list on it
  (let ((result (remove-if-not #'(lambda (fact)
                                   (and (listp fact)
                                        (member (caar fact) keep-list)))
                               fb)))
    result))
