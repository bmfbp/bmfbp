(in-package :arrowgrams/esa-transpiler)

(defun transpile-esa-to-string (esa-input-filename &key (tracing-accept nil))
  (let ((in-string (alexandria:read-file-into-string esa-input-filename)))
    (let ((token-stream (scanner:scanner in-string)))
      (let ((p (make-instance 'arrowgrams/esa-transpiler::parser)))
	(pasm:initially p token-stream)
	(let ((pasm::*pasm-accept-tracing* tracing-accept))
	  (esa-dsl p))  ;; call top rule
	  #+nil(tester p)  ;; call mid-rule during development
	(let ((result (get-output-stream-string (pasm:output-string-stream p))))
	  (concatenate 'string 
		       (format nil "(in-package :esa)~%~%")
		       result)
	  result)))))

(defun transpile-esa-to-file (esa-input-filename output-filename &key (tracing-accept nil))
  (let ((str (transpile-esa-to-string esa-input-filename :tracing-accept tracing-accept)))
    (with-open-file (outf output-filename :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string str outf))))
