(in-package :arrowgrams/prolog-peg)

(defparameter *rules-defined* nil)
(defparameter *rules-or-functors-called* nil)

(defun init ()
  (setf *rules-defined* nil)
  (setf *rules-or-functors-called* nil))

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

(defun memo-clause (clause)
  (assert (or
           (symbolp clause)
           (listp clause)))
  (unless (null clause)
    (let ((sym (if (symbolp clause)
                   clause
                 (car clause)))
          (arity (if (symbolp clause)
                     0
                   (1- (length clause)))))
      (unless (hprolog::var? sym)
        (let ((pkg (find-package (symbol-package sym))))
          (assert (symbolp sym))
          (let ((rule-name (intern (format nil "~a/~a" (string-upcase (symbol-name sym)) arity) pkg)))
            (pushnew rule-name *rules-or-functors-called*)))))))
    
(defun diff ()
  (let ((diff1
         (set-difference
          *rules-or-functors-called*
          +facts+)))
    (let ((diff2
           (set-difference diff1 +builtins+)))
      (let ((diff3
             (set-difference diff2 *rules-defined*)))
        diff3))))