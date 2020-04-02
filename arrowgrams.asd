(defsystem :arrowgrams
  :depends-on (:cl-peg :loops)
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
  :depends-on (:arrowgrams #| :esrap |# :cl-event-passing :loops)
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
  :depends-on (:arrowgrams #| :esrap |# :cl-event-passing :loops :cl-peg)
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
                                     (:file "json1-sl" :depends-on ("token"))
				     (:file "json1-emitter" :depends-on ("token" "parse-util" "json1-sl"))
				     (:file "parser" :depends-on ("../cl-compiler/package" "token" "tokenize" "strings" "ws"
                                                                  "symbols" "integers" "spaces" "preparse" "file-writer"
                                                                  "generic-emitter" "collector" "lisp-emitter" "json1-emitter"
                                                                  "emitter-pass2-generic" "json-emitter" "file-namer" "synchronizer"))))))


;;;; 
;;;; compiler rev 2, in CL, using Holm prolog
;;;;

(defsystem :arrowgrams/compiler/part
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "compiler-part-class-definition"
                        :pathname "./svg/cl-compiler/"
                        :components ((:file "package")
                                     (:file "compiler-part" :depends-on ("package"))))))

(defsystem :arrowgrams/compiler/front-end
  :depends-on (:arrowgrams :arrowgrams/compiler/part)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "front-end"
                        :pathname "./svg/front-end/"
                        :components ((:file "../cl-compiler/package")
                                     (:file "main" :depends-on ("../cl-compiler/package"))
                                     (:file "drawio" :depends-on ("../cl-compiler/package" "main"))))))
(defsystem :arrowgrams/compiler
  :depends-on (:arrowgrams :cl-holm-prolog :cl-ppcre :cl-json :arrowgrams/compiler/back-end :arrowgrams/compiler/part :arrowgrams/compiler/front-end)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "cl-compiler"
                        :pathname "./svg/cl-compiler/"
                        :components ((:file "package")
                                     (:file "classes" :depends-on ("package"))

                                     (:file "probe" :depends-on ("package"))

				     (:file "compiler-part" :depends-on ("package" "classes"))

                                     (:file "fb" :depends-on ("compiler-part" "util"))
                                     (:file "sequencer" :depends-on ("compiler-part"))
                                     (:file "unmapper" :depends-on ("compiler-part"))
                                     (:file "reader" :depends-on ("compiler-part"))
                                     (:file "writer" :depends-on ("compiler-part"))
                                     (:file "convert-to-keywords" :depends-on ("compiler-part"))
                                     (:file "ellipse-bounding-boxes" :depends-on ("compiler-part"))
                                     (:file "rectangle-bounding-boxes" :depends-on ("compiler-part"))
                                     (:file "speechbubble-bounding-boxes" :depends-on ("compiler-part"))
                                     (:file "text-bounding-boxes" :depends-on ("compiler-part"))
                                     (:file "assign-parents-to-ellipses" :depends-on ("compiler-part"))
                                     (:file "util" :depends-on ("compiler-part"))

                                     (:file "rules" :depends-on ("compiler-part"))

                                     (:file "demux" :depends-on ("compiler-part"))
                                     (:file "find-comments" :depends-on ("compiler-part"))
                                     (:file "find-metadata" :depends-on ("compiler-part" "util"))
                                     (:file "add-kinds" :depends-on ("compiler-part" "rules"))
                                     (:file "add-self-ports" :depends-on ("compiler-part" "rules"))
                                     (:file "create-centers" :depends-on ("compiler-part" "rules"))
                                     (:file "calculate-distances" :depends-on ("compiler-part" "rules"))
                                     (:file "make-unknown-port-names" :depends-on ("compiler-part"))
                                     (:file "closest" :depends-on ("compiler-part"))
                                     (:file "assign-portnames" :depends-on ("compiler-part" "closest"))
                                     (:file "mark-indexed-ports" :depends-on ("compiler-part"))
                                     (:file "coincident-ports" :depends-on ("compiler-part"))
                                     (:file "mark-directions" :depends-on ("compiler-part"))
                                     (:file "mark-nc" :depends-on ("compiler-part"))
                                     (:file "match-ports-to-components" :depends-on ("compiler-part"))
                                     (:file "pinless" :depends-on ("compiler-part"))
                                     (:file "sem-parts-have-some-ports" :depends-on ("compiler-part"))
                                     (:file "sem-ports-have-sink-or-source" :depends-on ("compiler-part"))
                                     (:file "sem-no-duplicate-kinds" :depends-on ("compiler-part"))
                                     (:file "sem-speech-vs-comments" :depends-on ("compiler-part"))
                                     (:file "assign-wire-numbers-to-edges" :depends-on ("compiler-part" "rules-util" "util"))
                                     (:file "self-input-pins" :depends-on ("compiler-part"))
                                     (:file "self-output-pins" :depends-on ("compiler-part"))
                                     (:file "input-pins" :depends-on ("compiler-part"))
                                     (:file "output-pins" :depends-on ("compiler-part"))

                                     (:file "ir-emitter" :depends-on ("compiler-part"))

                                     (:file "rules-util" :depends-on ("compiler-part"))


                                     (:file "compiler"
                                      :depends-on ("package" "classes" "compiler-part"
                                                   "probe"
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


(defsystem :arrowgrams/rephrase-compiler
    :depends-on (:arrowgrams/cl-event-passing-no-esrap :alexandria)
    :around-compile (lambda (next)
                      (proclaim '(optimize (debug 3)
                                  (safety 3)
                                  (speed 0)))
                      (funcall next))
    :components ((:module "source"
                          :pathname "./build_process/esa"
                          :components ((:file "package")
                                       (:file "token" :depends-on ("package"))
                                       (:file "classes" :depends-on ("package"))
                                       (:file "rp-macros" :depends-on ("package"))
				       
                                       (:file "dumper" :depends-on ("token" "classes"))

				       (:file "tokenize" :depends-on ("token" "classes"))
                                       (:file "comments" :depends-on ("token" "classes"))
                                       (:file "raw-text" :depends-on ("token" "classes"))
                                       (:file "strings" :depends-on ("token" "classes"))
                                       (:file "spaces" :depends-on ("token" "classes"))
                                       (:file "symbols" :depends-on ("token" "classes"))
                                       (:file "integers" :depends-on ("token" "classes"))

                                       (:file "error-manager" :depends-on ("token" "classes"))

                                       (:file "parser-mechanisms"
					      :depends-on ("package"
							   "token" "classes" "dumper"
                                                           "rp-macros"
                                                           "error-manager"
							   "tokenize" "comments" "raw-text" "strings" "spaces"
							   "symbols" "integers"))
                                       (:file "rp-rules" :depends-on ("parser-mechanisms"))
                                       (:file "rp-parser" :depends-on ("rp-rules"))
                                       (:file "file-writer" :depends-on ("package" "classes"))
                                       (:file "parser-schem" :depends-on ("file-writer" "rp-parser"))))))

(defsystem :arrowgrams/esa
    :depends-on (:arrowgrams/rephrase-compiler)
    :around-compile (lambda (next)
                      (proclaim '(optimize (debug 3)
                                  (safety 3)
                                  (speed 0)))
                      (funcall next))
    :components ((:module "source"
                          :pathname "./build_process/esa"
                          :components ((:file "esa-dsl")
                                       (:file "esa-parser")))))

#+nil (defsystem :arrowgrams/esa-js
    :depends-on (:arrowgrams/rephrase-compiler)
    :around-compile (lambda (next)
                      (proclaim '(optimize (debug 3)
                                  (safety 3)
                                  (speed 0)))
                      (funcall next))
    :components ((:module "source"
                          :pathname "./build_process/esa"
                          :components ((:file "esa-dsl-js")
                                       (:file "esa-parser")))))

(defsystem :arrowgrams/build
  :depends-on (:arrowgrams/esa :cl-ppcre :cl-json :loops :cl-holm-prolog :arrowgrams/v4compiler)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "arrowgrams-builder"
                        :pathname "./build_process/cl-build/"
                        :components ((:file "package")
                                     (:file "classes" :depends-on ("package"))
                                     (:file "util" :depends-on ("package"))
                                     (:file "esa" :depends-on ("package" "classes" "util"))
                                     (:file "json" :depends-on ("package"))
                                     (:file "probe" :depends-on ("package" "classes" "util"))
                                     (:file "probe2" :depends-on ("package" "classes" "util"))
                                     (:file "probe3" :depends-on ("package" "classes" "util"))
                                     (:file "file-writer" :depends-on ("package"))
                                     (:file "graph-class" :depends-on ("package" "classes" "util" "esa"))
                                     (:file "esa-methods" :depends-on ("package" "classes" "util" "esa"))
                                     (:file "json-array-splitter" :depends-on ("package" "classes" "util"))
                                     (:file "part-namer" :depends-on ("package" "classes" "util"))
                                     (:file "get-manifest-file" :depends-on ("package" "classes" "util"))
                                     (:file "get-code" :depends-on ("package" "classes" "util"))
                                     (:file "schematic-or-leaf" :depends-on ("package" "classes" "util"))
                                     (:file "build-collector" :depends-on ("package" "classes" "util"))
                                     (:file "children-before-graph" :depends-on ("package" "classes" "util" "esa" "esa-methods"))
                                     (:file "build-graph-in-memory" :depends-on ("package" "classes" "esa" "json" "util" "graph-class"))
                                     (:file "graph" :depends-on ("package" "classes" "util" "esa" "graph-class"))
                                     (:file "runner" :depends-on ("package" "classes" "util" "graph"))
				     (:file "build" :depends-on ("package" "classes" "json"
                                                                 "probe" "probe2" "probe3"
                                                                 "file-writer"
                                                                 "part-namer" "json-array-splitter"
                                                                 "schematic-or-leaf" "build-collector"
								 "children-before-graph"
                                                                 "get-manifest-file" "get-code"
                                                                 "build-graph-in-memory" "runner"
                                                                 "esa" "esa-methods"
                                                                 "graph"
                                                                 "util"
                                                                 ))
				     ))))

(defsystem :arrowgrams/runner
  :depends-on (:arrowgrams/build :cl-json)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "arrowgrams-runner-utility"
                        :pathname "./build_process/cl-run"
                        :components ((:file "../cl-build/package")
                                     (:file "esa-methods" :depends-on ("../cl-build/package"))
                                     (:file "esa" :depends-on ("../cl-build/package" "esa-methods"))
                                     (:file "make-kind-from-graph" :depends-on ("esa"))
                                     (:file "instantiate-kind-recursively" :depends-on ("esa"))
                                     (:file "load-and-run" 
					    :depends-on (
							 "make-kind-from-graph"
							 "instantiate-kind-recursively"
							 ))))))

(defsystem :arrowgrams/bundle
  :depends-on (:arrowgrams/build :cl-json)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "arrowgrams-bundle"
                        :pathname "./build_process/cl-bundle"
                        :components ((:file "example")))))


;;;;;;;;;;
;;;;;;;;;; compiler v4
;;;;;;;;;;

(defsystem "arrowgrams/cl-event-passing-no-esrap"
  :depends-on (:loops)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module "source"
                        :pathname "./cl-event-passing-no-esrap"
                        :components ((:file "package")
                                     (:file "util" :depends-on ("package"))
                                     (:file "net-parser" :depends-on ("package"))
                                     (:file "pin" :depends-on ("package" "event"))
                                     (:file "part" :depends-on ("package" "pin"))
                                     (:file "schematic" :depends-on ("package" "pin" "part" "source" "event"))
                                     (:file "event" :depends-on ("package"))
                                     (:file "source" :depends-on ("package" "pin" "event" "wire"))
                                     (:file "receiver" :depends-on ("package" "pin" "event" "part"))
                                     (:file "wire" :depends-on ("package" "util" "receiver" "pin"))
                                     (:file "dispatch" :depends-on ("package" "util" "part" "event"))
				     (:file "macro-support"  :depends-on ("package" "util" "pin" "part" "schematic" "event"
                                                                          "source" "receiver" "wire" "dispatch"))
				     (:file "macro"  :depends-on ("package" "util" "pin" "part" "schematic" "event"
                                                                          "source" "receiver" "wire" "dispatch"))
				     (:file "api"  :depends-on ("package" "util" "pin" "part"
                                                                "schematic" "event" "source" "receiver" "wire" "dispatch"))
				     (:file "logging"  :depends-on ("api" "macro" "macro-support" "package" "util" "pin" "part"
                                                                "schematic" "event" "source" "receiver" "wire" "dispatch"))
				     (:file "checking"  :depends-on ("api" "macro" "macro-support" "package" "util" "pin" "part"
                                                                "schematic" "event" "source" "receiver" "wire" "dispatch"))))))

(defsystem :arrowgrams/v4compiler/top
  :depends-on (:arrowgrams/cl-event-passing-no-esrap :cl-holm-prolog :cl-ppcre :cl-json :alexandria)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "v4compiler-top"
                        :pathname "./v4/"
                        :components ((:file "package")
                                     (:file "part" :depends-on ("package"))
                                     (:file "classes" :depends-on ("package" "part"))
                                     (:file "util" :depends-on ("package" "part" "classes"))
))))

(defsystem :arrowgrams/v4compiler/front-end
  :depends-on (:arrowgrams/v4compiler/top)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "front-end"
                        :pathname "./v4/front-end/"
                        :components ((:file "main")
                                     (:file "drawio" :depends-on ("main"))))))

(defsystem arrowgrams/v4compiler/back-end
  :depends-on (:arrowgrams/v4compiler/top)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./v4/back-end"
			:components ((:file "token")
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
                                     (:file "file-namer")
                                     (:file "collector" :depends-on ("token" "parse-util" "collector-sl" "schem-unparse"))
                                     (:file "emitter-pass2-generic-sl" :depends-on ("token" "parse-util"))
                                     (:file "emitter-pass2-generic" :depends-on ("token" "parse-util" "emitter-pass2-generic-sl"))
                                     (:file "json-emitter-sl" :depends-on ("token" "parse-util"))
                                     (:file "json-emitter" :depends-on ("token" "parse-util" "json-emitter-sl"))
                                     (:file "generic-sl" :depends-on ("token"))
				     (:file "generic-emitter" :depends-on ("token" "parse-util" "generic-sl"))
                                     (:file "lisp-sl" :depends-on ("token"))
				     (:file "lisp-emitter" :depends-on ("token" "parse-util" "lisp-sl"))
                                     (:file "json1-sl" :depends-on ("token"))
				     (:file "json1-emitter" :depends-on ("token" "parse-util" "json1-sl"))
				     (:file "parser" :depends-on ("token" "tokenize" "strings" "ws"
                                                                  "symbols" "integers" "spaces" "preparse" "file-writer"
                                                                  "generic-emitter" "collector" "lisp-emitter" "json1-emitter"
                                                                  "emitter-pass2-generic" "json-emitter" "file-namer" "synchronizer"))))))

(defsystem :arrowgrams/v4compiler
  :depends-on (:arrowgrams/v4compiler/top :arrowgrams/v4compiler/front-end :arrowgrams/v4compiler/back-end)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "cl-compiler"
                        :pathname "./v4/cl-compiler/"
                        :components (
                                     (:file "probe")

                                     (:file "fb")
                                     (:file "sequencer")
                                     (:file "unmapper")
                                     (:file "reader")
                                     (:file "writer")
                                     (:file "convert-to-keywords")
                                     (:file "ellipse-bounding-boxes")
                                     (:file "rectangle-bounding-boxes")
                                     (:file "speechbubble-bounding-boxes")
                                     (:file "text-bounding-boxes")
                                     (:file "assign-parents-to-ellipses")

                                     (:file "rules")

                                     (:file "demux")
                                     (:file "find-comments")
                                     (:file "find-metadata")
                                     (:file "add-kinds" :depends-on ("rules"))
                                     (:file "add-self-ports" :depends-on ("rules"))
                                     (:file "create-centers" :depends-on ("rules"))
                                     (:file "calculate-distances" :depends-on ("rules"))
                                     (:file "make-unknown-port-names")
                                     (:file "closest")
                                     (:file "assign-portnames" :depends-on ("closest"))
                                     (:file "mark-indexed-ports")
                                     (:file "coincident-ports")
                                     (:file "mark-directions")
                                     (:file "mark-nc")
                                     (:file "match-ports-to-components")
                                     (:file "pinless")
                                     (:file "sem-parts-have-some-ports")
                                     (:file "sem-ports-have-sink-or-source")
                                     (:file "sem-no-duplicate-kinds")
                                     (:file "sem-speech-vs-comments")
                                     (:file "assign-wire-numbers-to-edges" :depends-on ("rules-util" ))
                                     (:file "self-input-pins")
                                     (:file "self-output-pins")
                                     (:file "input-pins")
                                     (:file "output-pins")

                                     (:file "ir-emitter")

                                     (:file "rules-util")

                                     (:file "compiler"
                                      :depends-on ("probe"
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


