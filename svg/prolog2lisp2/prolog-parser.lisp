(in-package :arrowgrams/parser/prolog)

(defun parse-prolog (&optional (filename (asdf:system-relative-pathname :arrowgrams/parser/prolog "svg/prolog2lisp2/test.prolog")))
  (let ((prolog-parser
         (cl-event-passing-user::@defnetwork TOP
             (:code eol-comments (:in) (:request :out :error) #'arrowgrams/parser/eol-comments::react #'arrowgrams/parser/eol-comments::first-time)
             (:code readf (:filename) (:out :fatal) #'arrowgrams/parser/read-file-into-string::react)
             (:code ws (:in) (:out :error) #'arrowgrams/parser/ws::react #'arrowgrams/parser/ws::first-time)
             (:code tcounter (:in) (:out :fatal) #'arrowgrams/parser/token-counter::react #'arrowgrams/parser/token-counter::first-time)
             (:code chars (:in-string :request) (:out :error) #'arrowgrams/parser/chars::react #'arrowgrams/parser/chars::first-time)
             (:schem TOP (:filename) (:out :error)
              ;; parts
              (eol-comments readf chars tcounter ws)
              ;; wiring
              (
               (((:self :filename)) ((readf :filename)))

               (((readf :out)) ((chars :in-string)))

               (((chars :out)) ((eol-comments :in))) ;; chars from "chars" go to comments
               (((eol-comments :request)) ((chars :request))) ;; request from chars eol-comments loops, then immediately back into chars (this prevents 'chars' from zipping through the whole file and creating too many events at once)


               (((eol-comments :out)) ((ws :in)))
               ;(((eol-comments :out)) ((tcounter :in)))
               
               (((ws :out)) ((tcounter :in)))

               (((tcounter :out)) ((:self :out)))

               (((readf :fatal) (chars :error) (eol-comments :error) (ws :error) (tcounter :fatal))
                ((:self :error))
               
               ))))))

    (let ((parser-input-filename-pin (cl-event-passing-user::@get-input-pin prolog-parser :filename)))
      (cl-event-passing-user::@with-dispatch
       (cl-event-passing-user::@inject prolog-parser parser-input-filename-pin filename)))))

