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
            (:code generic-parser (:start :in :doparse) (:go :out :request :error) #'generic-parser-react #'generic-parser-first-time)

            (:schem parser (:start) (:out :error)
             (generic-parser tokenize parens strings symbols spaces integers ) ;; parts

;; wiring - see wiring.lisp
((((:SELF :START)) ((generic-parser :START) (TOKENIZE :START)))
 (((generic-parser :REQUEST) (spaces :request) (STRINGS :REQUEST) (SYMBOLS :REQUEST) (INTEGERS :REQUEST)) ((TOKENIZE :PULL)))
 (((TOKENIZE :OUT)) ((STRINGS :TOKEN)))
 (((STRINGS :OUT)) ((PARENS :TOKEN)))
 (((PARENS :OUT)) ((SPACES :TOKEN)))
 (((SPACES :OUT)) ((SYMBOLS :TOKEN)))
 (((SYMBOLS :OUT)) ((INTEGERS :TOKEN)))
 (((INTEGERS :OUT)) ((GENERIC-PARSER :IN)))
 (((GENERIC-PARSER :go)) ((generic-parser :doparse)))
 (((GENERIC-PARSER :OUT)) ((:SELF :OUT)))
 (((GENERIC-PARSER :ERROR) (TOKENIZE :ERROR) (PARENS :ERROR) (STRINGS :ERROR) (SYMBOLS :ERROR) (SPACES :ERROR) (INTEGERS :ERROR)) ((:SELF :ERROR))))


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