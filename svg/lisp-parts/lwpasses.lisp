(defun readfb (stream)
  (flet ((read1 ()
           (read stream nil 'eof)))
    (let ((clause (read1)))
      (@:loop
        (@:exit-when (eq 'eof clause))
        (add-clause (replace-?-vars (list clause)))
        (setf clause (read1))))))

(defun writefb (stream)
  (let ((preds *db-predicates*))
    (@:loop
     (@:exit-when (null preds))
     (let ((p (pop preds)))
       (let ((clauses (get p 'clauses)))
         (@:loop
          (@:exit-when (null clauses))
          (let ((c (pop clauses)))
            (assert (= 1 (length c)))
            (format stream "~&~a~%"
                    (string-downcase (format nil "~a" (car c)))))))))))

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
;      (find-comments)
      (writefb out)
      (values))))

#+SBCL
(ASSERT NIL)
