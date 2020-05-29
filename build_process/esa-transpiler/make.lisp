(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

  #+nil(format *standard-output* \"cd to ~/quicklisp/local-projects/hier, then run awk -f 12.awk <12.txt >12.lisp , then copy 12.lisp into mech-tester.lisp and manually edit the result to insert names\")

(defparameter *script* "
  (uiop:run-program \"rm -rf \~/.cache/common-lisp\")
  (uiop:run-program \"rm -rf *.fasl */*.fasl */*/*/.fasl\")
  (uiop:run-program \"rm -rf *~\")  

  (proclaim '(optimize (debug 3) (safety 3) (speed 0)))

  (ql:quickload :stack-dsl)
  (ql:quickload :stack-dsl/use)
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
  (load (arrowgrams/esa-transpiler::path \"package.lisp\"))
  (load (arrowgrams/esa-transpiler::path \"classes.lisp\"))
  (load (arrowgrams/esa-transpiler::path \"dsl.lisp\"))
  (load (arrowgrams/esa-transpiler::path \"exprtypes.lisp\"))
  (load (arrowgrams/esa-transpiler::path \"mechanisms.lisp\"))
  (load (arrowgrams/esa-transpiler::path \"mech-tester.lisp\"))
  (load (arrowgrams/esa-transpiler::path \"esa-transpile.lisp\"))
  (load (arrowgrams/esa-transpiler::path \"trace-rules.lisp\"))
  (load (arrowgrams/esa-transpiler::path \"trace-mechs.lisp\"))
    (ql:quickload :arrowgrams/esa-transpiler/tester)
  (stack-dsl:initialize-types (arrowgrams/esa-transpiler:path \"exprtypes.json\"))
  #+nil(arrowgrams/esa-transpiler::trace-mechs)
  #+nil(arrowgrams/esa-transpiler::trace-rules)
  (arrowgrams/esa-transpiler::transpile-esa-to-string 
    (arrowgrams/esa-transpiler:path \"../esa/esa.dsl\")
    :tracing-accept t)
  #+nil(arrowgrams/esa-transpiler::transpile-esa-to-string 
    (arrowgrams/esa-transpiler:path \"test.esa\")
    :tracing-accept t)
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





(defparameter *escript* "
  (uiop:run-program \"rm -rf \~/.cache/common-lisp\")
  (uiop:run-program \"rm -rf *.fasl */*.fasl */*/*/.fasl\")
  (uiop:run-program \"rm -rf *~\")  

  (proclaim '(optimize (debug 3) (safety 3) (speed 0)))

  (ql:quickload :stack-dsl)
  (ql:quickload :stack-dsl/use)
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
  (let ((pasm:*pasm-accept-tracing* t))
    (pasm:pasm-to-file 
       \"ARROWGRAMS/ESA-TRANSPILER\"
       (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/dsl.pasm\")
       (asdf:system-relative-pathname :arrowgrams \"build_process/esa-transpiler/dsl.lisp\")))
")

;; temporary helper while transpiling alpha exprtypes.dsl
(defun emake ()
  (with-input-from-string (s *escript*)
    (loop
       (let ((cmd (read s nil :EOF)))
	 (when (eq :EOF cmd) (return))
	 (format *standard-output* "~&~s~%" cmd)
	 (eval cmd)))))
