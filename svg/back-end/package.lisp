(defpackage :arrowgrams/compiler/back-end
  (:use :cl)
  (:nicknames "BE")
  (:export
   #:parser

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
   #:output-stream

   
   ;; scanner
   #:tokenize-react
   #:tokenize-first-time
   #:parens-react
   #:parens-first-time
   #:spaces-react
   #:spaces-first-time
   #:strings-react
   #:strings-first-time
   #:symbols-react
   #:symbols-first-time
   #:integers-react
   #:integers-first-time

   #:preparse-react
   #:preparse-first-time
   #:generic-emitter-react
   #:generic-emitter-first-time
   #:collector-react
   #:collector-first-time
   #:emitter-pass2-generic-react
   #:emitter-pass2-generic-first-time
   #:json-emitter-react
   #:json-emitter-first-time
   #:file-writer-react
   #:file-writer-first-time

   #:file-namer-react
   #:file-namer-first-time

   #:synchronizer-react
   #:synchronizer-first-time

))
