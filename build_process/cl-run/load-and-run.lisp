(in-package :arrowgrams/build)

(defun load-and-run (graph-filename)
  (let ((graph-alist (json-to-alist (alexandria:read-file-into-string graph-filename))))
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

(defun test-lar ()
  (load-and-run (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/helloworld.graph.json")))

