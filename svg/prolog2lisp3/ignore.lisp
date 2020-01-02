(in-package :arrowgrams/parser)

(defun pr (x)
  (format *standard-output* "~&pr: ~S~%" x)
  x)

(defun ignore-lpar-rpar (x)
  (if (listp x)
      (cond ((and (= 3 (length x)) (char= #\( (second x)) (char= #\) (third x)))
             (first x))
            ((and (= 4 (length x)) (char= #\( (second x)) (char= #\) (fourth x)))
             (list (first x) (third x)))
            (t x))
    x))                  
             
(defun ignore-trailing-not (x)
  (let ((condition (and (listp x)
                        (= 2 (length x))
                        (eq nil (second x)))))
    (format *standard-output* "~&condition: ~a~%" condition)
    (if condition
        (first x)
      x)))

(defun ignore-middle-comma (x)
  (let ((condition (and (listp x)
                        (= 3 (length x))
                        (eq nil (second x)))))
    (format *standard-output* "~&ignore-middle-comma condition: ~a~%" condition)
    (if condition
        (list (first x) (third x))
      x)))

(defun skip-nil (x) (delete nil x))

(defun ignore-leading-space (spc-x)
  (destructuring-bind (spc x)
      spc-x
    (declare (ignore spc))
    x))

