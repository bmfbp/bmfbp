(in-package :arrowgrams/build)

(defun create-arrowgrams-builder ()
  (ql:quickload :arrowgrams/build))

(defun run-builder ()
  (build (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/boot-boot.svg")))

(defun make-all ()
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/esa-compiler)
  (create-esa-compiler)
  (compile-esa :from "esa.dsl" :to "esa.lisp")
  (create-arrowgrams-builder))

(defun run-all ()
  (make-all)
  (run-builder))


(defun cl-user::make-all () (arrowgrams/build::make-all))
(defun cl-user::run-all () (arrowgrams/build::run-all))
(defun cl-user::runb () (arrowgrams/build::run-builder))
