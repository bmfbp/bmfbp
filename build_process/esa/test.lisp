(defparameter *expr*
  '(:call (:field (:call (:field self y) a b) z) c d))

(defun emit-as-js (expr s)
  (unless (null expr)
    (let ((kind (first expr))
	  (inner (if (listp (second expr))
		    (emit-as-js (second expr) s)
		   (second expr)))
	  (args (rest (cddr expr))))
    (ecase kind
      (:call
       (format s "~s(" inner)
       (@:loop
	 (@:exit-when (null args))
	 (let ((arg (pop args)))
	   (format s "~s" arg)	   
	   (when args
	     (format s ","))))
       (format s ")~%)"))
      (:field
       (format s "~s.~s" inner (third expr)))
       ))))

(defun emit-as-cl (expr s)
  (format s "~&cl niy ~s~%" expr))

(defun test ()
  (with-output-to-string (s)
    (emit-as-js *expr* s)
    (format s "~%~%")
    (emit-as-cl *expr* s)))


    
