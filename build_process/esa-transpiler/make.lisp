(defparameter *script* "
  (uiop:run-program \"rm -rf ~/.cache/common-lisp\")
  (uiop:run-program \"rm -rf */*.fasl */*/*/.fasl\")
  (uiop:run-program \"rm -rf */*~ */*/*/*~\")  
  (ql:quickload :stack-dsl)
  (ql:quickload :stack-dsl/use)
  (stack-dsl:transpile-stack \"ARROWGRAMS/ESA-TRANSPILER\"
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/exprtypes.dsl\")
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/exprtypes.lisp\")
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/exprtypes.json\")
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/mechanisms.lisp\")
     )     
  (ql:quickload :parsing-assembler/use)
  (pasm:pasm-to-file \"ARROWGRAMS/ESA-TRANSPILER\"
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/dsl.pasm\")
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/dsl.lisp\"))
  (ql:quickload :arrowgrams/esa-transpiler/tester)
")

(defun make ()
  (with-input-from-string (s *script*)
    (loop
       (let ((cmd (read s nil :EOF)))
	 (when (eq :EOF cmd) (return))
	 (format *standard-output* "~&~s~%" cmd)
	 (eval cmd)))))

