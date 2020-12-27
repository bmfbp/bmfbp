;; written in esa.dsl
(defun lw4 ()
  (arrowgrams/build::arrowgrams-to-json "ahelloworld")
  (arrowgrams/build::isa-load-app-from-file  (arrowgrams/build::json-graph-path "ahelloworld")))


;; written in lisp
#+nil (defun lw4 ()
  (arrowgrams/build::arrowgrams-to-json "ahelloworld")
  (let ((top-kind (arrowgrams/build::load-and-run-from-file  (arrowgrams/build::json-graph-path "ahelloworld"))))
    ;; should output "parts/cl-a-parts/cl/aHELLOparts/cl/aWORLD"
    cl-user::*dispatcher*))
