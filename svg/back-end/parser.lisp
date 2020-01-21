(in-package :arrowgrams/compiler/back-end)

(defun parser (filename)
  (let ((parser-net
         (cl-event-passing-user::@defnetwork parser

            (:code tokenize (:start :pull) (:out :error) #'tokenize-react #'tokenize-first-time)
            (:code parens (:token) (:out :error) #'parens-react #'parens-first-time)
            (:code spaces (:token) (:request :out :error) #'spaces-react #'spaces-first-time)
            (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)
            (:code symbols (:token) (:request :out :error) #'symbols-react #'symbols-first-time)
            (:code dumper (:start :in) (:out :request :error) #'dumper-react #'dumper-first-time)

            (:schem parser (:start) (:out :error)
             (dumper tokenize parens strings symbols spaces) ;; parts

;; wiring - see wiring.lisp
#+nil((((:SELF :START)) ((DUMPER :START) (TOKENIZE :START)))  ;; no symbols, no strings
 (((DUMPER :REQUEST) (SYMBOLS :REQUEST)) ((TOKENIZE :PULL)))
 (((TOKENIZE :OUT)) ((PARENS :TOKEN)))
 (((PARENS :OUT)) ((SPACES :TOKEN)))
 (((SPACES :OUT)) ((DUMPER :IN)))
 (((DUMPER :OUT)) ((:SELF :OUT)))
 (((DUMPER :ERROR) (TOKENIZE :ERROR) (PARENS :ERROR) (STRINGS :ERROR) (SYMBOLS :ERROR) (SPACES :ERROR)) ((:SELF :ERROR))))

#+nil((((:SELF :START)) ((DUMPER :START) (TOKENIZE :START)))
 (((DUMPER :REQUEST) (STRINGS :REQUEST) (SYMBOLS :REQUEST)) ((TOKENIZE :PULL)))
 (((TOKENIZE :OUT)) ((STRINGS :TOKEN)))
 (((STRINGS :OUT)) ((PARENS :TOKEN)))
 (((PARENS :OUT)) ((SPACES :TOKEN)))
 (((SPACES :OUT)) ((DUMPER :IN)))     ;; no symbols
 (((DUMPER :OUT)) ((:SELF :OUT)))
 (((DUMPER :ERROR) (TOKENIZE :ERROR) (PARENS :ERROR) (STRINGS :ERROR) (SYMBOLS :ERROR) (SPACES :ERROR)) ((:SELF :ERROR))))

#+nil((((:SELF :START)) ((DUMPER :START) (TOKENIZE :START)))
 (((DUMPER :REQUEST) (STRINGS :REQUEST) (SYMBOLS :REQUEST)) ((TOKENIZE :PULL)))
 (((TOKENIZE :OUT)) ((STRINGS :TOKEN)))
 (((STRINGS :OUT)) ((PARENS :TOKEN)))
 (((PARENS :OUT)) ((SPACES :TOKEN)))
 (((SPACES :OUT)) ((SYMBOLS :TOKEN)))  ;; with symbols
 (((SYMBOLS :OUT)) ((DUMPER :IN)))
 (((DUMPER :OUT)) ((:SELF :OUT)))
 (((DUMPER :ERROR) (TOKENIZE :ERROR) (PARENS :ERROR) (STRINGS :ERROR) (SYMBOLS :ERROR) (SPACES :ERROR)) ((:SELF :ERROR))))

((((:SELF :START)) ((DUMPER :START) (TOKENIZE :START))) ;; symbols only
 (((DUMPER :REQUEST) (SYMBOLS :REQUEST)) ((TOKENIZE :PULL)))
 (((TOKENIZE :OUT)) ((SYMBOLS :TOKEN)))
 (((SYMBOLS :OUT)) ((DUMPER :IN)))
 (((DUMPER :OUT)) ((:SELF :OUT)))
 (((DUMPER :ERROR) (TOKENIZE :ERROR) (SYMBOLS :ERROR)) ((:SELF :ERROR))))   

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