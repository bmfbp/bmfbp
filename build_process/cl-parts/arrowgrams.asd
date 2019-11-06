(defsystem arrowgrams
  :depends-on (loops cl-messaging) 	       ;; <https://github.com/guitarvydas/loops/>
  ;; see https://stackoverflow.com/questions/45730012/common-lisp-asdf-tests-compile-system-with-different-optimization-levels>
  ;; and
  ;;  <https://common-lisp.net/project/asdf/asdf/Controlling-file-compilation.html>
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module package
			:pathname "./"
			:components ((:file "package")))))


(defsystem arrowgrams/loader
  :depends-on (arrowgrams)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module contents
                :pathname "./"
                :components ((:file "loader")))))

