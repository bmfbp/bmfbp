(defsystem arrowgram
  :depends-on (paip  ;; https://github.com/??? TODO
	       ;; <https://github.com/guitarvydas/loops>
	       loops)
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
				 '("lisp/prolog.lisp"))
				   ;;; paip::replace-?-vars is at bottom of prolog.lisp
			 (cl:load 
			  (asdf:system-relative-pathname
			   :paip paip-requirement))))
		  (setf *package* original-package)))))
		       

(defsystem arrowgram/database
  :depends-on (arrowgram)
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
  :components ((:file "lwpasses")))

