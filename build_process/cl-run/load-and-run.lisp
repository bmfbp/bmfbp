(in-package :cl-user)

(defparameter *dispatcher* nil)

(defun main(argv)
  (declare (ignore argv))
(format *standard-output* "99~%")	  
  (handler-case
      (let ((lis nil))
	(format *standard-output* "~&in load and run~%")
	(loop for line = (read-line *standard-input* nil :eof)
	   until (eq line :eof)
	   do (push line lis))
	(let ((str (apply 'concatenate 'string (reverse lis))))
	  ; str is a json graph string
	  (old-arrowgrams-load-and-run str) 
          ))
    (end-of-file (c)
      (format *error-output* "0 FATAL 'end of file error; in main ~a~%" c))
    (simple-error (c)
      (format *error-output* "1 FATAL error1 in main~%")
      (cl:print-object c *error-output*))
    (error (c)
      (format *error-output* "2 FATAL error2 in main ~a~%" c))))

#|
To read a JSON template into memory, we need methods to suck the JSON in, then call “building kind” methods to make the Template (in memory).  After that, we call the “loading kind” method “loader” to instantiate Nodes from the Kinds.  Loading causes calls to the “loading dispatcher” methods to let the Dispatcher memo-rize all of the Nodes.  The Dispatcher needs to make a list of every Node, so that it can check readiness.  Nodes are “runtime” Parts.  We need to create exactly one Dispatcher before calling “kind loader”).  The sequence is something like: (1) read JSON and call “building kind” methods (2) create a Dispatcher (3) call “kind loader” on the top Node (4) tell the Dispatcher to initialize all Nodes (5) tell the Dispatcher to run.
|#

(defun load-and-run-app-from-file (json-graph-filename)
  (let ((text (alexandria:read-file-into-string json-graph-filename)))
    ;; load app into memory
    (let ((disp (make-instance 'dispatcher))
          (app (make-instance 'App)))
      (setf (json-string app) text)
      (let ((top-kind (read-json app)))
        ;; create Dispatcher (disp)
        ;; get top node of app
        top-kind
        ;; run "kind loader" on top kind - this create Nodes from Kind templates
        (let ((top-node (loader top-kind "TOP" nil disp)))
          (setf (top-node disp) top-node)
          ;; run initialize-all on dispatcher
          (initialize-all disp)  ;; initialize-all is in ../esa/esa.lisp
          ;; distribute all outputs
          (distribute-all-outputs disp)  ;; distribute-all-outputs is in ../esa/esa.lisp
          ;; inject start into top node
          (setf *dispatcher* disp)
          (dispatcher-inject *dispatcher* "start" t)
          )
        )
      )
))


;;;;;;;; old
(defun old-load-and-run-from-file (json-graph-filename)
  (let ((graph-string (alexandria:read-file-into-string json-graph-filename)))
    (old-arrowgrams-load-and-run graph-string)
))

(defun old-arrowgrams-load-and-run (json-graph-string)
  (let ((graph-alist (arrowgrams/build::json-to-alist json-graph-string)))
    (let ((top-kind (arrowgrams/build::make-kind-from-graph graph-alist)))  ;; kind defined in ../esa/esa.lisp
      (let ((esa-disp (make-instance 'dispatcher)))  ;; dispatcher defined in ../esa/esa.lisp
	(let ((top-node (arrowgrams/build::instantiate-kind-recursively top-kind esa-disp)))
          (set-top-node esa-disp top-node)
	  (initialize-all esa-disp)  ;; initialize-all is in ../esa/esa.lisp
	  (distribute-all-outputs esa-disp)  ;; distribute-all-outputs is in ../esa/esa.lisp
	  (dispatcher-run esa-disp)
	  (setf *dispatcher* esa-disp)
	  (dispatcher-inject *dispatcher* "start" t)
          esa-disp)))))
  

