(defpackage :arrowgram
  (:use :cl :paip))

(defpackage :prolog
  (:use :cl :paip)
  (:export
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
   #:is
   #:defrule

   #:fixops
   ))


