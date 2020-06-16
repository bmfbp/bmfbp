(in-package :arrowgrams/esa-transpiler)

(defun transpile-esa-to-string (esa-input-filename &key (tracing-accept nil))
  (let ((in-string (alexandria:read-file-into-string esa-input-filename)))
    (let ((token-stream (scanner:scanner in-string)))
      (let ((p (make-instance 'arrowgrams/esa-transpiler::parser)))
	(pasm:initially p token-stream)
        (cl-user::%memoStacks (env p))
	(let ((pasm::*pasm-accept-tracing* tracing-accept))
	  (esa-dsl-pass0 p))  ;; call parser to check if syntax is OK
	(pasm:initially p token-stream)
	(let ((pasm::*pasm-accept-tracing* tracing-accept))
	  (cl-user::%memoStacks (env p))
	  (esa-dsl-pass1 p)  ;; call top rule of 1st pass
	  ;; ... and keep result in ep
	  (let ((ep (stack-dsl:%top (cl-user::output-esaprogram (env p)))))
	    (setf (esaprogram p) ep)
	    (stack-dsl:%pop (cl-user::output-esaprogram (env p)))
	    #+nil(let ()
	      (format *standard-output* "~&*** check stacks pass 1 ***~%")
	      (check-stacks p)
	      (format *standard-output* "~&*** ***~%~%")
	      (cl-user::%memoCheck (env p)))
	    (cl-user::%memoStacks (env p))
	    (let ((result-pass1 (get-output-stream-string (pasm:output-string-stream p))))
	      (let ((pasm::*pasm-accept-tracing* tracing-accept))
		(pasm:initially p token-stream)
		(esa-dsl-pass2 p)  ;; call top rule of 2nd pass
		(stack-dsl:%pop (cl-user::output-esaprogram (env p))))
	      #+nil(let ()
		(format *standard-output* "~&*** check stacks pass 2 ***~%")
		(check-stacks p)
		(format *standard-output* "~&*** ***~%~%")
		(cl-user::%memoCheck (env p)))
	      (let ((result-pass2 (get-output-stream-string (pasm:output-string-stream p))))
		
		;; pass3
		(let ((p (make-instance 'arrowgrams/esa-transpiler::parser)))
		  (let ((pasm::*pasm-accept-tracing* tracing-accept))
		    (cl-user::%memoStacks (env p))
		    (pasm:initially p token-stream)
		    ;... restore esaprogram
		    (stack-dsl:%push (cl-user::output-esaprogram (env p)) ep)
		    (setf (esaprogram p) ep)
		    ;...
		    (esa-dsl-pass3 p)  ;; call top rule of 3rd pass
		    (break "test 3")
		    (stack-dsl:%pop (cl-user::output-esaprogram (env p))))
		  (let ()
		    (format *standard-output* "~&*** check stacks pass 3 ***~%")
		    (check-stacks p)
		    (format *standard-output* "~&*** ***~%~%")
		    (cl-user::%memoCheck (env p)))
		  (let ((result-pass3 (get-output-stream-string (pasm:output-string-stream p))))

		    
		    (let ((final (concatenate 'string 
					      (format nil "(in-package :esa)~%(proclaim '(optimize (debug 3) (safety 3) (speed 0)))~%~%")
					      result-pass1
					      result-pass2
					      result-pass3)))
		    final)))))))))))
