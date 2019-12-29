(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

;; no floats in the prolog we're working with
(cl-peg:rule arrowgrams/prolog-peg::pNumber "[0-9] pIntegerFollow* Spacing"
  (:destructure (firstNumber rest-list spc)
   (declare (ignore spc))
   (let ((str (esrap:text firstNumber rest-list)))
     (let ((n (parse-integer str)))
       (if (or (null n) (not (numberp n)))
           (progn
             (format *error-output* "~&bad integer : ~s~%" n)
             (assert nil))
         (list :number n))))))

;; no floats, hence we parse only integers
(cl-peg:rule arrowgrams/prolog-peg::pIntegerFollow "[0-9]"
  (:lambda (x)
    x))


