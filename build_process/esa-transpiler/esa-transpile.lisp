(in-package :arrowgrams/esa-transpiler)

(defun transpile-esa-to-string (esa-input-filename &key (tracing-accept nil))
  (let ((in-string (alexandria:read-file-into-string esa-input-filename)))
    (let ((token-stream (scanner:scanner in-string)))
      (let ((p (make-instance 'arrowgrams/esa-transpiler::parser)))
	(pasm:initially p token-stream)
	(let ((pasm::*pasm-accept-tracing* tracing-accept))
	  (esa-dsl-pass0 p))  ;; call parser to check if syntax is OK
	(pasm:initially p token-stream)
	(let ((pasm::*pasm-accept-tracing* tracing-accept))
	  (esa-dsl-pass1 p))  ;; call top rule of 1st pass to generate dsl1.lisp
	(let ((result-pass1 (get-output-stream-string (pasm:output-string-stream p))))
	  (pasm:initially p token-stream)
	  (let ((pasm::*pasm-accept-tracing* tracing-accept))
	    #+nil(esa-dsl-pass2 p))  ;; call top rule of 2nd pass to generate dsl2.lisp
	  (let ((result-pass2 (get-output-stream-string (pasm:output-string-stream p))))
	    (let ((final (concatenate 'string 
				      (format nil "(in-package :esa)~%~%")
				      result-pass1
				      result-pass2)))
	      final)))))))

(defun transpile-esa-to-file (esa-input-filename output-filename &key (tracing-accept nil))
  (let ((str (transpile-esa-to-string esa-input-filename :tracing-accept tracing-accept)))
    (with-open-file (outf output-filename :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string str outf))))

