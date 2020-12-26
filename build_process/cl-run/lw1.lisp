(defun transpile ()
  (stack-dsl:initialize-types (arrowgrams/esa-transpiler:path "exprtypes.json"))
  (let ((result 
         (arrowgrams/esa-transpiler::transpile-esa-to-string 
          (arrowgrams/esa:path "esa.dsl")
          :tracing-accept nil)))
    (with-open-file (f (arrowgrams/esa:path "esa.lisp") :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string "(in-package :arrowgrams/build)" f)
      (write-string "(proclaim '(optimize (debug 3) (safety 3) (speed 0)))" f)
      (write-string "
" f)
      (write-string result f))
    (with-open-file (f (arrowgrams/esa:path "cl-user-esa.lisp") :direction :output :if-exists :supersede :if-does-not-exist :create)
      (write-string "(in-package :cl-user)" f)
      (write-string "(proclaim '(optimize (debug 3) (safety 3) (speed 0)))" f)
      (write-string "
" f)
      (write-string result f))
	    
    (let ((js-result 
           (arrowgrams/esa-transpiler::transpile-esa-to-js-string 
            (arrowgrams/esa:path "esa.dsl")
            :tracing-accept nil)))
      (with-open-file (f (arrowgrams/esa:path "esa.js") :direction :output :if-exists :supersede :if-does-not-exist :create)
        (write-string "// esa.js" f)
        (write-string "
" f)
        (write-string js-result f)))

    ))

(defun lw1 () (transpile))
