(in-package :arrowgrams/compiler)

(defparameter *counter* 0)



(defun inc-counter ()
  (incf *counter*))

(defun dec-counter ()
  (decf *counter*))

(defun set-counter (n)
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
  (@:loop
    (@:exit-when (null lis))
    (format *standard-output* "~S " (pop lis))))

(defparameter *distances* nil)
(defparameter *closest* nil)

(defun lisp-collect-begin ()
  (setf *distances* nil)
  (setf *closest* nil))

(defun lisp-collect-distance(text-id string-id port-id distance)
  (push (list distance text-id port-id string-id)
	*distances*))

(defun lisp-collect-finalize ()
  (mapc #'(lambda (dtsp)
	     (if (null *closest*)
		 (setf *closest* dtsp)
	       (let ((dist (first dtsp))
		     (closest-dist (first *closest*)))
		 (if (< dist closest-dist)
		     (setf *closest* dtsp)
		     nil))))
	*distances*))
		 
(defun lisp-return-closest-text ()
  (second *closest*))

(defun lisp-return-closest-port ()
  (third *closest*))

(defun lisp-return-closest-string ()
  (fourth *closest*))

