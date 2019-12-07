(in-package :prolog)

(defun reset-esrap () 
  (maphash #'(lambda (k v)
               (declare (ignore v))
               (format *standard-output* "~&~A~%" k)
               (esrap::delete-rule-cell k))
           esrap::*rules*)
  (setf esrap::*rules* (make-hash-table)))