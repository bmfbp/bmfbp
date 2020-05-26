(proclaim '(optimize (debug 3) (safety 3) (speed 0)))
(defparameter *script* "
  (uiop:run-program \"rm -rf ~/.cache/common-lisp\")
  (uiop:run-program \"rm -rf *.fasl */*.fasl */*/*/.fasl\")
  (uiop:run-program \"rm -rf *~ */*~ */*/*/*~\")  
  (ql:quickload :stack-dsl)
  (ql:quickload :stack-dsl/use)
  (format *standard-output* \"cd to ~~/quicklisp/local-projects/hier, then run awk -f 12.awk <12.txt >12.lisp , then copy 12.lisp into mech-tester.lisp and manually edit the result to insert names\")
  (stack-dsl:transpile-stack 
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/exprtypes.dsl\")
     \"CL-USER\"
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/exprtypes.lisp\")
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/exprtypes.json\")
     \"ARROWGRAMS/ESA-TRANSPILER\"
     \"CL-USER\"
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/mechanisms.lisp\")
     )     
  (ql:quickload :parsing-assembler/use)
  (pasm:pasm-to-file 
     \"ARROWGRAMS/ESA-TRANSPILER\"
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/dsl.pasm\")
     (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/dsl.lisp\"))
  (ql:quickload :arrowgrams/esa-transpiler)
  (load \"package.lisp\")
  (load \"classes.lisp\")
  (load \"dsl.lisp\")
  (load \"exprtypes.lisp\")
  (load \"mechanisms.lisp\")
  (load \"esa-transpile.lisp\")
  (load \"trace-rules.lisp\")
  (load \"trace-mechs.lisp\")
    (ql:quickload :arrowgrams/esa-transpiler/tester)
  (stack-dsl:initialize-types (arrowgrams/esa-transpiler:path \"exprtypes.json\"))
  (arrowgrams/esa-transpiler::test-esa-to-file \"test.esa\" \"test.lisp\" :tracing-accept t) 
")

(defun make ()
  (with-input-from-string (s *script*)
    (loop
       (let ((cmd (read s nil :EOF)))
	 (when (eq :EOF cmd) (return))
	 (format *standard-output* "~&~s~%" cmd)
	 (eval cmd)))))

;; after loading, do:
;; edit mech-tester.lisp to include latest 12.txt (from hier)
;; edit mech-tester.lisp to insert names, eg.
;; (setf (scanner:token-text (pasm:accepted-token p)) "self")
;; run test
;; (test-esa-to-file "test.esa" "test.lisp" t) 
;;(esa-input-filename output-filename &key (tracing-accept nil))
