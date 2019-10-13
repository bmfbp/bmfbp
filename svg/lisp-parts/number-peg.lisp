(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

;; no floats in the prolog we're working with
(peg:rule prolog::Number "[0-9] IntegerFollow*"
  (:destructure (firstNumber rest-list)
   (let ((str (esrap:text firstNumber rest-list)))
     (let ((n (parse-integer str)))
       (if (or (null n) (not (numberp n)))
           (progn
             (format *error-output* "~&bad integer : ~s~%" n)
             (assert nil))
         n)))))

;; no floats, hence we parse only integers
(peg:rule prolog::IntegerFollow "[0-9]"
  (:lambda (x)
    x))


