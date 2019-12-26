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


;;;; 
;;;; compiler rev 2, in CL, using Holm prolog
;;;;

(defsystem :arrowgrams/compiler
  :depends-on (:arrowgrams :arrowgrams/clparts :cl-holm-prolog :cl-ppcre)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "cl-compiler"
                        :pathname "./svg/cl-compiler/"
                        :components ((:file "package")
                                     (:file "classes" :depends-on ("package"))
                                     (:file "fb" :depends-on ("package" "util"))
                                     (:file "sequencer" :depends-on ("package"))
                                     (:file "reader" :depends-on ("package"))
                                     (:file "writer" :depends-on ("package"))
                                     (:file "convert-to-keywords" :depends-on ("package"))
                                     (:file "ellipse-bounding-boxes" :depends-on ("package"))
                                     (:file "rectangle-bounding-boxes" :depends-on ("package"))
                                     (:file "speechbubble-bounding-boxes" :depends-on ("package"))
                                     (:file "text-bounding-boxes" :depends-on ("package"))
                                     (:file "assign-parents-to-ellipses" :depends-on ("package"))
                                     (:file "util" :depends-on ("package"))

                                     (:file "demux" :depends-on ("package"))
                                     (:file "find-comments" :depends-on ("package" "classes"))
                                     (:file "find-metadata" :depends-on ("package" "classes" "util"))
                                     (:file "add-kinds" :depends-on ("package" "classes"))
                                     (:file "add-self-ports" :depends-on ("package" "classes"))
                                     (:file "make-unknown-port-names" :depends-on ("package" "classes"))
                                     (:file "create-centers" :depends-on ("package" "classes"))
                                     (:file "calculate-distances" :depends-on ("package" "classes"))
                                     (:file "assign-portnames" :depends-on ("package" "classes"))
                                     (:file "mark-indexed-ports" :depends-on ("package" "classes"))
                                     (:file "coincident-ports" :depends-on ("package" "classes"))
                                     (:file "mark-directions" :depends-on ("package" "classes"))
                                     (:file "match-ports-to-components" :depends-on ("package" "classes"))
                                     (:file "pinless" :depends-on ("package" "classes"))
                                     (:file "sem-parts-have-some-ports" :depends-on ("package" "classes"))
                                     (:file "sem-ports-have-sink-or-source" :depends-on ("package" "classes"))
                                     (:file "sem-no-duplicate-kinds" :depends-on ("package" "classes"))
                                     (:file "sem-speech-vs-comments" :depends-on ("package" "classes"))
                                     (:file "assign-wire-numbers-to-edges" :depends-on ("package" "classes"))
                                     (:file "self-input-pins" :depends-on ("package" "classes"))
                                     (:file "self-output-pins" :depends-on ("package" "classes"))
                                     (:file "input-pins" :depends-on ("package" "classes"))
                                     (:file "output-pins" :depends-on ("package" "classes"))

                                     (:file "compiler"
                                      :depends-on ("package" "classes"
                                                   "reader" "fb" "writer" "convert-to-keywords" "sequencer"
                                                   "ellipse-bounding-boxes" "rectangle-bounding-boxes"
                                                   "speechbubble-bounding-boxes" "text-bounding-boxes"
                                                   "assign-parents-to-ellipses"

                                                   "demux"
                                                   "find-comments"
                                                   "find-metadata"
                                                   "add-kinds"
                                                   "add-self-ports"
                                                   "make-unknown-port-names"
                                                   "create-centers"
                                                   "calculate-distances"
                                                   "assign-portnames"
                                                   "mark-indexed-ports"
                                                   "coincident-ports"
                                                   "mark-directions"
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
                                                   
                                                   ))))))


(defsystem arrowgrams/prolog-peg
  :depends-on (:arrowgrams :esrap :cl-peg)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./svg/prolog2lisp"
			:components ((:file "package")
                                     (:file "spacing-peg" :depends-on ("package"))
				     (:file "keyword-peg" :depends-on ("package"))
				     (:file "comment-peg" :depends-on ("package"))
				     (:file "identifier-peg" :depends-on ("package"))
				     (:file "number-peg" :depends-on ("package"))
				     (:file "original-peg" :depends-on ("package"))
				     (:file "refactored-peg" :depends-on ("package"))
				     (:file "generic-peg" :depends-on ("package"))
				     (:file "h-peg" :depends-on ("package"))
				     (:file "prolog-peg" :depends-on ("package"))
				     (:file "all" :depends-on ("package" "spacing-peg" "keyword-peg" "comment-peg"
                                      "identifier-peg" "number-peg" "original-peg" "refactored-peg" "generic-peg" "h-peg"))
                                     ))))
