(defpackage :arrowgram
  (:use :cl :paip))

(defpackage :paip-extension
  (:use :cl :paip))

(defpackage :prolog
  (:use :cl :paip)
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

   #:function-all-solutions
   ))


