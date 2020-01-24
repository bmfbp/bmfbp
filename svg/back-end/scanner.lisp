(in-package :arrowgrams/compiler/back-end)

(defun scanner (filename)
  (let ((scanner-net
         (cl-event-passing-user::@defnetwork scanner

            (:code tokenize (:start :pull) (:out :error) #'tokenize-react #'tokenize-first-time)
            (:code parens (:token) (:out :error) #'parens-react #'parens-first-time)
            (:code spaces (:token) (:request :out :error) #'spaces-react #'spaces-first-time)
            (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)
            (:code symbols (:token) (:request :out :error) #'symbols-react #'symbols-first-time)
            (:code integers (:token) (:request :out :error) #'integers-react #'integers-first-time)
            (:code dumper (:start :in) (:out :request :error) #'dumper-react #'dumper-first-time)

            (:schem scanner (:start) (:out :error)
             (dumper tokenize parens strings symbols spaces integers ) ;; parts

;; wiring - see wiring.lisp
((((:SELF :START)) ((DUMPER :START) (TOKENIZE :START)))
 (((DUMPER :REQUEST) (spaces :request) (STRINGS :REQUEST) (SYMBOLS :REQUEST) (INTEGERS :REQUEST)) ((TOKENIZE :PULL)))
 (((TOKENIZE :OUT)) ((STRINGS :TOKEN)))
 (((STRINGS :OUT)) ((PARENS :TOKEN)))
 (((PARENS :OUT)) ((SPACES :TOKEN)))
 (((SPACES :OUT)) ((SYMBOLS :TOKEN)))
 (((SYMBOLS :OUT)) ((INTEGERS :TOKEN)))
 (((INTEGERS :OUT)) ((DUMPER :IN)))
 (((DUMPER :OUT)) ((:SELF :OUT)))
 (((DUMPER :ERROR) (TOKENIZE :ERROR) (PARENS :ERROR) (STRINGS :ERROR) (SYMBOLS :ERROR) (SPACES :ERROR) (INTEGERS :ERROR)) ((:SELF :ERROR))))


          ))))
    
    (cl-event-passing-user:@enable-logging)
    (inject! scanner-net :start filename)))

(defun cl-user::scanner-test ()
  (let ((filename (asdf:system-relative-pathname :arrowgrams "svg/back-end/test.ir")))
    (arrowgrams/compiler/back-end::scanner filename)))
