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



