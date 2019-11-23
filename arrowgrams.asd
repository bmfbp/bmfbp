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
                                     (:file "pegparser" :depends-on ("package" "readfileintostring" "pegtolisp" "stripquotes"))))))

