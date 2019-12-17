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

           (:code rectangle-bb (:fb :go) (:add-fact :request-fb :done :error) #'arrowgrams/compiler/rectangle-bounding-boxes::react #'arrowgrams/compiler/rectangle-bounding-boxes::first-time)
           (:code text-bb (:fb :go) (:add-fact :request-fb :done :error) #'arrowgrams/compiler/text-bounding-boxes::react #'arrowgrams/compiler/text-bounding-boxes::first-time)
           (:code speechbubble-bb (:fb :go) (:add-fact :request-fb :done :error) #'arrowgrams/compiler/speechbubble-bounding-boxes::react #'arrowgrams/compiler/speechbubble-bounding-boxes::first-time)

           (:code assign-parents-to-ellipses (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/assign-parents-to-ellipses::react #'arrowgrams/compiler/assign-parents-to-ellipses::first-time)

 (:CODE
  FIND-COMMENTS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/FIND-COMMENTS::REACT
  #'ARROWGRAMS/COMPILER/FIND-COMMENTS::FIRST-TIME)
 (:CODE
  FIND-METADATA
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/FIND-METADATA::REACT
  #'ARROWGRAMS/COMPILER/FIND-METADATA::FIRST-TIME)
 (:CODE
  ADD-KINDS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/ADD-KINDS::REACT
  #'ARROWGRAMS/COMPILER/ADD-KINDS::FIRST-TIME)
 (:CODE
  ADD-SELF-PORTS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/ADD-SELF-PORTS::REACT
  #'ARROWGRAMS/COMPILER/ADD-SELF-PORTS::FIRST-TIME)
 (:CODE
  MAKE-UNKNOWN-PORT-NAMES
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/MAKE-UNKNOWN-PORT-NAMES::REACT
  #'ARROWGRAMS/COMPILER/MAKE-UNKNOWN-PORT-NAMES::FIRST-TIME)
 (:CODE
  CREATE-CENTERS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/CREATE-CENTERS::REACT
  #'ARROWGRAMS/COMPILER/CREATE-CENTERS::FIRST-TIME)
 (:CODE
  CALCULATE-DISTANCES
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/CALCULATE-DISTANCES::REACT
  #'ARROWGRAMS/COMPILER/CALCULATE-DISTANCES::FIRST-TIME)
 (:CODE
  ASSIGN-PORTNAMES
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/ASSIGN-PORTNAMES::REACT
  #'ARROWGRAMS/COMPILER/ASSIGN-PORTNAMES::FIRST-TIME)
 (:CODE
  MARK-INDEXED-PORTS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/MARK-INDEXED-PORTS::REACT
  #'ARROWGRAMS/COMPILER/MARK-INDEXED-PORTS::FIRST-TIME)
 (:CODE
  CONCIDENT-PORTS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/CONCIDENT-PORTS::REACT
  #'ARROWGRAMS/COMPILER/CONCIDENT-PORTS::FIRST-TIME)
 (:CODE
  MARK-DIRECTIONS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/MARK-DIRECTIONS::REACT
  #'ARROWGRAMS/COMPILER/MARK-DIRECTIONS::FIRST-TIME)
 (:CODE
  MATCH-PORTS-TO-COMPONENTS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/MATCH-PORTS-TO-COMPONENTS::REACT
  #'ARROWGRAMS/COMPILER/MATCH-PORTS-TO-COMPONENTS::FIRST-TIME)
 (:CODE PINLESS (:FB :GO) (:ADD-FACT :DONE :REQUEST-FB :ERROR) #'ARROWGRAMS/COMPILER/PINLESS::REACT #'ARROWGRAMS/COMPILER/PINLESS::FIRST-TIME)
 (:CODE
  SEM-PARTS-HAVE-SOME-PORTS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/SEM-PARTS-HAVE-SOME-PORTS::REACT
  #'ARROWGRAMS/COMPILER/SEM-PARTS-HAVE-SOME-PORTS::FIRST-TIME)
 (:CODE
  SEM-PORTS-HAVE-SINK-OR-SOURCE
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/SEM-PORTS-HAVE-SINK-OR-SOURCE::REACT
  #'ARROWGRAMS/COMPILER/SEM-PORTS-HAVE-SINK-OR-SOURCE::FIRST-TIME)
 (:CODE
  SEM-NO-DUPLICATE-KINDS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/SEM-NO-DUPLICATE-KINDS::REACT
  #'ARROWGRAMS/COMPILER/SEM-NO-DUPLICATE-KINDS::FIRST-TIME)
 (:CODE
  SEM-SPEECH-VS-COMMENTS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/SEM-SPEECH-VS-COMMENTS::REACT
  #'ARROWGRAMS/COMPILER/SEM-SPEECH-VS-COMMENTS::FIRST-TIME)
 (:CODE
  ASSIGN-WIRE-NUMBERS-TO-EDGES
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/ASSIGN-WIRE-NUMBERS-TO-EDGES::REACT
  #'ARROWGRAMS/COMPILER/ASSIGN-WIRE-NUMBERS-TO-EDGES::FIRST-TIME)
 (:CODE
  SELF-INPUT-PINS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/SELF-INPUT-PINS::REACT
  #'ARROWGRAMS/COMPILER/SELF-INPUT-PINS::FIRST-TIME)
 (:CODE
  SELF-OUTPUT-PINS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/SELF-OUTPUT-PINS::REACT
  #'ARROWGRAMS/COMPILER/SELF-OUTPUT-PINS::FIRST-TIME)
 (:CODE
  INPUT-PINS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/INPUT-PINS::REACT
  #'ARROWGRAMS/COMPILER/INPUT-PINS::FIRST-TIME)
 (:CODE
  OUTPUT-PINS
  (:FB :GO)
  (:ADD-FACT :DONE :REQUEST-FB :ERROR)
  #'ARROWGRAMS/COMPILER/OUTPUT-PINS::REACT
  #'ARROWGRAMS/COMPILER/OUTPUT-PINS::FIRST-TIME)


           (:schem passes (:fb :go) (:request-fb :add-fact :done :error)
            ;; parts
            (ellipse-bb rectangle-bb text-bb speechbubble-bb assign-parents-to-ellipses
assign-parents-to-ellipses find-comments find-metadata add-kinds add-self-ports
make-unknown-port-names create-centers calculate-distances assign-portnames mark-indexed-ports concident-ports mark-directions
match-ports-to-components pinless sem-parts-have-some-ports sem-ports-have-sink-or-source sem-no-duplicate-kinds
sem-speech-vs-comments assign-wire-numbers-to-edges self-input-pins self-output-pins input-pins output-pins)

            ;; wiring
            (

             (((:self :fb)) ((ellipse-bb :fb) (rectangle-bb :fb) (text-bb :fb) (speechbubble-bb :fb) (assign-parents-to-ellipses :fb) (find-comments :fb) (find-metadata :fb) (add-kinds :fb) (add-self-ports :fb) (make-unknown-port-names :fb) (create-centers :fb) (calculate-distances :fb) (assign-portnames :fb) (mark-indexed-ports :fb) (concident-ports :fb) (mark-directions :fb) (match-ports-to-components :fb) (pinless :fb) (sem-parts-have-some-ports :fb) (sem-ports-have-sink-or-source :fb) (sem-no-duplicate-kinds :fb) (sem-speech-vs-comments :fb) (assign-wire-numbers-to-edges :fb) (self-input-pins :fb) (self-output-pins :fb) (input-pins :fb) (output-pins :fb)))

             (((ellipse-bb :request-fb) (rectangle-bb :request-fb) (text-bb :request-fb) (speechbubble-bb :request-fb) (assign-parents-to-ellipses :request-fb) (find-comments :request-fb) (find-metadata :request-fb) (add-kinds :request-fb) (add-self-ports :request-fb) (make-unknown-port-names :request-fb) (create-centers :request-fb) (calculate-distances :request-fb) (assign-portnames :request-fb) (mark-indexed-ports :request-fb) (concident-ports :request-fb) (mark-directions :request-fb) (match-ports-to-components :request-fb) (pinless :request-fb) (sem-parts-have-some-ports :request-fb) (sem-ports-have-sink-or-source :request-fb) (sem-no-duplicate-kinds :request-fb) (sem-speech-vs-comments :request-fb) (assign-wire-numbers-to-edges :request-fb) (self-input-pins :request-fb) (self-output-pins :request-fb) (input-pins :request-fb) (output-pins :request-fb)) ((:self :request-fb)))

             (((ellipse-bb :add-fact) (rectangle-bb :add-fact) (text-bb :add-fact) (speechbubble-bb :add-fact) (assign-parents-to-ellipses :add-fact) (find-comments :add-fact) (find-metadata :add-fact) (add-kinds :add-fact) (add-self-ports :add-fact) (make-unknown-port-names :add-fact) (create-centers :add-fact) (calculate-distances :add-fact) (assign-portnames :add-fact) (mark-indexed-ports :add-fact) (concident-ports :add-fact) (mark-directions :add-fact) (match-ports-to-components :add-fact) (pinless :add-fact) (sem-parts-have-some-ports :add-fact) (sem-ports-have-sink-or-source :add-fact) (sem-no-duplicate-kinds :add-fact) (sem-speech-vs-comments :add-fact) (assign-wire-numbers-to-edges :add-fact) (self-input-pins :add-fact) (self-output-pins :add-fact) (input-pins :add-fact) (output-pins :add-fact)) ((:self :add-fact)))

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
             (((mark-indexed-ports :done)) ((concident-ports :go)))
             (((concident-ports :done)) ((mark-directions :go)))
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


             (((ellipse-bb :error) (rectangle-bb :error) (text-bb :error) (speechbubble-bb :error) (assign-parents-to-ellipses :error) (find-comments :error) (find-metadata :error) (add-kinds :error) (add-self-ports :error) (make-unknown-port-names :error) (create-centers :error) (calculate-distances :error) (assign-portnames :error) (mark-indexed-ports :error) (concident-ports :error) (mark-directions :error) (match-ports-to-components :error) (pinless :error) (sem-parts-have-some-ports :error) (sem-ports-have-sink-or-source :error) (sem-no-duplicate-kinds :error) (sem-speech-vs-comments :error) (assign-wire-numbers-to-edges :error) (self-input-pins :error) (self-output-pins :error) (input-pins :error) (output-pins :error)) ((:self :error)))

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
             (((passes :done)) ((compiler-testbed :done)))
             
             (((compiler-testbed :error) (passes :error)) ((:self :error)))
             )))))
    
    #+nil(e/util::enable-logging 1)
    #+nil(e/util::log-part (second (reverse (e/part::internal-parts compiler-net))))
    (setq arrowgrams/compiler::*top* compiler-net) ;; for early debug
    (cl-event-passing-user::@with-dispatch
      (let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/js-compiler/temp5.pro")))
        (cl-event-passing-user::@inject compiler-net
                                        (e/part::get-input-pin compiler-net :prolog-factbase-filename)
                                        filename)))))
