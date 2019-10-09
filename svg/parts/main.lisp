(defun run (strm)
  (init-string-map)
  (let ((lst (read strm nil nil)))
    ;; bug fix
    (let ((list (if
                 (and
                  (= 3 (length lst))
                  (null (third lst))
                  (listp (second lst)))
		 (progn
		   (format *error-output* "~%~%bug fixed in temp1.lisp~%~%")
                   (cons (first lst) (second lst)))
                 lst)))
      ;; end bug fix
      (assert (listp list) () "run not a list list=/~a/" list)
      (let ((fixed 
             (mapcar #'fix-translates
		     (mapcar #'collapse-lines
			     (mapcar #'fix-arrows
				     (mapcar #'fix-lines
					     (mapcar #'create-text-objects 
						     list)))))))
	(to-prolog fixed *standard-output*)
	(write-string-map "temp-string-map.lisp" "strings.sed")))))

#-lispworks
(defun main (argv)
  (declare (ignore argv))
  (handler-case
      (progn
	(run *standard-input*))
    (end-of-file (c)
      (format *error-output* "FATAL 'end of file error; in main /~S/~%" c))
    (simple-error (c)
      (format *error-output* "FATAL error in main /~S/~%" c))
    (error (c)
      (format *error-output* "FATAL error in main /~S/~%" c))))

#+lispworks
(defun main (fname)
  (with-open-file (f fname :direction :input)
    (run f)))

