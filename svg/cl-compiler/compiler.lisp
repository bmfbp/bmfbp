(in-package :arrowgrams/compiler)

(defun compiler ()
  (let ((compiler-net
          (cl-event-passing-user::@defnetwork compiler
           (:code reader (:file-name) (:string-fact :eof :error)
            #'arrowgrams/compiler/reader::react #'arrowgrams/compiler/reader::first-time)
           (:code fb (:string-fact :lisp-fact :iterate :get-next) (:next :no-more :error)
            #'arrowgrams/compiler/fb::react #'arrowgrams/compiler/fb::first-time)
           (:code writer (:filename :start :next :no-more) (:request :error)
            #'arrowgrams/compiler/writer::react #'arrowgrams/compiler/writer::first-time)

           (:schem compiler (:file-name :prolog-output-filename) (:error)
            ;; parts
            (reader fb writer)
            ;; wiring
            ((((:self :file-name)) ((reader :file-name)))
             (((:self :prolog-output-filename)) ((writer :filename)))

             (((reader :string-fact)) ((fb :string-fact)))
             (((reader :eof)) ((fb :iterate) (writer :start)))

             (((fb :next)) ((writer :next)))
             (((fb :no-more)) ((writer :no-more)))

             (((writer :request)) ((fb :get-next)))

             (((writer :error) (fb :error) (reader :error)) ((:self :error))))))))

    (e/dispatch::ensure-correct-number-of-parts 4) ;; not needed, except in early days of alpha debug, when everything is still in text form
    (e/util::enable-logging)
    (setq arrowgrams/compiler::*top* compiler-net)
    (cl-event-passing-user::@with-dispatch
      (let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/temp5.pro")))
        (cl-event-passing-user::@inject compiler-net
                                        (e/part::get-input-pin compiler-net :file-name)
                                       filename)))))
