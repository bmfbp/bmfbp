(defsystem arrowgram
  :depends-on (paip
	       ;; <https://github.com/guitarvydas/loops>
	       loops)
  :components ((:module package
			:pathname "./"
			:components ((:file "package")))
	       (:module source
			:depends-on (package)
			:pathname "./"
			:components ((:file "everything"))))
  :perform (load-op :after (op c)
	      (let ((original-package *package*))
		(unwind-protect
		     (progn
		       (setf *package* (find-package :paip))
		       (dolist (paip-requirement
				 '("lisp/prolog.lisp"
				   ;;; Needed for defintion of
				   ;;; paip::replace-?-vars
				   "lisp/krep.lisp"))
			 (cl:load 
			  (asdf:system-relative-pathname
			   :paip paip-requirement))))
		  (setf *package* original-package)))))
		       

(defsystem arrowgram/database
  :depends-on (arrowgram)
  :components ((:module contents
			:pathname "./"
			:components ((:file "assign-parents-to-ellipses")
				     (:file "bounding-boxes"))))
  :perform (asdf:load-op :before (op c)
              (funcall (uiop/package:find-symbol* :clear-db :paip))))

(defsystem arrowgram/lwpasses
  :depends-on (arrowgram/database)
  :components ((:file "lwpasses")))

