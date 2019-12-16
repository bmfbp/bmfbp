(in-package :arrowgrams/compiler)

(defun compiler ()
  (let ((compiler-net (cl-event-passing-user::@defnetwork compiler

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

           (:schem compiler-testbed (:prolog-factbase-filename :prolog-output-filename :request-fb :add-fact :done) (:fb :go :error)
            ;; parts
            (reader fb writer converter sequencer)
            ;; wiring
            ((((:self :prolog-factbase-filename)) ((reader :file-name)))
             (((:self :prolog-output-filename)) ((writer :filename)))
             (((:self :done)) ((sequencer :finished-pipeline)))
             (((:self :request-fb)) ((fb :fb-request)))

             (((reader :string-fact)) ((converter :string-fact)))
             (((reader :eof)) ((converter :eof)))

             (((converter :converted) (:self :add-fact)) ((fb :lisp-fact)))
             (((converter :done)) ((sequencer :finished-reading)))

             (((sequencer :run-pipeline)) ((:self :go)))
             (((sequencer :write))  ((fb :iterate) (writer :start)))

             (((fb :fb)) ((:self :fb)))
             (((fb :next)) ((writer :next)))
             (((fb :no-more)) ((writer :no-more) (sequencer :finished-writing)))


             (((writer :request)) ((fb :get-next)))

             (((converter :error) (writer :error) (fb :error) (reader :error) (sequencer :error) )
              ((:self :error)))))
        
           (:code ellipse-bb (:fb :go) (:add-fact :request-fb :done :error) #'arrowgrams/compiler/ellipse-bounding-boxes::react #'arrowgrams/compiler/ellipse-bounding-boxes::first-time)

           (:schem passes (:fb :go) (:request-fb :add-fact :done :error)
            ;; parts
            (compiler-testbed ellipse-bb)
            ;; wiring
            ( (((:self :fb)) ((ellipse-bb :fb)))
              (((:self :go)) ((ellipse-bb :go)))

              (((ellipse-bb :request-fb)) ((:self :request-fb)))
              (((ellipse-bb :add-fact)) ((:self :add-fact)))
              (((ellipse-bb :error)) ((:self :error)))))

           (:schem compiler (:prolog-factbase-filename :prolog-output-filename) (:error)
            ;; parts
            (compiler-testbed passes)
            ;; wiring

            ((((:self :prolog-factbase-filename)) ((compiler-testbed :prolog-factbase-filename)))
             (((:self :prolog-output-filename))   ((compiler-testbed :prolog-output-filename)))

             (((compiler-testbed :go)) ((passes :go)))
             (((compiler-testbed :fb)) ((passes :fb)))

             (((passes :request-fb)) ((compiler-testbed :request-fb)))
             (((passes :add-fact)) ((compiler-testbed :add-fact)))
             (((passes :done)) ((compiler-testbed :done)))

             (((compiler-testbed :error) (passes :error)) ((:self :error))))))))
    
    #+nil(e/util::enable-logging 1)
    #+nil(e/util::log-part (second (reverse (e/part::internal-parts compiler-net))))
    (setq arrowgrams/compiler::*top* compiler-net) ;; for early debug
    (cl-event-passing-user::@with-dispatch
      (let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/js-compiler/temp5.pro")))
        (cl-event-passing-user::@inject compiler-net
                                        (e/part::get-input-pin compiler-net :prolog-factbase-filename)
                                        filename)))))
