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

(defun remove-fact (fact fb)
  (assert (listp fact))
  (if (= 2 (length fact))
      ;; changing remove to delete needs thought - at present, the list is shared with the FB component and all other components
      (remove-if #'(lambda (x)
                     (and (eq (first fact) (first x))
                          (eq (second fact) (second x))))
                 fb)
    (if (= 3 (length fact))
      (remove-if #'(lambda (x)
                     (and (eq (first fact) (first x))
                          (eq (second fact) (second x))
                          (eq (third fact) (third x))))
                 fb)
      (error "expected 2 or 3 items, but got ~S" fact))))

(defmethod retract ((self e/part:part) arg1 l g r e n c result)
  ;; TODO: rewrite complete-fb in the return values ; make the change immediate so it affects the current searches
  (let ((local-fb (cl-event-passing-user::@get-instance-var self :fb)))
    (cl-event-passing-user::@set-instance-var self :fb (remove-fact arg1 local-fb)))
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

(defmethod lisp-BoundingBoxCompletelyInside ((self e/part:part)
                                             L1 T1 R1 B1
                                             L2 T2 R2 B2
                                             l g r e n c result)
  (declare (ignore self))
  (values
   (and (>= L1 L2) (>= T1 T2) (>= R2 R1) (>= B2 B1))
   l g r e n c result))

(defparameter rule-not-same1 '(
                        (:not-same (:? x) (:? x))
    (:lisp (printf 300))     
                        :!
    (:lisp (printf 302))     
                        :fail
    (:lisp (printf 303))     
                        ))

(defparameter rule-not-same2 '(
                         (:not-same (:? x) (:? y))
    (:lisp (printf 304))     
                         :!
    (:lisp (printf 305))     
                         ))

(defparameter rule-not-same (cons rule-not-same1 rule-not-same2))

(defparameter rule-bounding-box '(
                                  (:bounding-box (:? id) (:? left) (:? top) (:? right) (:? bottom))
                                  
                                  (:bounding_box_left (:? id) (:? left))
                                  (:bounding_box_top (:? id) (:? top))
                                  (:bounding_box_right (:? id) (:? right))
                                  (:bounding_box_bottom (:? id) (:? bottom))
                                  ))

(defparameter rule-bounding-box-completely-inside
  '(
    (:bounding-box-completely-inside (:? id10) (:? id20))
    
    (:lisp (printf 200))     
    (:not-same (:? id10) (:? id20))
    (:lisp (printf 201))     
    (:bounding-box (:? id10) (:? L10) (:? T10) (:? R10) (:? B10))
    (:lisp (printf 202))     
    (:bounding-box (:? id20) (:? L20) (:? T20) (:? R20) (:? B20))
    (:lisp (printf 203))     
    (:lisp (lisp-BoundingBoxCompletelyInside (:? L10) (:? T10) (:? R10) (:? B10)
                                             (:? L20) (:? T20) (:? R20) (:? B20)))
    (:lisp (printf 204))
    ))

(defparameter rule-text-completely-inside
  '(
    (:text-completely-inside (:? tid) (:? eid))
    (:lisp (arrowgrams/compiler/util::printf 100))            
    (:bounding-box-completely-inside (:? tid) (:? eid))
    )
  )

(defun rule-text-completely-inside ()
  (list rule-not-same1 rule-not-same2 rule-bounding-box rule-bounding-box-completely-inside rule-text-completely-inside))