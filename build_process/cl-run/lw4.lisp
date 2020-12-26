(defun lw4 ()
  (arrowgrams/build::arrowgrams-to-json "ahelloworld")
  (arrowgrams/build::load-and-run-from-file  (arrowgrams/build::json-graph-path "ahelloworld"))
  ;; should output "parts/cl-a-parts/cl/aHELLOparts/cl/aWORLD"
  cl-user::*dispatcher*)
