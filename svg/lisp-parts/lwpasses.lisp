(in-package :arrowgram)

(defparameter *facts* 
  '(
    arrow
    arrow_x
    arrow_y
    bounding_box_bottom
    bounding_box_left
    bounding_box_right
    bounding_box_top
    center_x
    center_y
    comment
    component
    distance_xy
    edge
    ellipse
    eltype
    geometry_center_x
    geometry_center_y
    geometry_h
    geometry_left_x
    geometry_top_y
    geometry_w
    join_centerPair
    join_distance
    kind
    line
    log
    metadata
    namedSink
    namedSource
    nwires
    parent
    pinless
    port
    portName
    portNameByID
    rect
    roundedrect
    sink
    source
    speechbubble
    text
    unassigned
    used
    wireNum
    ))
  
(defun readfb (stream)
  (flet ((read1 ()
           (read stream nil 'eof)))
    (let ((clause (read1)))
      (@:loop
        (@:exit-when (eq 'eof clause))
        (paiprolog::add-clause (paiprolog::replace-?-vars (list clause)))
        (setf clause (read1))))))

(defun writefb (stream)
  (format *error-output* "~&~%writing~%")
  (let ((preds paiprolog::*db-predicates*))
    (@:loop
     (@:exit-when (null preds))
     (let ((p (pop preds)))
       (if (not (member p *facts*))
           (format *error-output* "~&skip writing clause ~A~%" p)
         (progn
           ;(format *error-output* "~&writing predicate ~A~%" p)
           (let ((clauses (paiprolog::get-clauses p)))
             (@:loop
               (@:exit-when (null clauses))
               (let ((c (pop clauses)))
                 ;(format *error-output* "~&clause /~S/~%" c)
                 (assert (= 1 (length c)))
                 (format stream "~&~a~%"
                         (string-downcase (format nil "~a" (car c)))))))))))))

#+nil
(defun main ()
    (let ((in *standard-input*)
	  (out *standard-output*))
      (readfb in)
      (format *error-output* "~&running~%")
FIXME .. 
      (writefb out)))

#+lispworks
(defun deb ()
;; should be 11/49/1/3 (rects/texts/speech/ellipse) for build_process.svg
  (with-open-file (in "~/projects/bmfbp/svg/js-compiler/temp5.lisp" :direction :input)
    (with-open-file (out "~/projects/bmfbp/svg/js-compiler/lisp-out.lisp" :direction :output :if-exists :supersede)
      (readfb in)
      (format *error-output* "~&running (expected 11/49/1/3)~%")
      (bounding-boxes)
      (assign-parents-to-ellipses)
      (find-comments)
      (find-metadata)
      (add-kinds) ;;;--- works to here
      ;(add-self-ports)
      (writefb out)
      (values))))

#+SBCL
(ASSERT NIL)
