(defsystem :arrowgrams
  :depends-on (:cl-event-passing :cl-peg :loops)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "source"
                        :pathname "./")))

(defsystem :arrowgrams/clparts
  :depends-on (:arrowgrams :alexandria)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "parts"
                        :pathname "./clparts"
                        :components ((:file "package")
                                     (:file "readfileintostring" :depends-on ("package"))
                                     (:file "pegtolisp" :depends-on ("package"))
                                     (:file "stripquotes" :depends-on ("package"))
                                     (:file "parser-builder" :depends-on ("package" "readfileintostring" "pegtolisp" "stripquotes"))))))

(defsystem :arrowgrams/test
  :depends-on (:arrowgrams/clparts)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "tester"
                        :pathname "./clparts"
                        :components ((:file "test")))))



(defsystem :arrowgrams/compiler/test
  :depends-on (:arrowgrams :arrowgrams/clparts :cl-holm-prolog :cl-ppcre)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "cl-compiler-rule-tests"
                        :pathname "./svg/cl-compiler/"
                        :components ((:file "package")
                                     (:file "rules.lisp" :depends-on ("package"))
                                     (:file "test.lisp" :depends-on ("rules.lisp"))))))

(defsystem arrowgrams/parser
  :depends-on (:arrowgrams :esrap :cl-event-passing :loops)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./svg/prolog2lisp3"
			:components ((:file "package")
                                     (:file "../cl-compiler/package")
                                     (:file "low-level" :depends-on ("package"))
                                     (:file "mid-level" :depends-on ("package" "low-level"))
                                     (:file "ignore" :depends-on ("package"))
                                     (:file "prolog-rules" :depends-on ("package" "../cl-compiler/package"))
                                     (:file "test-rule1" :depends-on ("package" "../cl-compiler/package"))
                                     (:file "prolog-peg" :depends-on ("mid-level" "low-level" "ignore" "prolog-rules" "test-rule1"))
                                     (:file "facts" :depends-on ("package"))
                                     (:file "gprolog-to-hprolog" :depends-on ("prolog-peg" "facts"))
                                     (:file "test" :depends-on ("gprolog-to-hprolog" "prolog-peg" "facts"))))))

(defsystem arrowgrams/compiler/xform
  :depends-on (:arrowgrams :esrap :cl-event-passing :loops :cl-peg)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./svg/xform"
			:components ((:file "package")
				     (:file "ir-grammar")
				     (:file "ir-to-lisp" :depends-on ("ir-grammar"))
                                     (:file "xform" :depends-on ("package" "ir-grammar" "ir-to-lisp"))))))

(defsystem arrowgrams/compiler/back-end
  :depends-on (:arrowgrams :cl-event-passing :sl :loops :cl-holm-prolog)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./svg/back-end"
			:components ((:file "../cl-compiler/package")
				     (:file "token" :depends-on ("../cl-compiler/package"))
				     (:file "synchronizer" :depends-on ("token"))
				     (:file "tokenize" :depends-on ("token"))
				     (:file "parens" :depends-on ("token"))
				     (:file "ws" :depends-on ("token"))
				     (:file "spaces" :depends-on ("token"))
				     (:file "strings" :depends-on ("token"))
				     (:file "symbols" :depends-on ("token"))
				     (:file "integers" :depends-on ("token"))
				     (:file "dumper" :depends-on ("token"))
				     (:file "parse-util" :depends-on ("token"))
				     (:file "preparse" :depends-on ("token"))
				     (:file "file-writer" :depends-on ("token"))
                                     (:file "schem-unparse" :depends-on ("token" "parse-util"))
                                     (:file "collector-sl" :depends-on ("token" "parse-util"))
                                     (:file "file-namer" :depends-on ("../cl-compiler/package"))
                                     (:file "collector" :depends-on ("token" "parse-util" "collector-sl" "schem-unparse"))
                                     (:file "emitter-pass2-generic-sl" :depends-on ("token" "parse-util"))
                                     (:file "emitter-pass2-generic" :depends-on ("token" "parse-util" "emitter-pass2-generic-sl"))
                                     (:file "json-emitter-sl" :depends-on ("token" "parse-util"))
                                     (:file "json-emitter" :depends-on ("token" "parse-util" "json-emitter-sl"))
                                     (:file "generic-sl" :depends-on ("token"))
				     (:file "generic-emitter" :depends-on ("token" "parse-util" "generic-sl"))
                                     (:file "lisp-sl" :depends-on ("token"))
				     (:file "lisp-emitter" :depends-on ("token" "parse-util" "lisp-sl"))
				     (:file "parser" :depends-on ("../cl-compiler/package" "token" "tokenize" "strings" "ws"
                                                                  "symbols" "integers" "spaces" "preparse" "file-writer"
                                                                  "generic-emitter" "collector" "lisp-emitter"
                                                                  "emitter-pass2-generic" "json-emitter" "file-namer" "synchronizer"))

				     (:file "wiring" :depends-on ("../cl-compiler/package"))))))


;;;; 
;;;; compiler rev 2, in CL, using Holm prolog
;;;;

(defsystem :arrowgrams/compiler
  :depends-on (:arrowgrams :cl-holm-prolog :cl-ppcre :cl-json :arrowgrams/compiler/back-end)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "cl-compiler"
                        :pathname "./svg/cl-compiler/"
                        :components ((:file "package")
                                     (:file "classes" :depends-on ("package"))
                                     (:file "fb" :depends-on ("package" "util"))
                                     (:file "sequencer" :depends-on ("package"))
                                     (:file "unmapper" :depends-on ("package"))
                                     (:file "reader" :depends-on ("package"))
                                     (:file "writer" :depends-on ("package"))
                                     (:file "convert-to-keywords" :depends-on ("package"))
                                     (:file "ellipse-bounding-boxes" :depends-on ("package"))
                                     (:file "rectangle-bounding-boxes" :depends-on ("package"))
                                     (:file "speechbubble-bounding-boxes" :depends-on ("package"))
                                     (:file "text-bounding-boxes" :depends-on ("package"))
                                     (:file "assign-parents-to-ellipses" :depends-on ("package"))
                                     (:file "util" :depends-on ("package"))

                                     (:file "rules" :depends-on ("package"))

                                     (:file "demux" :depends-on ("package"))
                                     (:file "find-comments" :depends-on ("package" "classes"))
                                     (:file "find-metadata" :depends-on ("package" "classes" "util"))
                                     (:file "add-kinds" :depends-on ("package" "classes" "rules"))
                                     (:file "add-self-ports" :depends-on ("package" "classes" "rules"))
                                     (:file "create-centers" :depends-on ("package" "rules"))
                                     (:file "calculate-distances" :depends-on ("package" "rules"))
                                     (:file "make-unknown-port-names" :depends-on ("package" "classes"))
                                     (:file "closest" :depends-on ("package" "classes"))
                                     (:file "assign-portnames" :depends-on ("package" "classes" "closest"))
                                     (:file "mark-indexed-ports" :depends-on ("package" "classes"))
                                     (:file "coincident-ports" :depends-on ("package" "classes"))
                                     (:file "mark-directions" :depends-on ("package" "classes"))
                                     (:file "mark-nc" :depends-on ("package" "classes"))
                                     (:file "match-ports-to-components" :depends-on ("package" "classes"))
                                     (:file "pinless" :depends-on ("package" "classes"))
                                     (:file "sem-parts-have-some-ports" :depends-on ("package" "classes"))
                                     (:file "sem-ports-have-sink-or-source" :depends-on ("package" "classes"))
                                     (:file "sem-no-duplicate-kinds" :depends-on ("package" "classes"))
                                     (:file "sem-speech-vs-comments" :depends-on ("package" "classes"))
                                     (:file "assign-wire-numbers-to-edges" :depends-on ("package" "classes" "rules-util" "util"))
                                     (:file "self-input-pins" :depends-on ("package" "classes"))
                                     (:file "self-output-pins" :depends-on ("package" "classes"))
                                     (:file "input-pins" :depends-on ("package" "classes"))
                                     (:file "output-pins" :depends-on ("package" "classes"))

                                     (:file "ir-emitter" :depends-on ("package" "classes"))

                                     (:file "rules-util" :depends-on ("package"))


                                     (:file "compiler"
                                      :depends-on ("package" "classes"
                                                   "reader" "unmapper" "fb" "writer" "convert-to-keywords" "sequencer"
                                                   "ellipse-bounding-boxes" "rectangle-bounding-boxes"
                                                   "speechbubble-bounding-boxes" "text-bounding-boxes"
                                                   "assign-parents-to-ellipses"

                                                   "demux"
                                                   "find-comments"
                                                   "find-metadata"
                                                   "add-kinds"
                                                   "add-self-ports"

                                                   "make-unknown-port-names"
                                                   "assign-portnames"
                                                   "mark-indexed-ports"
                                                   "coincident-ports"
                                                   "mark-directions"
                                                   "mark-nc"
                                                   "match-ports-to-components"
                                                   "pinless"
                                                   "sem-parts-have-some-ports"
                                                   "sem-ports-have-sink-or-source"
                                                   "sem-no-duplicate-kinds"
                                                   "sem-speech-vs-comments"
                                                   "assign-wire-numbers-to-edges"
                                                   "self-input-pins"
                                                   "self-output-pins"
                                                   "input-pins"
                                                   "output-pins"

                                                   "create-centers"
                                                   "calculate-distances"

						   "ir-emitter"

                                                   "rules-util"

                                                   ))))))

