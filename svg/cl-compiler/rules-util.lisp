(in-package :arrowgrams/compiler)

(defparameter *counter* 0)

(defconstant +manually-defined-rules+
  '(
    ((:not-same (:? X) (:? Y))
     :!
     :fail
     )
    ((:not-same (:? X) (:? Y))
     :!)

    ((:not-used (:? X))
     (:used (:? x))
     :!
     :fail)
    (:not-used (:? X)
     :!)

    ((:not-namedSink (:? x))
     (:namedSink (:? x))
     :!
     :fail)
    ((:not-namedSink (:? x))
     :!)
    ))

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
