(in-package :arrowgrams/compiler/back-end)

(defun parser (filename)
  (let ((parser-net
         (cl-event-passing-user::@defnetwork parser

            (:code tokenize (:start :next) (:out :error) #'tokenize-react #'tokenize-first-time)
            (:code parens (:next) (:out :error) #'parens-react #'parens-first-time)
            (:code dumper (:start :next) (:out :request :error) #'dumper-react #'dumper-first-time)

            (:schem parser (:start) (:out :error)
             (dumper tokenize parens) ;; parts

             ( ;; wiring
              (((:self :start))                        ;; from
               ((tokenize :start) (dumper :start)))   ;; to

              (((dumper :request))
               ((tokenize :next)))

              (((tokenize :out))
               ((parens :next)))

              (((parens :out))
               ((dumper :next)))

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