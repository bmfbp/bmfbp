;(in-package :arrowgrams/build)
(in-package :cl-user)

(defparameter cl-user::*dispatcher* nil)

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
    (let ((d (make-instance 'cl-user::dispatcher))
          (app (make-instance 'cl-user::App)))
      (setf (cl-user::json-string app) text)
      (let ((k (cl-user::read-json app)))
        ;; get top node of app
        ;; create Dispatcher
        ;; run "kind loader" on top node
        ;; inject start into top node
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
      (let ((esa-disp (make-instance 'cl-user::dispatcher)))  ;; dispatcher defined in ../esa/esa.lisp
	(let ((top-node (arrowgrams/build::instantiate-kind-recursively top-kind esa-disp)))
          (cl-user::set-top-node esa-disp top-node)
	  (cl-user::initialize-all esa-disp)  ;; initialize-all is in ../esa/esa.lisp
	  (cl-user::distribute-all-outputs esa-disp)  ;; distribute-all-outputs is in ../esa/esa.lisp
	  (cl-user::dispatcher-run esa-disp)
	  (setf cl-user::*dispatcher* esa-disp)
	  (cl-user::dispatcher-inject cl-user::*dispatcher* "start" t)
          esa-disp)))))
  

