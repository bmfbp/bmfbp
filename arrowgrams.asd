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
                                     (:file "parser-builder" :depends-on ("package" "readfileintostring" "pegtolisp" "stripquotes"))
                                     (:file "comments-to-end-of-line" :depends-on ("package"))
                                     (:file "ident" :depends-on ("package"))
                                     (:file "word" :depends-on ("package"))
                                     (:file "remove-ws-runs" :depends-on ("package"))))))

(defsystem :arrowgrams/clparts/test
  :depends-on (:arrowgrams/clparts)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "tester"
                        :pathname "./clparts"
                        :components ((:file "test")))))

(defsystem :arrowgrams/clparts/test-scanner
  :depends-on (:arrowgrams/clparts)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "scanner tester"
                        :pathname "./clparts"
                        :components ((:file "test-scanner")))))

;;;; 
;;;; builder
;;;;


(defsystem :arrowgrams/build/cl-build
  :depends-on (:arrowgrams :arrowgrams/clparts)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "cl-build"
                        :pathname "./build_process/cl-build/"
                        :components ((:file "package")
                                     (:file "util")
                                     (:file "json-parser" :depends-on ("package"))))))

(defsystem :arrowgrams/build/cl-build/test
  :depends-on (:arrowgrams/build/cl-build)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "test-cl-build"
                        :pathname "./build_process/cl-build/"
                        :components ((:file "package")
                                     (:file "test" :depends-on ("package"))))))

(defsystem :arrowgrams/build/cl-build/atest
  :depends-on (:cl-event-passing :cl-peg :loops :arrowgrams/clparts)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "build-pseudo"
                        :pathname "./build_process/cl-build/"
                        :components ((:file "package")
                                     (:file "pseudo-parser" :depends-on ("package"))
                                     (:file "atest" :depends-on ("package" "pseudo-parser"))))))


;;;; 
;;;; compiler rev 2, in CL
;;;;

(defsystem :arrowgrams/compiler
  :depends-on (:arrowgrams :arrowgrams/clparts :cl-holm-prolog :cl-ppcre)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "cl-compiler"
                        :pathname "./svg/cl-compiler/"
                        :components ((:file "package")
                                     (:file "fb" :depends-on ("package"))
                                     (:file "reader" :depends-on ("package"))
                                     (:file "writer" :depends-on ("package"))
                                     (:file "compiler" :depends-on ("reader"))))))

