(in-package :arrowgrams/esa-transpiler)

(defun print-tester (esa-input-filename &key (tracing-accept nil))
  (let ((in-string (alexandria:read-file-into-string esa-input-filename)))
    (let ((token-stream (scanner:scanner in-string)))
      (let ((p (make-instance 'arrowgrams/esa-transpiler::parser)))
	(pasm:initially p token-stream)
	(let ((pasm::*pasm-accept-tracing* tracing-accept))
	  (cl-user::%memoStacks (env p))
	  (print-tester-pass3 p)  ;; call print-test rule of 3rd pass
	  (let ((n (stack-dsl:%top (cl-user::output-name (env p)))))
	    (format *standard-output* "~&~%~a~%" (cl-user::asString n)))
)))))
