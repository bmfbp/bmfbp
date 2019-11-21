(defsystem "clsvg/arrowgrams"
  :depends-on (cl-event-passing)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module "clsvg"
                        :pathname "./"
                        :components ((:file "fatal")
                                     (:file "filestream")
                                     (:file "iter")
                                     (:file "cat")
                                     (:file "feedback"))))
