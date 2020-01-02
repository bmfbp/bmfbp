(in-package :arrowgrams/parser)

(defun pr (x)
  (format *standard-output* "~&pr: ~S~%" x)
  x)

(defun ignore-trailing-ws (x)
  (if (and (listp x)
           (listp (last x))
           (equal '((:ws)) (last x)))
      (butlast x)
    x))

(defun ignore-parens (list)
  (if (and
       (= 3 (length list))
       (char= #\( (first list))
       (char= #\) (third list)))
      (second list)
    list))
       
       