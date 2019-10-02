(ql:quickload :paiprolog)
(ql:quickload :loops)

(defpackage :prolog-user
  (:use :cl :paiprolog)
  (:nicknames :pp)
  (:export
   #:clear-db
   #:add-clause
   #:replace-?-vars
   #:prolog-collect
   #:db-predicates))

(defun pp:clear-db ()
  (paiprolog::clear-db))

(defun pp:add-clause (x)
  (paiprolog::add-clause x))

(defun pp:replace-?-vars (x)
  (paiprolog::replace-?-vars x))

(defun pp:db-predicates ()
  paiprolog::*db-predicates*)
