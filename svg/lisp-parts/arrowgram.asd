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

(defsystem arrowgram/prolog-peg
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
				     (:file "original-peg")
				     (:file "refactored-peg")
				     (:file "generic-peg")
				     (:file "paip-peg")
				     (:file "prolog-peg")
				     )))
  :perform (asdf:load-op :before (op c)
              (funcall (uiop/package:find-symbol* :clear-db :paip))))

(defsystem arrowgram/extensions
  :depends-on (arrowgram)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./"
			:components ((:file "everything")
                                     (:file "prolog-extension")
                                     (:file "paip-extension"))))
  :perform (asdf:load-op :before (op c)
              (funcall (uiop/package:find-symbol* :clear-db :paip))))

(defsystem arrowgram/database
  :depends-on (arrowgram/extensions)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module contents
			:pathname "./"
			:components ((:file "fb")
                                     (:file "calc-bounds")))))
  ;; do not clear db here
  ;; :perform (asdf:load-op :before (op c)
  ;;            (funcall (uiop/package:find-symbol* :clear-db :paip))))

(defsystem arrowgram/try
  :depends-on (arrowgram/database)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:file "try")))

