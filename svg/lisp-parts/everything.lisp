(in-package :paip)

(defparameter *all-bindings* nil)

(defmacro all-solutions (&rest goals)
  `(progn
     (setf *all-bindings* nil)
     (top-level-everything ',(paip::replace-?-vars goals))
     *all-bindings*))

(defun top-level-everything (goals)
  (paip::prove-all `(,@goals (everything ,@(paip::variables-in goals)))
             paip::no-bindings)
  (values))

(defun everything (vars bindings other-goals)
  "Print each variable with its binding.
  Then ask the user if more solutions are desired."
  (declare (ignore other-goals))
  (if (null vars)
      (format t "~&Yes")
    (let ((L nil))
      (dolist (var vars)
        (push (cons var (paip::subst-bindings bindings var)) L))
      (push L *all-bindings*)))
  fail)

(setf (get 'everything 'clauses) 'everything)

