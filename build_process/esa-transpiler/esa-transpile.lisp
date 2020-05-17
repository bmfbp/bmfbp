(in-package :arrowgrams/esa-transpiler)

(defun transpile-esa-to-string (esa-input-filename)
  (let ((in-string (alexandria:read-file-into-string esa-input-filename)))
    (let ((token-stream (scanner:scanner in-string)))
      (let ((p (make-instance 'arrowgrams/esa-transpiler::parser)))
	(pasm:initially p token-stream)
	;(esa-dsl p)  ;; call top rule
	(esa-expr p)  ;; call mid-rule during development
	(let ((result (get-output-stream-string (pasm:output-string-stream p))))
	  (concatenate 'string 
		       (format nil "(in-package :esa)~%~%")
		       result))))))

(defun transpile-esa-to-file (esa-input-filename output-filename)
  (let ((str (transpile-esa-to-string esa-input-filename)))
    (with-open-file (outf output-filename :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string str outf))))
