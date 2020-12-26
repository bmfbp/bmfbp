(defun lw3 () 
  (uiop:run-program "~/quicklisp/local-projects/rm.bash")
  (ql:quickload :arrowgrams/build)
  (ql:quickload :arrowgrams/runner))
