(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

(cl-peg:rule arrowgrams/prolog-peg::Comment "'%' CommentStuff* EndOfLine"
 (:lambda (list) (declare (ignore list))
   (values)))

(cl-peg:rule arrowgrams/prolog-peg::CommentStuff "!EndOfLine char1"
  (:lambda (x) (declare (ignore x)) (values)))
 
(cl-peg:rule arrowgrams/prolog-peg::char1 "."
  (:lambda (c)
    c))
 
