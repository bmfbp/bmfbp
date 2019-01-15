(defun run (strm)
  (let ((list (read strm)))
    (assert (listp list) () "run list=/~a/" list)
    (let ((fixed 
           (mapcar #'fix-translates
		   (mapcar #'collapse-lines
			   (mapcar #'fix-arrows
				   (mapcar #'fix-lines
					   (mapcar #'create-text-objects list)))))))
      (to-prolog fixed *standard-output*))))

#-lispworks
(defun main (argv)
  (declare (ignore argv))
  (run *standard-input*))

#+lispworks
(defun main (fname)
  (with-open-file (f fname :direction :input)
    (run f)))
