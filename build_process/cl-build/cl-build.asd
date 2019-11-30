(defsystem :arrowgrams/builder/cl-build
  :depends-on (:arrowgrams :arrowgrams/clparts)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "cl-build"
                        :pathname "./build_process/cl-build/"
                        :components ((:file "package")
                                     (:file "json-parser" :depends-on ("package"))))))

(defsystem :arrowgrams/builder/cl-build/test
  :depends-on (:arrowgrams/builder/cl-build)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "test-cl-build"
                        :pathname "./build_process/cl-build/"
                        :components ((:file "package")
                                     (:file "test" :depends-on ("package"))))))

