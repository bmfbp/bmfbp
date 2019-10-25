;(eval-when (:compile-toplevel :load-toplevel :execute)
;  (peg:into-package "PROLOG"))
(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PAIP"))

;; no floats in the prolog we're working with
(peg:rule prolog::pNumber "[0-9] pIntegerFollow* Spacing"
  (:destructure (firstNumber rest-list spc)
   (declare (ignore spc))
   (let ((str (esrap:text firstNumber rest-list)))
     (let ((n (parse-integer str)))
       (if (or (null n) (not (numberp n)))
           (progn
             (format *error-output* "~&bad integer : ~s~%" n)
             (assert nil))
         n)))))

;; no floats, hence we parse only integers
(peg:rule prolog::pIntegerFollow "[0-9]"
  (:lambda (x)
    x))


