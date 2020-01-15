(defun cl-user::xx ()
  (arrowgrams/compiler::xx))

(defun arrowgrams/compiler::xx ()
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/compiler)
  (arrowgrams/compiler::compiler))