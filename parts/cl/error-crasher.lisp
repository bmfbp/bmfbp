;; input
;; error - prints error, crashes

(defclass error-crasher (node) () )

(defmethod initially ((self error-crasher))
  (declare (ignore self)))

(defmethod react ((self error-crasher) (e event))
  (declare (ignore self))
  (let ((error-message (format nil "ERROR: ~s~%" e)))
    (format *standard-output* error-message)
    (error error-message)))
