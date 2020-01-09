(defpackage :arrowgrams/parser
  (:use :cl :cl-event-passing-user)
  (:export
   #:make-token
   #:token-type
   #:token-value
   #:token-position))

(defpackage :arrowgrams/parser/read-file-into-string
  (:use :cl :cl-event-passing-user :arrowgrams/parser))

(defpackage :arrowgrams/parser/chars
  (:use :cl :cl-event-passing-user :arrowgrams/parser))

(defpackage :arrowgrams/parser/prolog
  (:use :cl :cl-event-passing-user :arrowgrams/parser))

(defpackage :arrowgrams/parser/eol-comments
  (:use :cl :cl-event-passing-user :arrowgrams/parser))

(defpackage :arrowgrams/parser/squote
  (:use :cl :cl-event-passing-user :arrowgrams/parser))

(defpackage :arrowgrams/parser/uint
  (:use :cl :cl-event-passing-user :arrowgrams/parser))

(defpackage :arrowgrams/parser/ident
  (:use :cl :cl-event-passing-user :arrowgrams/parser))

(defpackage :arrowgrams/parser/token-counter
  (:use :cl :cl-event-passing-user :arrowgrams/parser))

(defpackage :arrowgrams/parser/variable
  (:use :cl :cl-event-passing-user :arrowgrams/parser))

(defpackage :arrowgrams/parser/ws
  (:use :cl :cl-event-passing-user :arrowgrams/parser))
