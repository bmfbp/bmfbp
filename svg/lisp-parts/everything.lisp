(in-package :arrowgram)

(defparameter *all-bindings* nil)

(defmacro all-solutions (&rest goals)
  `(progn
     (setf *all-bindings* nil)
     (top-level-collect ',(paip::replace-?-vars goals))
     *all-bindings*))

(defun top-level-collect (goals)
  (paip::clear-predicate 'arrowgram::top-level-query)
  (let ((vars (delete '? (paip::variables-in goals))))
    (paip::add-clause `(arrowgram::(top-level-query)
                  ,@goals
                  (arrowgram::collect-solutions ,(mapcar #'symbol-name vars)
                                    ,vars))))
  ;; Now run it
  (paip::run-prolog 'arrowgram::top-level-query/0 #'paip::ignore)
  *all-bindings*)

(defun collect-solutions (vars bindings other-goals)
  (declare (ignore other-goals))
  (if (null vars)
      t
      (let ((L nil))
        (dolist (var vars)
          (push (cons var (paip::subst-bindings bindings var)) L))
        (push L *all-bindings*)
        paip::fail)))

(setf (get 'collect-solutions 'paip::clauses) 'collect-solutions)

