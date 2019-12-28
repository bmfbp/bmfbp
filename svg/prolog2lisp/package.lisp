(defpackage arrowgrams/prolog-peg
  (:use :cl))

(defpackage :prolog
  (:use :cl)
  (:export
   #:directive
   #:pl-list
   #:minus
   #:plus
   #:mul
   #:div
   #:same
   #:not-same
   #:greater-equal
   #:less-equal
   #:pl-not
   #:not-unify
   #:unify
   #:not-unify-same
   #:unify-same
   #:pl-is
   #:defrule
   #:user-error
   #:current-input
   #:user-input
   #:pl-true
   #:pl-fail
   #:colon-dash
   #:cut
   #:dot
   #:comma
   #:lpar
   #:rpar
   #:l-bracket
   #:r-bracket
   #:or-bar

   #:assert
   #:retract
   #:forall
   #:function-all-solutions
   ))