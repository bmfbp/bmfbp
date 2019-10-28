;(in-package :prolog)
(in-package :paip)

(defparameter *all-bindings* nil)

(defmacro all-solutions (&rest goals)
  `(progn
     (setf *all-bindings* nil)
     (top-level-everything ',(paip::replace-?-vars goals))
     (format *standard-output* "~&function-all-solutions final bindings=/~S/~%" *all-bindings*)
     *all-bindings*))

(defun function-all-solutions (goals)
  (paip::prolog-compile-symbols)
  (format *standard-output* "~&function-all-solutions goals=/~S/~%" goals)
  (setf *all-bindings* nil)
  (let ((replaced (paip::replace-?-vars goals)))
    (top-level-everything replaced)
     (format *standard-output* "~&function-all-solutions final bindings=/~S/~%" *all-bindings*)
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
      t
      (let ((L nil))
        (dolist (var vars)
          (push (cons var (paip::subst-bindings bindings var)) L))
        (push L *all-bindings*)
        paip::fail)))

(setf (get 'everything 'paip::clauses) 'everything)

