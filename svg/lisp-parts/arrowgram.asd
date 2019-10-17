(defsystem arrowgram
  :depends-on (paip            ;; <https://github.com/norvig/paip-lisp/>
               loops) 	       ;; <https://github.com/guitarvydas/loops/>
  ;; see   ;; https://stackoverflow.com/questions/45730012/common-lisp-asdf-tests-compile-system-with-different-optimization-levels>
  ;; and
  ;;  <https://common-lisp.net/project/asdf/asdf/Controlling-file-compilation.html>
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module package
			:pathname "./"
			:components ((:file "package")))
	       (:module source
			:depends-on (package)
			:pathname "./"
			:components ((:file "everything"))))
  :perform (load-op :after (operation component)
	      (let ((original-package *package*))
		(unwind-protect
		     (progn
		       (setf *package* (find-package :paip))
		       (dolist (paip-requirement
				 '("lisp/prologc.lisp"
                                   "lisp/prologcp.lisp"))
			 (cl:load 
			  (asdf:system-relative-pathname
			   :paip paip-requirement))))
		  (setf *package* original-package)))))
		       

(defsystem arrowgram/grammar-tests
  :depends-on (arrowgram esrap cl-peg)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./"
			:components ((:file "grammar-test"))))
  :perform (asdf:load-op :before (op c)
              (funcall (uiop/package:find-symbol* :clear-db :paip))))

(defsystem arrowgram/esrap-error
  :depends-on (arrowgram esrap cl-peg arrowgram/grammar-tests)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./"
			:components ((:file "spacing-peg")
				     )))
  :perform (asdf:load-op :before (op c)
              (funcall (uiop/package:find-symbol* :clear-db :paip))))

(defsystem arrowgram/prolog-grammar
  :depends-on (arrowgram esrap cl-peg arrowgram/grammar-tests)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./"
			:components ((:file "spacing-peg")
				     (:file "keyword-peg")
				     (:file "comment-peg")
				     (:file "identifier-peg")
				     (:file "number-peg")
				     (:file "prolog-peg")
				     )))
  :perform (asdf:load-op :before (op c)
              (funcall (uiop/package:find-symbol* :clear-db :paip))))

(defsystem arrowgram/database
  :depends-on (arrowgram)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./"
			:components ((:file "common-queries")
                                     (:file "find-comments")
                                     (:file "assign-parents-to-ellipses")
				     (:file "bounding-boxes"))))
  :perform (asdf:load-op :before (op c)
              (funcall (uiop/package:find-symbol* :clear-db :paip))))

(defsystem arrowgram/lwpasses
  :depends-on (arrowgram/database)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:file "lwpasses")))

