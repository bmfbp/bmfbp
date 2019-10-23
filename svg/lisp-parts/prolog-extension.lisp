;(in-package :prolog)
(in-package :paip)

;; prolog

(defun true/0 (cont)
  (funcall cont))

(defun halt/0 (cont)
  (declare (ignore cont))
  )

(defun pl-true/0 (cont)
  (declare (ignore cont))
  )

(defun directive/0 (cont)
  (funcall cont))

(defun readfb/1 (x cont)
  (declare (ignore x))
  (funcall cont))

(defun writefb/0 (cont)
  (funcall cont))

(defun asserta/1 (exp cont)
  (paip::add-clause (list exp))
  (funcall cont))

(defun forall/2 (exp1 exp2 cont)
  (format *standard-output* "~&forall exp1=~S~%exp2=~S~%~%" exp1 exp2)
  (let ((solns (prolog:function-all-solutions exp1)))
    (format *standard-output* "~&forall part2 solns=~S~%~%" solns)))


;; lisp

(defun directive ()
  )