(defpackage :arrowgrams/compiler/back-end
  (:use :cl)
  (:export
   #:need
   #:look-ahead-p
   #:emit

   #:send!

   #:token
   #:token-kind
   #:token-text
   #:token-position
   #:token-pulled-p
   #:accepted-token
   #:accepted-symbol-must-be-nil
   #:get-accepted-token-text
   #:output-stream))

(defpackage :arrowgrams/compiler/back-end/generic
  (:use :cl))
(defpackage :arrowgrams/compiler/back-end/collector
  (:use :cl))
(defpackage :arrowgrams/compiler/back-end/json-emitter
  (:use :cl))
(defpackage :arrowgrams/compiler/back-end/lisp
  (:use :cl))
