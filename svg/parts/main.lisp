(defun run (strm)
  (init-string-map)
  (setf *debugger-hook* #'(lambda (c h)
			    (declare (ignore h))
			    (print c)
			    (abort)))
  (let ((list (read strm nil nil)))
    (assert (listp list) () "run not a list list=/~a/" list)
    (let ((comments-removed (remove-if (lambda (sublist)
					 (eq (car sublist) 'speech-bubble))
				       list)))
      (let ((fixed 
             (mapcar #'fix-translates
		     (mapcar #'collapse-lines
			     (mapcar #'fix-arrows
				     (mapcar #'fix-lines
					     (mapcar #'create-text-objects 
						     comments-removed)))))))
	(to-prolog fixed *standard-output*)
	(write-string-map "temp-string-map.lisp")))))

#-lispworks
(defun main (argv)
  (declare (ignore argv))
  (run *standard-input*))

#+lispworks
(defun main (fname)
  (with-open-file (f fname :direction :input)
    (run f)))
