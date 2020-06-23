(in-package :arrowgrams/build)

(defun main(argv)
  (declare (ignore argv))
  (handler-case
      (let ((lis nil))
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
      (cl:print-object c))
    (error (c)
      (format *error-output* "2 FATAL error2 in main ~a~%" c))))

(defun load-and-run-from-file (json-graph-filename)
  (let ((graph-string (alexandria:read-file-into-string json-graph-filename)))
    (arrowgrams-load-and-run graph-string)))

(defun arrowgrams-load-and-run (json-graph-string)
  (let ((graph-alist (json-to-alist json-graph-string)))
    (let ((top-kind (make-kind-from-graph graph-alist)))  ;; kind defined in ../esa/esa.lisp
      (let ((esa-disp (make-instance 'dispatcher)))  ;; dispatcher defined in ../esa/esa.lisp
	(let ((top-node (instantiate-kind-recursively top-kind esa-disp)))
	  (initialize-all esa-disp)  ;; initialize-all is in ../esa/esa.lisp
	  (distribute-all-outputs esa-disp)  ;; distribute-all-outputs is in ../esa/esa.lisp
	  (let ((ev (make-instance 'event))
		(pp (make-instance 'part-pin)))
	    (setf (part-name pp) "self")
	    (setf (pin-name pp) "start")
            (setf (partpin ev) pp)
	    (setf (data ev) t)
	    (enqueue-input top-node ev))
	  (dispatcher-run esa-disp)  ;; dispatcher-run is in esa.lisp
          )))))


