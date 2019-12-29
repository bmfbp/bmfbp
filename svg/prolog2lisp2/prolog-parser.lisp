(in-package :arrowgrams/parser/prolog)

(defun parse-prolog (filename)
  (let ((prolog-parser
         (cl-event-passing-user::@defnetwork TOP
             (:code eol-comments (:in) (:request :out :error)
              #'arrowgrams/parser/eol-comments::react
              #'arrowgrams/parser/eol-comments::first-time)
             (:code readf (:filename) (:out :fatal) #'arrowgrams/parser/read-file-into-string::react)
             (:code chars (:in-string :request) (:out :error)
              #'arrowgrams/parser/chars::react
              #'arrowgrams/parser/chars::first-time)
             (:schem TOP (:filename) (:out :error)
              ;; parts
              (eol-comments readf chars)
              ;; wiring
              (
               (((:self :filename)) ((readf :filename)))

               (((readf :out)) ((chars :in-string)))
               
               (((eol-comments :request)) ((chars :request))) ;; request from chars eol-comments loops, then immediately back into chars (this prevents 'chars' from zipping through the whole file and creating too many events at once)

               (((chars :out)) ((eol-comments :in))) ;; chars from "chars" go to comments
               
               (((eol-comments :out)) ((:self :out)))
               )))))

    (let ((parser-input-filename-pin (cl-event-passing-user::@get-input-pin prolog-parser :filename)))
      (cl-event-passing-user::@with-dispatch
       (cl-event-passing-user::@inject prolog-parser parser-input-filename-pin
                                       (asdf:system-relative-pathname :arrowgrams/parser/prolog "svg/prolog2lisp2/test.prolog"))))))
