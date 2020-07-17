(in-package :arrowgrams/build)

(defun main(argv)
  (declare (ignore argv))
  (handler-case
      (let ((lis nil))
	(format *standard-output* "~&in load and run~%")
	(loop for line = (read-line *standard-input* nil :eof)
	   until (eq line :eof)
	   do (push line lis))
	(let ((str (apply 'concatenate 'string (reverse lis))))
	  ; str is a json graph string
	  (arrowgrams-load-and-run str)))
    (end-of-file (c)
      (format *error-output* "0 FATAL 'end of file error; in main ~a~%" c))
    (simple-error (c)
      (format *error-output* "1 FATAL error1 in main~%")
      (cl:print-object c *error-output*))
    (error (c)
      (format *error-output* "2 FATAL error2 in main ~a~%" c))))

(defun load-and-run-from-file (json-graph-filename)
  (let ((graph-string (alexandria:read-file-into-string json-graph-filename)))
    (arrowgrams-load-and-run graph-string)))

(defun arrowgrams-load-and-run (json-graph-string)
  (let ((graph-alist (json-to-alist json-graph-string)))
    (let ((top-kind (make-kind-from-graph graph-alist)))  ;; kind defined in ../esa/esa.lisp
      (let ((esa-disp (make-instance 'cl-user::dispatcher)))  ;; dispatcher defined in ../esa/esa.lisp
	(let ((top-node (instantiate-kind-recursively top-kind esa-disp)))
          (cl-user::set-top-node esa-disp top-node)
	  (cl-user::initialize-all esa-disp)  ;; initialize-all is in ../esa/esa.lisp
	  (cl-user::distribute-all-outputs esa-disp)  ;; distribute-all-outputs is in ../esa/esa.lisp
          esa-disp)))))
  

