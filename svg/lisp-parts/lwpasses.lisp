(in-package :arrowgram)

(defun readfb (stream)
  (let ((original-package *package*))
    (unwind-protect
         (progn 
           (setf *package* (find-package :arrowgram))
           (flet ((read1 ()
                    (read stream nil 'eof)))
             (let ((clause (read1)))
               (@:loop
                 (@:exit-when (eq 'eof clause))
                 (paip::add-clause (paip::replace-?-vars (list clause)))
                 (setf clause (read1))))))
      (setf *package* original-package))))

(defun writefb (stream)
  (let ((preds paip::*db-predicates*))
    (@:loop
     (@:exit-when (null preds))
     (let ((p (pop preds)))
       (let ((clauses (get p 'paip::clauses)))
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

(defun deb ()
;; should be 11/49/1/3 (rects/texts/speech/ellipse) for build_process.svg
  (with-open-file (in (asdf:system-relative-pathname :arrowgram "../js-compiler/temp5.lisp") :direction :input)
    (with-open-file (out (asdf:system-relative-pathname :arrowgram "../js-compiler/lisp-out.lisp") :direction :output :if-exists :supersede)
      (readfb in)
      (format *error-output* "~&running (expected (rects/texts/speech/ellipse) 11/49/1/3)~%")
      (bounding-boxes)
      (assign-parents-to-ellipses)
      #+nil ;; failing!
      (find-comments)
      (writefb out)
      (values))))

