(defmacro bmassert (expr)
  `(unless ,expr
     (format *error-output* "assertion ~A failed~%" ',expr)
     #+sbcl (sb-ext:quit)))


(defun copy-stdin-to-stdout ()
  (let ((sexpr (read *standard-input* nil 'EOF)))
    (loop
       (when (eq 'EOF sexpr)
	 (return))
       (write sexpr)
       (setf sexpr (read *standard-input* nil 'EOF)))))

(defun run (argv)
  (let ((sexpr (read *standard-input* nil 'EOF)))
    (bmassert (not (eq 'EOF sexpr)))
    ;(format *error-output* "~&sexpr=~S~%" sexpr)
    (bmassert (listp sexpr)) ;; assert that stdin has a factbase on it
    (let* ((name `(component ,(second argv)))
	   (new (cons name sexpr)))
      (write new))
    (copy-stdin-to-stdout)))

#+lispworks
(defun main ()
  (run sys:*line-arguments-list))

#+sbcl 
(defun main (argv)
  (sb-ext:disable-debugger)
  (run argv))

