(in-package :arrowgrams/compiler)

(defun compiler ()
  (let ((compiler-net
          (cl-event-passing-user::@defnetwork compiler
           (:code reader (:file-name) (:string-fact :eof :error)
            #'arrowgrams/compiler/reader::react #'arrowgrams/compiler/reader::first-time)
           (:code fb (:string-fact :lisp-fact :go :fb-request :iterate :get-next) (:fb :next :no-more :error)
            #'arrowgrams/compiler/fb::react #'arrowgrams/compiler/fb::first-time)
           (:code writer (:filename :start :next :no-more) (:request :error)
            #'arrowgrams/compiler/writer::react #'arrowgrams/compiler/writer::first-time)
           (:code converter (:string-fact :eof) (:done :converted :error)
            #'arrowgrams/compiler/convert-to-keywords::react #'arrowgrams/compiler/convert-to-keywords::first-time)
           (:code sequencer (:finished-reading :finished-pipeline :finished-writing) (:poke-fb :run-pipeline :write :error)
            #'arrowgrams/compiler/sequencer::react #'arrowgrams/compiler/sequencer::first-time)
           (:code bounding-boxes (:fb :go) (:add-fact :request-fb :done :error) #'arrowgrams/compiler/bounding-boxes::react #'arrowgrams/compiler/bounding-boxes::first-time)

           (:schem compiler (:prolog-factbase-filename :prolog-output-filename) (:error)
            ;; parts
            (reader fb writer converter sequencer bounding-boxes)
            ;; wiring
            ((((:self :prolog-factbase-filename)) ((reader :file-name)))
             (((:self :prolog-output-filename)) ((writer :filename)))

             (((reader :string-fact)) ((converter :string-fact)))
             (((reader :eof)) ((converter :eof)))

             (((converter :converted) (bounding-boxes :add-fact)) ((fb :lisp-fact)))
             (((converter :done)) ((sequencer :finished-reading)))

             (((sequencer :run-pipeline)) ((bounding-boxes :go)))
             (((sequencer :write))  ((fb :iterate) (writer :start)))

             (((fb :fb)) ((bounding-boxes :fb)))
             (((fb :next)) ((writer :next)))
             (((fb :no-more)) ((writer :no-more) (sequencer :finished-writing)))

             (((bounding-boxes :request-fb)) ((fb :fb-request)))
             (((bounding-boxes :done)) ((sequencer :finished-pipeline)))

             (((writer :request)) ((fb :get-next)))

             (((converter :error) (writer :error) (fb :error) (reader :error)
               (sequencer :error) (bounding-boxes :error))
              ((:self :error))))))))
    
    (e/dispatch::ensure-correct-number-of-parts (+ 1 6)) ;; not needed, except in early days of alpha debug, when everything is still in text form
    (e/util::enable-logging 1)
    (e/util::log-part (second (reverse (e/part::internal-parts compiler-net))))
    (setq arrowgrams/compiler::*top* compiler-net)
    (cl-event-passing-user::@with-dispatch
      (let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/js-compiler/temp5.pro")))
        (cl-event-passing-user::@inject compiler-net
                                        (e/part::get-input-pin compiler-net :prolog-factbase-filename)
                                        filename)))))
