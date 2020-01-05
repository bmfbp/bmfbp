(in-package :arrowgrams/compiler)

(defparameter *counter* 0)



(defun inc-counter ()
  (incf *counter*))

(defun dec-counter ()
  (decf *counter*))

(defun assign-counter (n)
  (setf *counter* n))

(defun read-counter ()
  *counter*)

(defun out-space ()
  (format *standard-output* " "))

(defun out-nl ()
  (format *standard-output* "~%"))

(defun true ()
  t)

(defun out (&rest lis)
  (format *standard-output* "~&out: ")
  (@:loop
    (@:exit-when (null lis))
    (format *standard-output* "~S " (pop lis))))
