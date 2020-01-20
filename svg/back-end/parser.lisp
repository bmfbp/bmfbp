(in-package :arrowgrams/compiler/back-end)

(defun parser (filename)
  (let ((parser-net
         (cl-event-passing-user::@defnetwork parser

            (:code tokenize (:start :pull) (:out :error) #'tokenize-react #'tokenize-first-time)
            (:code parens (:token) (:out :error) #'parens-react #'parens-first-time)
            (:code spaces (:token) (:request :out :error) #'spaces-react #'spaces-first-time)
            (:code ws (:token) (:request :out :error) #'ws-react #'ws-first-time)
            (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)
            (:code symbols (:token) (:request :out :error) #'symbols-react #'symbols-first-time)
            (:code dumper (:start :in) (:out :request :error) #'dumper-react #'dumper-first-time)

            (:schem parser (:start) (:out :error)
             (dumper tokenize parens strings ws symbols spaces) ;; parts

;; wiring - see wiring.lisp

((((:SELF "start")) ((DUMPER "start") (TOKENIZE "start")))
 (((DUMPER "request") (STRINGS "request") (WS "reqest") (SYMBOLS "request")) ((TOKENIZE "pull")))
 (((TOKENIZE "out")) ((STRINGS "token")))
 (((STRINGS "out")) ((PARENS "token")))
 (((PARENS "out")) ((SPACES "token")))
 (((SPACES "out")) ((SYMBOLS "token")))
 (((SYMBOLS "out")) ((DUMPER "in")))
 (((DUMPER "out")) ((:SELF "out")))
 (((DUMPER "error") (TOKENIZE "error") (PARENS "error") (STRINGS "error") (WS "error") (SYMBOLS "error") (SPACES "error")) ((:SELF "error"))))

             ))))
    
    (cl-event-passing-user::@enable-logging)
    (inject! parser-net :start filename)))

(defun cl-user::test ()
  (let ((filename (asdf:system-relative-pathname :arrowgrams "svg/back-end/test.ir")))
    (arrowgrams/compiler/back-end::parser filename)))

(defun cl-user::clear ()
  (esrap::clear-rules)
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/compiler/back-end))