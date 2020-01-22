(in-package :arrowgrams/compiler/back-end)

(defun parser (filename)
  (let ((parser-net
         (cl-event-passing-user::@defnetwork parser

            (:code tokenize (:start :pull) (:out :error) #'tokenize-react #'tokenize-first-time)
            (:code parens (:token) (:out :error) #'parens-react #'parens-first-time)
            (:code spaces (:token) (:request :out :error) #'spaces-react #'spaces-first-time)
            (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)
            (:code symbols (:token) (:request :out :error) #'symbols-react #'symbols-first-time)
            (:code integers (:token) (:request :out :error) #'integers-react #'integers-first-time)
            (:code generic-parser (:start :token :doparse) (:go :generic :request :error) #'generic-parser-react #'generic-parser-first-time)

            (:schem parser (:start) (:out :error)
             (generic-parser tokenize parens strings symbols spaces integers) ;; parts
"
self.start -> generic-parser.start,tokenize.start
generic-parser.request,spaces.request,strings.request,symbols.request,integers.request -> tokenize.pull
tokenize.out -> strings.token
strings.out -> parens.token
parens.out -> spaces.token
spaces.out -> symbols.token
symbols.out -> integers.token
integers.out -> generic-parser.token

generic-parser.go -> generic-parser.doparse
generic-parser.generic -> self.out

generic-parser.error,tokenize.error,parens.error,strings.error,symbols.error,spaces.error,integers.error -> self.error
"

          ))))
    
    (cl-event-passing-user:@enable-logging)
    (inject! parser-net :start filename)))

(defun cl-user::test ()
  (let ((filename (asdf:system-relative-pathname :arrowgrams "svg/back-end/test.ir")))
    (arrowgrams/compiler/back-end::parser filename)))

(defun cl-user::clear ()
  (esrap::clear-rules)
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/compiler/back-end))