;; written in esa.dsl
(defun lw4 ()
  (arrowgrams/build::arrowgrams-to-json "ahelloworld")
  (arrowgrams/build::load-and-run-app-from-file  (arrowgrams/build::json-graph-path "ahelloworld")))

(defun lw ()
  (lw0)
  (lw1)
  (lw3)
  (lw4))
