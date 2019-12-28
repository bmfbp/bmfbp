(in-package :arrowgrams/prolog-peg)

(defparameter *rules-defined* nil)

(defun init ()
  (setf *rules-defined* nil))

(defun memo-rule-definition (head)
  (assert (or (symbolp head)
              (listp head)))
  (assert (or (symbolp head)
              (not (null head))))
  (let ((arity (if (symbolp head)
                   0
                 (1- (length head))))
        (sym (if (symbolp head)
                 head
               (car head)))
        (kw-pkg (find-package :keyword)))
    (assert (eq kw-pkg (symbol-package sym)))
    (let ((rule-name (intern (format nil "~a/~a" (string-upcase (symbol-name sym)) arity) kw-pkg)))
      (pushnew rule-name *rules-defined*))))