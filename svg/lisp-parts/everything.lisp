;; extend paip prolog functionality

(in-package :paip)

;(defmacro ?- (&rest goals) `(top-level-prove ',(replace-?-vars goals)))

;;;;;;;;;;;;;;

(defun unify (x y &optional (bindings no-bindings))
  "See if x and y match with given bindings."
;  (format *error-output* "~&unify (x=/~S/ y=/~S/ bindings=/~S/)~%" x y bindings)
  (cond ((eq bindings fail) fail)
        ((eql x y) bindings)
        ((variable-p x) (unify-variable x y bindings))
        ((variable-p y) (unify-variable y x bindings))
        ((and (consp x) (consp y))
         (unify (rest x) (rest y)
                (unify (first x) (first y) bindings)))
        (t fail)))

(defun top-level-prove (goals)
;  (format *error-output* "~&top-level-prove (goals=/~S/)~%" goals)
  (prove-all `(,@goals (show-prolog-vars ,@(variables-in goals)))
             no-bindings)
  (format t "~&No.")
  (values))

(defun prove-all (goals bindings)
  "Find a solution to the conjunction of goals."
  (format *error-output* "~&prove-all (goals=/~S/, bindings=/~S/) ~%" goals bindings)
  (cond ((eq bindings fail) fail)
        ((null goals) bindings)
        (t (prove (first goals) bindings (rest goals)))))

(defun prove (goal bindings other-goals)
  "Return a list of possible solutions to goal."
  (let ((clauses (get-clauses (predicate goal))))
  (format *error-output* "~&prove (goal=/~S/, bindings=/~S/, other-goals=/~S/) predicate=/~S/ clauses=/~S/~%" 
          goal bindings other-goals (predicate goal) clauses)
    (if (listp clauses)
        (some
          #'(lambda (clause)
              (let ((new-clause (rename-variables clause)))
                (prove-all
                  (append (clause-body new-clause) other-goals)
                  (unify goal (clause-head new-clause) bindings))))
          clauses)
        ;; The predicate's "clauses" can be an atom:
        ;; a primitive function to call
        (funcall clauses (rest goal) bindings
                 other-goals))))

(defun show-prolog-vars (vars bindings other-goals)
  "Print each variable with its binding.
  Then ask the user if more solutions are desired."
  (if (null vars)
      (format t "~&Yes")
      (dolist (var vars)
        (format t "~&~a = ~a" var
                (subst-bindings bindings var))))
  (if (continue-p)
      (progn
        (format *error-output* "~&show-prolog-vars fails~%")
        fail)
    (progn
      (format *error-output* "~&show-prolog-vars calls prove-all~%")
      (prove-all other-goals bindings))))
;;;;;;;;;;;;;;

(defparameter *all-bindings* nil)

(defmacro all-solutions (&rest goals)
  `(progn
     (setf *all-bindings* nil)
     (top-level-everything ',(replace-?-vars goals))
     *all-bindings*))

(defun top-level-everything (goals)
  (prove-all `(,@goals (everything ,@(variables-in goals)))
             no-bindings)
  (values))

(defun everything (vars bindings other-goals)
  "Print each variable with its binding.
  Then ask the user if more solutions are desired."
  (declare (ignore other-goals))
  (if (null vars)
      (format t "~&Yes")
    (let ((L nil))
      (dolist (var vars)
        (push (cons var (subst-bindings bindings var)) L))
      (push L *all-bindings*)))
  fail)

(setf (get 'everything 'clauses) 'everything)

