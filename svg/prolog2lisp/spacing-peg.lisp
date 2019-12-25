(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

(cl-peg:rule arrowgrams/prolog-peg::Spacing "(pSpace / Comment)*"
 (:lambda (list)
   (declare (ignore list))
   (values)))
 
(cl-peg:rule arrowgrams/prolog-peg::pSpace "' ' / '\\t' / EndOfLine"
  (:lambda (list) (declare (ignore list))
    (values)))
 
(cl-peg:rule arrowgrams/prolog-peg::EndOfLine "'\\r\\n' / '\\n' / '\\r'"
  (:lambda (list) (declare (ignore list))
    (values)))

