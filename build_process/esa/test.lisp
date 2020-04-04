;; (ql:quickload :loops)

(defparameter *expr*
  '(:call (:field (:call (:field "self" "y") "a" "b") "z") "c" "d"))

(defun emit-expr-as-js (expr s)
  (flet ((print-args ()
	   (let ((args (rest (cdr expr))))
	     (format s "(")
	     (@:loop
	       (@:exit-when (null args))
	       (let ((arg (pop args)))
		 (format s "~a" arg)	   
		 (when args
		   (format s ","))))
	     (format s ")"))))
    (if (or (stringp (second expr))
	    (symbolp (second expr)))
	(ecase (first expr)
	  (:field (format s "~a.~a" (second expr) (third expr)))
	  (:call  (print-args)))
	(progn
	  (emit-expr-as-js (second expr) s)
	  (ecase (first expr)
	    (:field (format s ".~a" (third expr)))
	    (:call  (print-args)))))))

(defun expr-as-cl (expr)
(format *standard-output* "~&expr=~s~%" expr)
  (flet ((u(x) (if (stringp x)
		   (intern (string-upcase x))
		   x)))
    (if (or (stringp (second expr))
	    (symbolp (second expr)))
	(ecase (first expr)
	  (:field `(slot-value ,(u (second expr)) ',(u (third expr))))
	  (:call  `(:call1 ,@(rest (cddr expr)))))
	(progn
	  (let ((inner (u (expr-as-cl (second expr)))))
	    (ecase (first expr)
	      (:field `(slot-value ,inner ',(u (third expr))))
	      (:call  `(:call2 ,inner ,@(mapcar #'u (rest (rest expr)))))))))))

(defun test-both (e)
  (with-output-to-string (s)
    (format s "~%")
    (emit-expr-as-js e s)
    (format s "~%~%")
    (let ((cl-expr (expr-as-cl e)))
      (format s "~&~s~%" cl-expr)
      cl-expr)))

(defun test ()
  (test-both *expr*))

    
