(defpackage :arrowgrams/compiler/back-end
  (:use :cl)
  (:export
   #:need
   #:look-ahead-p
   #:emit

   #:token-text
   #:accepted-token
   #:accepted-symbol-must-be-nil
   #:output-stream))

(defpackage :arrowgrams/compiler/back-end/generic
  (:use :cl))
(defpackage :arrowgrams/compiler/back-end/json
  (:use :cl))
(defpackage :arrowgrams/compiler/back-end/lisp
  (:use :cl))
