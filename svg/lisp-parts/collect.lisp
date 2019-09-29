(in-package :arrowgram)

(defparameter *all-bindings* nil)

(defmacro all-solutions (&rest goals)
  `(progn
     (setf *all-bindings* nil)
     (top-level-collect ',(paip::replace-?-vars goals))
     *all-bindings*))

(defun top-level-collect (goals)
  (paip::clear-predicate 'paip::top-level-query)
  (let ((vars (delete '? (paip::variables-in goals))))
    (paip::add-clause `((paip::top-level-query)
                        ,@goals
                        (arrowgram::collect-prolog-vars
			 ,(mapcar #'symbol-name vars)
                         ,vars))))
  (paip::run-prolog 'paip::top-level-query/0 #'paip::ignore)
  *all-bindings*)

;; callable from prolog clause
(defun arrowgram::collect-prolog-vars/2 (var-names vars cont)
  (let ((L nil))
    (if (null vars)
	*all-bindings*
	(progn
	  (loop for name in var-names
             for var in vars 
	     do (push (cons name var) L))
	  (push L *all-bindings*))))
  (if t
      (funcall cont)
      (throw 'paip::top-level-prove nil)))
