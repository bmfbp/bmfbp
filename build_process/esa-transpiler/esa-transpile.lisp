(in-package :arrowgrams/esa-transpiler)

(defun run-pass (comment-string pass-parsing-func program token-stream tracing-accept br)
  (format *standard-output* "~&* pass ~a~%" comment-string)
  (let ((p (make-instance 'arrowgrams/esa-transpiler::parser)))
    (unless (null program)
      (stack-dsl:%push (cl-user::input-esaProgram (env p))
		       program))
    (pasm:initially p token-stream)
    (cl-user::%memoStacks (env p))
    (let ((pasm::*pasm-accept-tracing* tracing-accept))
      (funcall pass-parsing-func p))  ;; call parser for this pass
    (check-stacks p)
    (when br
      (break "break in run-pass"))
    (unless (stack-dsl:%empty-p (cl-user::output-esaProgram (env p)))
      (stack-dsl:%top (cl-user::output-esaProgram (env p))))  ;; return resulting program data structure up to this point
    ))

(defun transpile-esa-to-string (esa-input-filename &key (tracing-accept nil))
  (let ((in-string (alexandria:read-file-into-string esa-input-filename)))
    (let ((token-stream (scanner:scanner in-string)))
      (let ((p (make-instance 'arrowgrams/esa-transpiler::parser)))
	(let ((program0 (run-pass "0" #'esa-dsl-pass0 nil token-stream nil nil)))
	  (let ((program1 (run-pass "1" #'esa-dsl-pass1 nil token-stream nil nil)))
	    (let ((program2 (run-pass "2" #'esa-dsl-pass2 program1 token-stream nil nil)))
	      (let ((program3 (run-pass "3" #'esa-dsl-pass3 program2 token-stream nil nil)))
                (values 
                 (cl-user::asLisp program3)
                 (cl-user::asJs program3))
                 ))))))))



