(in-package :arrowgrams/make-esa-compiler)

(defun make-esa-compiler ()
  (arrowgrams/make-esa-compiler::create-esa-compiler 
   (asdf:system-relative-pathname :arrowgrams "build_process/make-esa-compiler/esa.rp")
   (asdf:system-relative-pathname :arrowgrams "build_process/use-esa/esa-dsl.lisp")))
