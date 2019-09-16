(in-package :arrowgram)

(paiprolog:<- (point-completely-inside-bounding-box ?id1 ?id2)
    (bounding_box_left ?id1 ?L1)
    (bounding_box_top ?id1 ?T1)
    
    (bounding_box_left ?id2 ?L2)
    (bounding_box_top ?id2 ?T2)
    (bounding_box_right ?id2 ?R2)
    (bounding_box_bottom ?id2 ?B2)
    
    (>= ?L1 ?L2)
    (>= ?T1 ?T2)
    (>= ?R2 ?L1)
    (>= ?B2 ?T1))

;;;     (lisp ? (and (>= ?L1 ?L2)
;;;                  (>= ?T1 ?T2)
;;;                  (>= ?R2 ?L1)
;;;                  (>= ?B2 ?T1))))

