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
            (:schem scanner (:start :request) (:out :error)
             (tokenize parens strings symbols spaces integers) ;; parts
             "
              self.start -> tokenize.start
              self.request,spaces.request,strings.request,symbols.request,integers.request -> tokenize.pull
              tokenize.out -> strings.token
              strings.out -> parens.token
              parens.out -> spaces.token
              spaces.out -> symbols.token
              symbols.out -> integers.token
              integers.out -> self.out

              tokenize.error,parens.error,strings.error,symbols.error,spaces.error,integers.error -> self.error
             "
             )
            (:code preparse (:start :token) (:out :request :error) #'preparse-react #'preparse-first-time)
            (:code generic-parser (:parse) (:out :error) #'generic-parser-react #'generic-parser-first-time)
            (:code generic-json-parser (:parse) (:out :error) #'generic-json-parser-react #'generic-json-parser-first-time)
            (:schem parser (:start) (:out :error)
              (scanner preparse generic-parser generic-json-parser)
              "
               self.start -> scanner.start,preparse.start
               scanner.out -> self.out
               scanner.error,generic-parser.error,generic-json-parser.error,preparse.error -> self.error
               scanner.out -> preparse.token
               preparse.request -> scanner.request

               preparse.out -> generic-parser.parse,generic-json-parser.parse

               generic-parser.out,generic-json-parser.out -> self.out

              ")
             )))

    (cl-event-passing-user:@enable-logging)
    (inject! parser-net :start filename)))

(defun cl-user::test ()
  (let ((filename (asdf:system-relative-pathname :arrowgrams "svg/back-end/test.ir")))
    (arrowgrams/compiler/back-end::parser filename)))

(defun cl-user::clear ()
  (esrap::clear-rules)
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/compiler/back-end))