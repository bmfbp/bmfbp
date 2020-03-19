(in-package :arrowgrams/build)

(defclass get-code (builder)
  ((counter :accessor counter)))

(defmethod e/part:first-time ((self get-code))
)

(defmethod e/part:react ((self get-code) e)
  (ecase (@pin self e)
    (:in
     ;; input is a filename
     (let ((filename (@data self e)))
       (if (probe-file filename)
	   (let ((code-as-text (read-code-file filename)))
	     (@send self :out code-as-text))
	   (let ((msg (format nil "code file /~s/ not found" filename)))
	     (@send self :error msg)
	     (error msg))))))) ;; lisp error only during bootstrap

(defun read-code-file (filename)
  (alexandria:read-file-into-string filename))
