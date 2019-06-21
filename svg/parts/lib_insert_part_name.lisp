(defun copy-stdin-to-stdout ()
  (let ((sexpr (read *standard-input* nil 'EOF)))
    (loop
       (when (eq 'EOF sexpr)
	 (return))
       (write sexpr)
       (setf sexpr (read *standard-input* nil 'EOF)))))

(defun run (argv)
  ;(format *error-output* "in lib_~%")
  (let ((sexpr (read *standard-input* nil 'EOF)))
    (assert (not (eq 'EOF sexpr)))
    (assert (listp sexpr))
    (let* ((name `(component ,(second argv)))
	   (new (cons name sexpr)))
      (write new))
    (copy-stdin-to-stdout)))

#+lispworks
(defun main ()
  (run sys:*line-arguments-list*))

#+sbcl 
(defun main (argv)
  (run argv))

