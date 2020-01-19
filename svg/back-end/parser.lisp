(in-package :arrowgrams/compiler/back-end)

(defun parser (filename)
  (let ((parser-net
         (cl-event-passing-user::@defnetwork parser

            (:code tokenize (:start :pull) (:out :error) #'tokenize-react #'tokenize-first-time)
            (:code parens (:token) (:out :error) #'parens-react #'parens-first-time)
            (:code strings (:token) (:request :out :error) #'strings-react #'strings-first-time)
            (:code dumper (:start :in) (:out :request :error) #'dumper-react #'dumper-first-time)

            (:schem parser (:start) (:out :error)
             (dumper tokenize parens strings) ;; parts

             ( ;; wiring
              (((:self :start))                        ;; from
               ((tokenize :start) (dumper :start)))   ;; to

              (((dumper :request) (strings :request))
               ((tokenize :pull)))

              (((tokenize :out))
               ((parens :token)))

              (((parens :out))
               ((strings :token)))

              (((strings :out))
               ((dumper :in)))

              (((dumper :out))
               ((:self :out)))

              (((dumper :error) (tokenize :error))    ;; from
               ((:self :error)))                       ;; to

              )))))
    
    (cl-event-passing-user::@enable-logging)
    (inject! parser-net :start filename)))

(defun cl-user::test ()
  (let ((filename (asdf:system-relative-pathname :arrowgrams "svg/back-end/test.ir")))
    (arrowgrams/compiler/back-end::parser filename)))

(defun cl-user::clear ()
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/compiler/back-end))