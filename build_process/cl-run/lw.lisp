(defparameter *script*
"
(defun lw0 ()
  (uiop:run-program \"~/quicklisp/local-projects/rm.bash\") 
  (ql:quickload :arrowgrams/esa-transpiler)
  (load (asdf:system-relative-pathname :arrowgrams \"build_process/esa/package.lisp\"))
  (load (asdf:system-relative-pathname :arrowgrams \"build_process/esa/path.lisp\")))

(lw0)

(defun transpile ()
  (stack-dsl:initialize-types (arrowgrams/esa-transpiler:path \"exprtypes.json\"))
  (let ((result 
         (arrowgrams/esa-transpiler::transpile-esa-to-string 
          (arrowgrams/esa:path \"esa.dsl\")
          :tracing-accept nil)))
    (with-open-file (f (arrowgrams/esa:path \"esa.lisp\") :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string \"(in-package :arrowgrams/build)\" f)
      (write-string \"(proclaim '(optimize (debug 3) (safety 3) (speed 0)))\" f)
      (write-string \"
\" f)
      (write-string result f))
    (with-open-file (f (arrowgrams/esa:path \"cl-user-esa.lisp\") :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string \"(in-package :cl-user)\" f)
      (write-string \"(proclaim '(optimize (debug 3) (safety 3) (speed 0)))\" f)
      (write-string \"
\" f)
      (write-string result f))
	    
    (let ((js-result 
           (arrowgrams/esa-transpiler::transpile-esa-to-js-string 
            (arrowgrams/esa:path \"esa.dsl\")
            :tracing-accept nil)))
      (with-open-file (f (arrowgrams/esa:path \"esa.js\") :direction :output :if-exists :supersede :if-does-not-exist :create)
        (write-string \"// esa.js\" f)
        (write-string \"
\" f)
        (write-string js-result f)))

    ))

(defun lw1 () (transpile))

(lw1)

(defun lw3 () 
  (uiop:run-program \"~/quicklisp/local-projects/rm.bash\")
  (ql:quickload :arrowgrams/build)
  (ql:quickload :arrowgrams/runner))

  (lw3)

(defun lw4 ()
  (arrowgrams/build::arrowgrams-to-json \"ahelloworld\")
  (arrowgrams/build::load-and-run-app-from-file  (arrowgrams/build::json-graph-path \"ahelloworld\")))

(defun lw4-old ()
  (arrowgrams/build::arrowgrams-to-json \"ahelloworld\")
  (arrowgrams/build::old-load-and-run-from-file  (arrowgrams/build::json-graph-path \"ahelloworld\")))

"
)

;; expect lots of undefined arrowgrams/build::*
;; running (lw4-old) should print "/cl-a-parts/cl/aHELLOparts/cl/aWORLD"

;(defmacro loop (&body body) `(cl:loop ,@body))
;(defmacro exit-when (test) `(cl:when ,test (cl:return)))



(defun lw ()
  (with-input-from-string (strm *script*)
    (let ((def (read strm nil nil)))
      (loop 
       (when (null def) (return))
       (format *standard-output* "evaling ~a~%" def)
       (eval def)
       (setf def (read strm nil nil))))))
  
