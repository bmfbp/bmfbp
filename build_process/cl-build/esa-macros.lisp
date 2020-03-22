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

