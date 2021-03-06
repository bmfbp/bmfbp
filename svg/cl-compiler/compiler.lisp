(in-package :arrowgrams/compiler)

(defparameter *compiler-net* nil)

(defclass compiler (compiler-part) ())
(defmethod e/part:busy-p ((self compiler)) (call-next-method))
(defmethod e/part:clone ((self compiler)) (call-next-method))


#+lispworks
(defun main ()
  (let ((argv system:*line-arguments-list*))
    (format *standard-output* "~&lwargs = /~S/~%" argv)
    (if (>= (length argv) 2)
        (let ((filename (and (>= (length argv) 2) (second argv)))
              (map-filename (and (>= (length argv) 3) (third argv)))
              (output-filename (and (>= (length argv) 4) (fourth argv))))
          (format *standard-output* "~& using argv ~a ~a ~a~%" filename map-filename output-filename)
          (compiler-event-passing filename map-filename output-filename))
      (progn
        (format *standard-output* "~& using new builtin args~%")
        (new-main)))))

(defun kk-main ()
  (let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/kk5.pro")))
    (let ((map-filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/kk-temp-string-map.lisp")))
      (let ((output-filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/output.prolog")))
	(compiler-event-passing filename map-filename output-filename)))))

(defun old-main ()
  (let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/js-compiler/temp5.pro")))
    (let ((map-filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/js-compiler/temp-string-map.lisp")))
      (let ((output-filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/output.prolog")))
	(compiler-event-passing filename map-filename output-filename)))))

(defun new-main ()
  ;(let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "build_process/kk/build_process.svg")))
  (let ((filename (asdf:system-relative-pathname :arrowgrams/compiler "build_process/kk/ide.svg")))
    (let ((map-filename nil))
      (let ((output-filename (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/output.prolog")))
	(compiler-event-passing filename map-filename output-filename)))))

(defun get-compiler-net ()
  (let ((compiler-net (cl-event-passing-user::@defnetwork compiler

           (:code probe (:in) (:out))

                                                          
           (:code reader (:file-name :in-stream) (:string-fact :eof :error))
           (:code fb (:string-fact :lisp-fact :retract :fb-request :iterate :get-next :show :reset) (:fb :next :no-more :error))
           (:code writer (:filename :start :next :no-more) (:request :error))
           (:code convert-to-keywords (:string-fact :eof) (:done :converted :error))
           (:code sequencer (:finished-reading :finished-pipeline :finished-writing :prolog-output-filename) (:write-to-filename :poke-fb :run-pipeline :write :error :show))
           (:schem compiler-testbed (:prolog-factbase-string-stream :prolog-output-filename :request-fb :add-fact :retract-fact :done-step :finished-pipeline :reset) (:fb :step :error)
            ;; parts
            (reader fb writer convert-to-keywords sequencer)
            ;; wiring
"
self.reset -> fb.reset

self.prolog-factbase-string-stream -> reader.in-stream

self.prolog-output-filename -> sequencer.prolog-output-filename
self.finished-pipeline -> sequencer.finished-pipeline
self.request-fb -> fb.fb-request
self.retract-fact -> fb.retract

reader.string-fact -> convert-to-keywords.string-fact
reader.eof -> convert-to-keywords.eof

convert-to-keywords.converted, self.add-fact -> fb.lisp-fact

convert-to-keywords.done -> sequencer.finished-reading

sequencer.show -> fb.show
sequencer.run-pipeline, self.done-step -> self.step
sequencer.write -> fb.iterate, writer.start
sequencer.write-to-filename -> writer.filename

fb.fb -> self.fb
fb.next -> writer.next
fb.no-more -> writer.no-more, sequencer.finished-writing

writer.request -> fb.get-next

convert-to-keywords.error, writer.error, fb.error, reader.error, sequencer.error -> self.error
"
)        
           (:code ellipse-bounding-boxes (:fb :go) (:add-fact :request-fb :done :error))
           (:code rectangle-bounding-boxes (:fb :go) (:add-fact :request-fb :done :error))
           (:code text-bounding-boxes (:fb :go) (:add-fact :request-fb :done :error))
           (:code speechbubble-bounding-boxes (:fb :go) (:add-fact :request-fb :done :error))
           (:code assign-parents-to-ellipses (:fb :go) (:add-fact :done :request-fb :error))
	   (:code find-comments (:fb :go) (:add-fact :done :request-fb :error))
	   (:code find-metadata (:fb :go) (:add-fact :retract-fact :done :request-fb :error))
	   (:code add-kinds (:fb :go) (:add-fact :done :request-fb :error))
	   (:code add-self-ports (:fb :go) (:add-fact :done :request-fb :error))
	   (:code make-unknown-port-names (:fb :go) (:add-fact :done :request-fb :error))
	   (:code create-centers (:fb :go) (:add-fact :done :request-fb :error))
	   (:code calculate-distances (:fb :go) (:add-fact :done :request-fb :error))
	   (:code assign-portnames (:fb :go) (:add-fact :done :request-fb :error))
	   (:code mark-indexed-ports (:fb :go) (:add-fact :done :request-fb :error))
	   (:code coincident-ports (:fb :go) (:add-fact :done :request-fb :error))
	   (:code mark-directions (:fb :go) (:add-fact :done :request-fb :error))
	   (:code match-ports-to-components (:fb :go) (:add-fact :done :request-fb :error))
	   (:code mark-nc (:fb :go) (:add-fact :done :request-fb :error))
	   (:code pinless (:fb :go) (:add-fact :done :request-fb :error))
	   (:code sem-parts-have-some-ports (:fb :go) (:add-fact :done :request-fb :error))
	   (:code sem-ports-have-sink-or-source (:fb :go) (:add-fact :done :request-fb :error))
	   (:code sem-no-duplicate-kinds (:fb :go) (:add-fact :done :request-fb :error))
	   (:code sem-speech-vs-comments (:fb :go) (:add-fact :done :request-fb :error))
	   (:code assign-wire-numbers-to-edges (:fb :go) (:add-fact :done :request-fb :error))
	   (:code self-input-pins (:fb :go) (:add-fact :done :request-fb :error))
	   (:code self-output-pins (:fb :go) (:add-fact :done :request-fb :error))
	   (:code input-pins (:fb :go) (:add-fact :done :request-fb :error))
	   (:code output-pins (:fb :go) (:add-fact :done :request-fb :error))
	   (:code ir-emitter (:fb :go) (:ir :basename :done :request-fb :error))


           (:code demux (:go) (:o1 :o2 :o3 :o4 :o5 :o6 :o7 :o8 :o9 :o10 :o11 :o12 :o13 :o14 :o15 :o16 :o17 :o18 :o19 :o20 :o21 :o22 :o23 :o24 :o25 :o26 :o27 :o28 :o29 :finished-pipeline :error))

           (:schem passes (:fb :step) (:ir :basename :request-fb :add-fact :retract-fact :done-step :finished-pipeline :error)
            ;; parts
            (ellipse-bounding-boxes rectangle-bounding-boxes text-bounding-boxes speechbubble-bounding-boxes assign-parents-to-ellipses
                        find-comments find-metadata add-kinds add-self-ports
                        make-unknown-port-names create-centers calculate-distances assign-portnames mark-indexed-ports coincident-ports mark-directions mark-nc
                        match-ports-to-components pinless sem-parts-have-some-ports sem-ports-have-sink-or-source sem-no-duplicate-kinds
                        sem-speech-vs-comments assign-wire-numbers-to-edges self-input-pins self-output-pins input-pins output-pins
                        demux ir-emitter)

            ;; wiring
"
             ir-emitter.ir -> self.ir
             ir-emitter.basename -> self.basename

             self.step -> demux.go

             self.fb -> ellipse-bounding-boxes.fb,rectangle-bounding-boxes.fb,text-bounding-boxes.fb,speechbubble-bounding-boxes.fb,assign-parents-to-ellipses.fb,find-comments.fb,find-metadata.fb,add-kinds.fb,add-self-ports.fb,make-unknown-port-names.fb,create-centers.fb,calculate-distances.fb,assign-portnames.fb,mark-indexed-ports.fb,coincident-ports.fb,mark-directions.fb,mark-nc.fb,match-ports-to-components.fb,pinless.fb,sem-parts-have-some-ports.fb,sem-ports-have-sink-or-source.fb,sem-no-duplicate-kinds.fb,sem-speech-vs-comments.fb,assign-wire-numbers-to-edges.fb,self-input-pins.fb,self-output-pins.fb,input-pins.fb,output-pins.fb,ir-emitter.fb

             find-metadata.retract-fact -> self.retract-fact

             ellipse-bounding-boxes.request-fb,rectangle-bounding-boxes.request-fb,text-bounding-boxes.request-fb,speechbubble-bounding-boxes.request-fb,assign-parents-to-ellipses.request-fb,find-comments.request-fb,find-metadata.request-fb,add-kinds.request-fb,add-self-ports.request-fb,make-unknown-port-names.request-fb,create-centers.request-fb,calculate-distances.request-fb,assign-portnames.request-fb,mark-indexed-ports.request-fb,coincident-ports.request-fb,mark-directions.request-fb,mark-nc.request-fb,match-ports-to-components.request-fb,pinless.request-fb,sem-parts-have-some-ports.request-fb,sem-ports-have-sink-or-source.request-fb,sem-no-duplicate-kinds.request-fb,sem-speech-vs-comments.request-fb,assign-wire-numbers-to-edges.request-fb,self-input-pins.request-fb,self-output-pins.request-fb,input-pins.request-fb,output-pins.request-fb,ir-emitter.request-fb -> self.request-fb

             ellipse-bounding-boxes.add-fact,rectangle-bounding-boxes.add-fact,text-bounding-boxes.add-fact,speechbubble-bounding-boxes.add-fact,assign-parents-to-ellipses.add-fact,find-comments.add-fact,find-metadata.add-fact,add-kinds.add-fact,add-self-ports.add-fact,make-unknown-port-names.add-fact,create-centers.add-fact,calculate-distances.add-fact,assign-portnames.add-fact,mark-indexed-ports.add-fact,coincident-ports.add-fact,mark-directions.add-fact,mark-nc.add-fact,match-ports-to-components.add-fact,pinless.add-fact,sem-parts-have-some-ports.add-fact,sem-ports-have-sink-or-source.add-fact,sem-no-duplicate-kinds.add-fact,sem-speech-vs-comments.add-fact,assign-wire-numbers-to-edges.add-fact,self-input-pins.add-fact,self-output-pins.add-fact,input-pins.add-fact,output-pins.add-fact -> self.add-fact

ellipse-bounding-boxes.done,
               rectangle-bounding-boxes.done,
               text-bounding-boxes.done,
               speechbubble-bounding-boxes.done,
               assign-parents-to-ellipses.done,
               find-comments.done,
               find-metadata.done,
               add-kinds.done,
               add-self-ports.done,
               make-unknown-port-names.done,
               create-centers.done,
               calculate-distances.done,
               assign-portnames.done,
               mark-indexed-ports.done,
               coincident-ports.done,
               mark-directions.done,
               match-ports-to-components.done,
               mark-nc.done,
               pinless.done,
               sem-parts-have-some-ports.done,
               sem-ports-have-sink-or-source.done,
               sem-no-duplicate-kinds.done,
               sem-speech-vs-comments.done,
               assign-wire-numbers-to-edges.done,
               self-input-pins.done,
              self-output-pins.done,
              input-pins.done,output-pins.done,ir-emitter.done
 -> self.done-step


            demux.o1 -> ellipse-bounding-boxes.go
             demux.o2 -> rectangle-bounding-boxes.go
             demux.o3 -> text-bounding-boxes.go
             demux.o4 -> speechbubble-bounding-boxes.go
             demux.o5 -> assign-parents-to-ellipses.go
             demux.o6 -> find-comments.go
             demux.o7 -> find-metadata.go
             demux.o8 -> add-kinds.go
             demux.o9 -> add-self-ports.go
             demux.o10 -> make-unknown-port-names.go
             demux.o11 -> create-centers.go
             demux.o12 -> calculate-distances.go
             demux.o13 -> assign-portnames.go
             demux.o14 -> mark-indexed-ports.go
             demux.o15 -> coincident-ports.go
             demux.o16 -> mark-directions.go
             demux.o17 -> match-ports-to-components.go
             demux.o18 -> mark-nc.go
             demux.o19 -> pinless.go
             demux.o20 -> sem-parts-have-some-ports.go
             demux.o21 -> sem-ports-have-sink-or-source.go
             demux.o22 -> sem-no-duplicate-kinds.go
             demux.o23 -> sem-speech-vs-comments.go
             demux.o24 -> assign-wire-numbers-to-edges.go
             demux.o25 -> self-input-pins.go
             demux.o26 -> self-output-pins.go
             demux.o27 -> input-pins.go
             demux.o28 -> output-pins.go
             demux.o29 -> ir-emitter.go

             demux.finished-pipeline -> self.finished-pipeline

             ellipse-bounding-boxes.error,rectangle-bounding-boxes.error,text-bounding-boxes.error,speechbubble-bounding-boxes.error,assign-parents-to-ellipses.error,find-comments.error,find-metadata.error,add-kinds.error,add-self-ports.error,make-unknown-port-names.error,create-centers.error,calculate-distances.error,assign-portnames.error,mark-indexed-ports.error,coincident-ports.error,mark-directions.error,match-ports-to-components.error,pinless.error,sem-parts-have-some-ports.error,sem-ports-have-sink-or-source.error,sem-no-duplicate-kinds.error,sem-speech-vs-comments.error,assign-wire-numbers-to-edges.error,self-input-pins.error,self-output-pins.error,input-pins.error,output-pins.error,ir-emitter.error,demux.error
   -> self.error
"
            )
           

;;;; back end

            (:code tokenize (:start :ir :pull) (:out :error))
            (:code parens (:token) (:out :error))
            (:code spaces (:token) (:request :out :error))
            (:code strings (:token) (:request :out :error))
            (:code symbols (:token) (:request :out :error))
            (:code integers (:token) (:request :out :error))

            (:schem scanner (:start :ir :request) (:out :error)
             (tokenize parens strings symbols spaces integers) ;; parts
             "
              self.ir -> tokenize.ir
              self.start -> tokenize.start
              self.request,spaces.request,strings.request,symbols.request,integers.request -> tokenize.pull
              tokenize.out -> strings.token
              strings.out -> parens.token
              parens.out -> spaces.token
              spaces.out -> symbols.token
              symbols.out -> integers.token
              integers.out -> self.out

              tokenize.error,parens.error,strings.error,symbols.error,spaces.error,integers.error -> self.error
             "
             )
            (:code preparse (:start :token) (:out :request :error))
            (:code generic-emitter (:parse) (:out :error))
            (:code lisp-emitter (:parse) (:out :error))
            (:code json1-emitter (:parse) (:out :error))
            (:code collector (:parse) (:out :metadata :error))
            (:code emitter-pass2-generic (:in) (:out :error))
            (:code json-emitter (:in) (:out :error))

            (:code generic-file-writer (:filename :write) (:error))
            (:code json-file-writer (:filename :write) (:error))
            (:code lisp-file-writer (:filename :write) (:error))


            (:schem back-end-parser (:start :ir :generic-filename :json-filename :lisp-filename) (:json-out :lisp-out :metadata :error)
              (scanner preparse generic-emitter collector json1-emitter json-emitter lisp-emitter emitter-pass2-generic
                       generic-file-writer json-file-writer lisp-file-writer probe)
              "
               self.start -> scanner.start,preparse.start
               self.ir -> scanner.ir,preparse.start

               scanner.out -> preparse.token
               preparse.request -> scanner.request

               preparse.out -> generic-emitter.parse,collector.parse,lisp-emitter.parse,json1-emitter.parse

               self.generic-filename -> generic-file-writer.filename
               self.json-filename -> json-file-writer.filename
               self.lisp-filename -> lisp-file-writer.filename

               emitter-pass2-generic.out -> generic-file-writer.write

               collector.out -> json-emitter.in,emitter-pass2-generic.in
               collector.metadata -> self.metadata

               lisp-emitter.out -> lisp-file-writer.write,self.lisp-out

               json1-emitter.out -> self.json-out,json-file-writer.write

               scanner.error,generic-emitter.error,json-emitter.error,preparse.error,collector.error,lisp-emitter.error,
                  generic-file-writer.error,
                  json-file-writer.error,
                  lisp-file-writer.error
               -> self.error

              ")

            (:code synchronizer (:ir :json-filename :generic-filename :lisp-filename) (:ir :json-filename :generic-filename :lisp-filename :error))

            ;; see back-end.drawio / back end
            (:schem back-end (:ir :json-filename :generic-filename :lisp-filename) (:json :lisp :metadata :error)
             (synchronizer back-end-parser probe)
             "
self.ir -> synchronizer.ir
self.json-filename -> synchronizer.json-filename
self.generic-filename -> synchronizer.generic-filename
self.lisp-filename -> synchronizer.lisp-filename

synchronizer.ir -> back-end-parser.ir
synchronizer.json-filename -> back-end-parser.json-filename
synchronizer.generic-filename -> back-end-parser.generic-filename
synchronizer.lisp-filename -> back-end-parser.lisp-filename

back-end-parser.json-out -> self.json
back-end-parser.lisp-out -> self.lisp
back-end-parser.metadata -> self.metadata
back-end-parser.error -> self.error
")

;;;;;

            (:code file-namer (:basename) (:basename :json-filename :generic-filename :lisp-filename :error))


            ;; front-end is a kludgy Part that takes an SVG filename (exported from Drawio), run HS on it, then
            ;; runs a bunch of Lisp (see ../front-end/drawio.lisp) to massage the factbase into something that can be 
            ;; used by the compiler-testbed->passes-back-end ; it replaces the manual method(s) of using a shell script
            ;; to massage the code and to supply a filename to the testbed
            (:code front-end (:svg-filename) (:output-string-stream :error))
           
           (:schem compiler (:svg-filename :prolog-output-filename) (:metadata :json :lisp :error)
            ;; parts
            (front-end compiler-testbed passes back-end file-namer probe)
            ;; wiring
            
"
passes.finished-pipeline -> compiler-testbed.finished-pipeline,compiler-testbed.reset

self.svg-filename -> front-end.svg-filename
front-end.output-string-stream -> compiler-testbed.prolog-factbase-string-stream

passes.basename -> file-namer.basename
passes.ir -> back-end.ir
file-namer.json-filename -> back-end.json-filename
file-namer.generic-filename -> back-end.generic-filename
file-namer.lisp-filename -> back-end.lisp-filename

back-end.metadata -> self.metadata
back-end.json -> self.json
back-end.lisp -> self.lisp

self.prolog-output-filename -> compiler-testbed.prolog-output-filename

compiler-testbed.step -> passes.step
compiler-testbed.fb -> passes.fb

passes.request-fb -> compiler-testbed.request-fb
passes.add-fact -> compiler-testbed.add-fact
passes.retract-fact -> compiler-testbed.retract-fact
passes.done-step -> compiler-testbed.done-step

compiler-testbed.error, passes.error, back-end.error -> self.error
"

            ))))
    compiler-net))
    

(defun compiler-event-passing (filename map-filename output-filename)
  (let ((compiler-net (get-compiler-net)))
    (e/util::enable-logging 1)
    (setq arrowgrams/compiler::*top* compiler-net) ;; for early debug
    (assert (null map-filename)) ;; new version does not use string mapping
    (@with-dispatch
      (@enable-logging)
      (@inject compiler-net
               (e/part::get-input-pin compiler-net :prolog-output-filename)
               output-filename)
      (@inject compiler-net
               (e/part::get-input-pin compiler-net :svg-filename)
               filename)
      #+nil(@inject compiler-net
                    (e/part::get-input-pin compiler-net :finished-pipeline)
                    T))))

(defun ctest ()
  #+nil#(system:run-shell-command "rm -rf ~/.cache/common-lisp")
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (load "~/quicklisp/local-projects/bmfbp/svg/cl-compiler/package.lisp")
  (ql:quickload :arrowgrams/parser)
  (ql:quickload :arrowgrams/compiler)
  #+lispworks(hcl:change-directory "~/quicklisp/local-projects/bmfbp/svg/cl-compiler/")
  (arrowgrams/compiler::main))
(defun cl-user::ctest () (arrowgrams/compiler::ctest))


(defun cl-user::cc ()
  (compile-file "~/quicklisp/local-projects/bmfbp/svg/back-end/json1-sl.lisp")
  (load "~/quicklisp/local-projects/bmfbp/svg/back-end/json1-sl")
  (arrowgrams/compiler::main))
