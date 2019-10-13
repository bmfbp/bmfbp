(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

(peg:rule prolog::Spacing "(pSpace / Comment)*"
 (:lambda (list)
   (declare (ignore list))
   (values)))
 
(peg:rule prolog::pSpace "' ' / '\\t' / EndOfLine"
  (:lambda (list) (declare (ignore list))
    (values)))
 
(peg:rule prolog::EndOfLine "'\\r\\n' / '\\n' / '\\r'"
  (:lambda (list) (declare (ignore list))
    (values)))

