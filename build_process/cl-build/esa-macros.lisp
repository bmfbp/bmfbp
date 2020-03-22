(in-package :arrowgrams/build)

(defmacro esa-if (expr &body body)
  (cond ((= 1 (length body))
	 `(cond ((eq :true ,expr) ,@body)
		((eq :false ,expr))
		(t (esa-if-failed-to-return-true-false (format nil "~s" '(esa-if ,expr ,@body))))))
	((= 2 (length body))
	 `(cond ((eq :true ,expr) ,@(first body))
		((eq :false ,expr) ,@(second body))
		(t (esa-if-failed-to-return-true-false (format nil "~s" '(esa-if ,expr ,@body))))))
	(t (error "~&esa-if syntax error ~s" (list 'esa-if expr body)))))

(defmacro esa-when (expr &body body)
  `(when (esa-expr-true ,expr)
     ,@body))

(defun esa-expr-true (x)
  (cond ((eq :true x) t)
        ((eq :false x) nil)
        (t (error (format nil "~&esa expression returned /~s/, but expected :true or :false" x)))))
  