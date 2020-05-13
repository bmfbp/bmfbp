(in-package :arrowgrams/build)

(defun arrowgrams-run ()
  (let ((lis nil))
    (loop for line = (read-line *standard-input* nil :eof)
       until (eq line :eof)
       do (push line lis))
    (let ((str (apply 'concatenate 'string (reverse lis))))
      (arrowgrams-load-and-run str))))

(defun main(argv)
  (declare (ignore argv))
  (handler-case
      (progn
	(arrowgrams-run)
    (end-of-file (c)
      (format *error-output* "0 FATAL 'end of file error; in main ~a~%" c))
    (simple-error (c)
      (format *error-output* "1 FATAL error1 in main~%")
      (print-object c))
    (error (c)
      (format *error-output* "2 FATAL error2 in main ~a~%" c)))))





(defun load-and-run (graph-filename)
  (let ((graph-string (alexandria:read-file-into-string graph-filename)))
    (arrowgrams-load-and-run graph-string)))

(defun arrowgrams-load-and-run (graph-string)
  (let ((graph-alist (json-to-alist graph-string)))
    #+nil(format *standard-output* "*** making kind from graph~%")
    (let ((top-kind (make-kind-from-graph graph-alist)))  ;; kind defined in esa.lisp
      
      #+nil(format *standard-output* "*** creating dispatcher~%")
      (let ((esa-disp (make-instance 'dispatcher)))  ;; dispatcher defined in esa.lisp

	#+nil(format *standard-output* "*** instantiating graph~%")
	(let ((top-node (instantiate-kind-recursively top-kind esa-disp)))

	  #+nil(format *standard-output* "*** initializing instances~%")
	  (initialize-all esa-disp)  ;; initialize-all is in esa.lisp

	  #+nil(format *standard-output* "*** distributing initial outputs~%")
	  (distribute-all-outputs esa-disp)  ;; distribute-all-outputs is in esa.lisp

	  #+nil(format *standard-output* "*** injecting START~%")
	  (let ((ev (make-instance 'event))
		(pp (make-instance 'part-pin)))
	    (setf (part-name pp) "self")
	    (setf (pin-name pp) "start")
            (setf (partpin ev) pp)
	    (setf (data ev) t)
	    (enqueue-input top-node ev))

	  #+nil(format *standard-output* "*** running~%")
	  (run esa-disp)  ;; run is in esa.lisp
          )))))

#+nil(defun test-load-and-run ()
  (load-and-run (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/helloworld.graph.json")))

#+nil(defun cl-user::arrowgrams-run (filename)
  (load-and-run (asdf:system-relative-pathname 
		 :arrowgrams 
		 (format nil "build_process/parts/graph/~a.json" filename))))

(defun test-load-and-run ()
  (cl-user::arrowgrams-run "hellohello"))


