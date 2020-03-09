(defpackage rephrase
  (:use :cl :cl-event-passing-user)
  (:export
   #:rephrase

   #:token
   #:token-kind
   #:token-text
   #:token-line
   #:token-position
   ))
