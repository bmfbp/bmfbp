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
  (setf *debugger-hook* #'(lambda (c h)
 			    (declare (ignore h))
 			    (print c)
 			    (abort)))
  (run *standard-input*))

#+lispworks
(defun main (fname)
  (with-open-file (f fname :direction :input)
    (run f)))

