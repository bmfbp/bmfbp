(defpackage :arrowgram
  (:use :cl :paip))

(defpackage :prolog
  (:use :cl :paip)
  (:export
   #:directive
   #:list
   #:minus
   #:plus
   #:mul
   #:div
   #:same
   #:not-same
   #:greater-equal
   #:less-equal
   #:not
   #:not-unify
   #:unify
   #:not-unify-same
   #:unify-same
   #:is
   #:defrule
   #:user-error
   #:current-input
   #:user-input
   #:true
   #:fail
   #:colon-dash
   #:cut
   #:dot
   #:comma
   #:lpar
   #:rpar
   #:l-bracket
   #:r-bracket
   #:or-bar

   #:fixops
   ))


