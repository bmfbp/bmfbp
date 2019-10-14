(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package "PROLOG"))

(peg:rule prolog::Comment "'%' CommentStuff* EndOfLine"
 (:lambda (list) (declare (ignore list))
   (values)))

(peg:rule prolog::CommentStuff "!EndOfLine char1"
  (:lambda (x) (declare (ignore x)) (values)))
 
(peg:rule prolog::char1 "."
  (:lambda (c)
    c))
 
