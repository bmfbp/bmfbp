(in-package :arrowgrams/compiler)

(defun compiler ()
  (let ((compiler-net (cl-event-passing-user::@defnetwork compiler

           (:code reader (:file-name) (:string-fact :eof :error)
            #'arrowgrams/compiler/reader::react #'arrowgrams/compiler/reader::first-time)
           (:code fb (:string-fact :lisp-fact :retract :go :fb-request :iterate :get-next) (:fb :next :no-more :error)
            #'arrowgrams/compiler/fb::react #'arrowgrams/compiler/fb::first-time)
           (:code writer (:filename :start :next :no-more) (:request :error)
            #'arrowgrams/compiler/writer::react #'arrowgrams/compiler/writer::first-time)
           (:code converter (:string-fact :eof) (:done :converted :error)
            #'arrowgrams/compiler/convert-to-keywords::react #'arrowgrams/compiler/convert-to-keywords::first-time)
           (:code sequencer (:finished-reading :finished-pipeline :finished-writing) (:poke-fb :run-pipeline :write :error)
            #'arrowgrams/compiler/sequencer::react #'arrowgrams/compiler/sequencer::first-time)

           (:schem compiler-testbed (:prolog-factbase-filename :prolog-output-filename :request-fb :add-fact :retract-fact :done) (:fb :go :error)
            ;; parts
            (reader fb writer converter sequencer)
            ;; wiring
            ((((:self :prolog-factbase-filename)) ((reader :file-name)))
             (((:self :prolog-output-filename)) ((writer :filename)))
             (((:self :done)) ((sequencer :finished-pipeline)))
             (((:self :request-fb)) ((fb :fb-request)))
             (((:self :retract-fact)) ((fb :retract)))

             (((reader :string-fact)) ((converter :string-fact)))
             (((reader :eof)) ((converter :eof)))

             (((converter :converted) (:self :add-fact)) ((fb :lisp-fact)))
             (((converter :done)) ((sequencer :finished-reading)))

             (((sequencer :run-pipeline)) ((:self :go)))
             ;(((sequencer :write))  ((fb :iterate) (writer :start)))

             (((fb :fb)) ((:self :fb)))
             (((fb :next)) ((writer :next)))
             (((fb :no-more)) ((writer :no-more) (sequencer :finished-writing)))


             (((writer :request)) ((fb :get-next)))

             (((converter :error) (writer :error) (fb :error) (reader :error) (sequencer :error) )
              ((:self :error)))))
        
           (:code ellipse-bb (:fb :go) (:add-fact :request-fb :done :error)
		  #'arrowgrams/compiler/ellipse-bounding-boxes::react #'arrowgrams/compiler/ellipse-bounding-boxes::first-time)

           (:code rectangle-bb (:fb :go) (:add-fact :request-fb :done :error)
		  #'arrowgrams/compiler/rectangle-bounding-boxes::react #'arrowgrams/compiler/rectangle-bounding-boxes::first-time)
           (:code text-bb (:fb :go) (:add-fact :request-fb :done :error)
		  #'arrowgrams/compiler/text-bounding-boxes::react #'arrowgrams/compiler/text-bounding-boxes::first-time)
           (:code speechbubble-bb (:fb :go) (:add-fact :request-fb :done :error)
		  #'arrowgrams/compiler/speechbubble-bounding-boxes::react #'arrowgrams/compiler/speechbubble-bounding-boxes::first-time)

           (:code assign-parents-to-ellipses (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/assign-parents-to-ellipses::react #'arrowgrams/compiler/assign-parents-to-ellipses::first-time)

	   (:code find-comments (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/find-comments::react #'arrowgrams/compiler/find-comments::first-time)
	   (:code find-metadata (:fb :go) (:add-fact :retract-fact :done :request-fb :error)
		  #'arrowgrams/compiler/find-metadata::react #'arrowgrams/compiler/find-metadata::first-time)
	   (:code add-kinds (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/add-kinds::react #'arrowgrams/compiler/add-kinds::first-time)
	   (:code add-self-ports (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/add-self-ports::react #'arrowgrams/compiler/add-self-ports::first-time)
	   (:code make-unknown-port-names (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/make-unknown-port-names::react #'arrowgrams/compiler/make-unknown-port-names::first-time)
	   (:code create-centers (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/create-centers::react #'arrowgrams/compiler/create-centers::first-time)
	   (:code calculate-distances (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/calculate-distances::react #'arrowgrams/compiler/calculate-distances::first-time)
	   (:code assign-portnames (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/assign-portnames::react #'arrowgrams/compiler/assign-portnames::first-time)
	   (:code mark-indexed-ports (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/mark-indexed-ports::react #'arrowgrams/compiler/mark-indexed-ports::first-time)
	   (:code coincident-ports (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/coincident-ports::react #'arrowgrams/compiler/coincident-ports::first-time)
	   (:code mark-directions (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/mark-directions::react #'arrowgrams/compiler/mark-directions::first-time)
	   (:code match-ports-to-components (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/match-ports-to-components::react #'arrowgrams/compiler/match-ports-to-components::first-time)
	   (:code pinless (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/pinless::react #'arrowgrams/compiler/pinless::first-time)
	   (:code sem-parts-have-some-ports (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/sem-parts-have-some-ports::react #'arrowgrams/compiler/sem-parts-have-some-ports::first-time)
	   (:code sem-ports-have-sink-or-source (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/sem-ports-have-sink-or-source::react #'arrowgrams/compiler/sem-ports-have-sink-or-source::first-time)
	   (:code sem-no-duplicate-kinds (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/sem-no-duplicate-kinds::react #'arrowgrams/compiler/sem-no-duplicate-kinds::first-time)
	   (:code sem-speech-vs-comments (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/sem-speech-vs-comments::react #'arrowgrams/compiler/sem-speech-vs-comments::first-time)
	   (:code assign-wire-numbers-to-edges (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/assign-wire-numbers-to-edges::react #'arrowgrams/compiler/assign-wire-numbers-to-edges::first-time)
	   (:code self-input-pins (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/self-input-pins::react #'arrowgrams/compiler/self-input-pins::first-time)
	   (:code self-output-pins (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/self-output-pins::react #'arrowgrams/compiler/self-output-pins::first-time)
	   (:code input-pins (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/input-pins::react #'arrowgrams/compiler/input-pins::first-time)
	   (:code output-pins (:fb :go) (:add-fact :done :request-fb :error)
		  #'arrowgrams/compiler/output-pins::react #'arrowgrams/compiler/output-pins::first-time)


           (:schem passes (:fb :go) (:request-fb :add-fact :retract-fact :done :error)
            ;; parts
            (ellipse-bb rectangle-bb text-bb speechbubble-bb assign-parents-to-ellipses
find-comments find-metadata add-kinds add-self-ports
make-unknown-port-names create-centers calculate-distances assign-portnames mark-indexed-ports coincident-ports mark-directions
match-ports-to-components pinless sem-parts-have-some-ports sem-ports-have-sink-or-source sem-no-duplicate-kinds
sem-speech-vs-comments assign-wire-numbers-to-edges self-input-pins self-output-pins input-pins output-pins)

            ;; wiring
            (

             (((:self :go)) ((ellipse-bb :go)))

             (((:self :fb)) ((ellipse-bb :fb) (rectangle-bb :fb) (text-bb :fb) (speechbubble-bb :fb) (assign-parents-to-ellipses :fb) (find-comments :fb) (find-metadata :fb) (add-kinds :fb) (add-self-ports :fb) (make-unknown-port-names :fb) (create-centers :fb) (calculate-distances :fb) (assign-portnames :fb) (mark-indexed-ports :fb) (coincident-ports :fb) (mark-directions :fb) (match-ports-to-components :fb) (pinless :fb) (sem-parts-have-some-ports :fb) (sem-ports-have-sink-or-source :fb) (sem-no-duplicate-kinds :fb) (sem-speech-vs-comments :fb) (assign-wire-numbers-to-edges :fb) (self-input-pins :fb) (self-output-pins :fb) (input-pins :fb) (output-pins :fb)))

             (((find-metadata :retract-fact)) ((:self :retract-fact)))

             (((ellipse-bb :request-fb) (rectangle-bb :request-fb) (text-bb :request-fb) (speechbubble-bb :request-fb) (assign-parents-to-ellipses :request-fb) (find-comments :request-fb) (find-metadata :request-fb) (add-kinds :request-fb) (add-self-ports :request-fb) (make-unknown-port-names :request-fb) (create-centers :request-fb) (calculate-distances :request-fb) (assign-portnames :request-fb) (mark-indexed-ports :request-fb) (coincident-ports :request-fb) (mark-directions :request-fb) (match-ports-to-components :request-fb) (pinless :request-fb) (sem-parts-have-some-ports :request-fb) (sem-ports-have-sink-or-source :request-fb) (sem-no-duplicate-kinds :request-fb) (sem-speech-vs-comments :request-fb) (assign-wire-numbers-to-edges :request-fb) (self-input-pins :request-fb) (self-output-pins :request-fb) (input-pins :request-fb) (output-pins :request-fb)) ((:self :request-fb)))

             (((ellipse-bb :add-fact) (rectangle-bb :add-fact) (text-bb :add-fact) (speechbubble-bb :add-fact) (assign-parents-to-ellipses :add-fact) (find-comments :add-fact) (find-metadata :add-fact) (add-kinds :add-fact) (add-self-ports :add-fact) (make-unknown-port-names :add-fact) (create-centers :add-fact) (calculate-distances :add-fact) (assign-portnames :add-fact) (mark-indexed-ports :add-fact) (coincident-ports :add-fact) (mark-directions :add-fact) (match-ports-to-components :add-fact) (pinless :add-fact) (sem-parts-have-some-ports :add-fact) (sem-ports-have-sink-or-source :add-fact) (sem-no-duplicate-kinds :add-fact) (sem-speech-vs-comments :add-fact) (assign-wire-numbers-to-edges :add-fact) (self-input-pins :add-fact) (self-output-pins :add-fact) (input-pins :add-fact) (output-pins :add-fact)) ((:self :add-fact)))

             (((ellipse-bb :done)) ((rectangle-bb :go)))
             (((rectangle-bb :done)) ((text-bb :go)))
             (((text-bb :done)) ((speechbubble-bb :go)))
             (((speechbubble-bb :done)) ((assign-parents-to-ellipses :go)))
             (((assign-parents-to-ellipses :done)) ((find-comments :go)))
             (((find-comments :done)) ((find-metadata :go)))
             (((find-metadata :done)) ((add-kinds :go)))
             (((add-kinds :done)) ((add-self-ports :go)))
             (((add-self-ports :done)) ((make-unknown-port-names :go)))
             (((make-unknown-port-names :done)) ((create-centers :go)))
             (((create-centers :done)) ((calculate-distances :go)))
             (((calculate-distances :done)) ((assign-portnames :go)))
             (((assign-portnames :done)) ((mark-indexed-ports :go)))
             (((mark-indexed-ports :done)) ((coincident-ports :go)))
             (((coincident-ports :done)) ((mark-directions :go)))
             (((mark-directions :done)) ((match-ports-to-components :go)))
             (((match-ports-to-components :done)) ((pinless :go)))
             (((pinless :done)) ((sem-parts-have-some-ports :go)))
             (((sem-parts-have-some-ports :done)) ((sem-ports-have-sink-or-source :go)))
             (((sem-ports-have-sink-or-source :done)) ((sem-no-duplicate-kinds :go)))
             (((sem-no-duplicate-kinds :done)) ((sem-speech-vs-comments :go)))
             (((sem-speech-vs-comments :done)) ((assign-wire-numbers-to-edges :go)))
             (((assign-wire-numbers-to-edges :done)) ((self-input-pins :go)))
             (((self-input-pins :done)) ((self-output-pins :go)))
             (((self-output-pins :done)) ((input-pins :go)))
             (((input-pins :done)) ((output-pins :go)))

             (((output-pins :done)) ((:self :done)))


             (((ellipse-bb :error) (rectangle-bb :error) (text-bb :error) (speechbubble-bb :error) (assign-parents-to-ellipses :error) (find-comments :error) (find-metadata :error) (add-kinds :error) (add-self-ports :error) (make-unknown-port-names :error) (create-centers :error) (calculate-distances :error) (assign-portnames :error) (mark-indexed-ports :error) (coincident-ports :error) (mark-directions :error) (match-ports-to-components :error) (pinless :error) (sem-parts-have-some-ports :error) (sem-ports-have-sink-or-source :error) (sem-no-duplicate-kinds :error) (sem-speech-vs-comments :error) (assign-wire-numbers-to-edges :error) (self-input-pins :error) (self-output-pins :error) (input-pins :error) (output-pins :error)) ((:self :error)))

             ))
           
           
           (:schem compiler (:prolog-factbase-filename :prolog-output-filename) (:error)
            ;; parts
            (compiler-testbed passes)
            ;; wiring
            
            (
             (((:self :prolog-factbase-filename)) ((compiler-testbed :prolog-factbase-filename)))
             (((:self :prolog-output-filename))   ((compiler-testbed :prolog-output-filename)))
             
             (((compiler-testbed :go)) ((passes :go)))
             (((compiler-testbed :fb)) ((passes :fb)))
             
             (((passes :request-fb)) ((compiler-testbed :request-fb)))
             (((passes :add-fact)) ((compiler-testbed :add-fact)))
             (((passes :retract-fact)) ((compiler-testbed :retract-fact)))
             (((passes :done)) ((compiler-testbed :done)))
             
             (((compiler-testbed :error) (passes :error)) ((:self :error)))
             )))))
    
    #+nil(e/util::enable-logging 1)
    #+nil(e/util::log-part (second (reverse (e/part::internal-parts compiler-net))))
    (setq arrowgrams/compiler::*top* compiler-net) ;; for early debug
    (cl-event-passing-user::@with-dispatch
      (let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/js-compiler/temp5.pro")))
      ;(let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/very-small.prolog")))
        (cl-event-passing-user::@inject compiler-net
                                        (e/part::get-input-pin compiler-net :prolog-factbase-filename)
                                        filename)))))
