(in-package :arrowgrams/build/cl-build)

(defun arrowgrams/build/cl-build::atest ()
  (format *standard-output* "~&running pseudo code parser~%")
  (let ((debug-rules '(pseudo-grammar top-level-description part-declarations internal-parts wiring)))
    (let ((peg-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "build_process/cl-build/pseudo.peg"))
          (pseudo-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "build_process/cl-build/build-process.pseudo"))
          (grammar-name 'arrowgrams/build/cl-build::pseudo-grammar))
    (pseudo-parser grammar-name peg-filename pseudo-filename :debug debug-rules))))

#|
first time (mostly to load package.lisp):
  (ql:quickload :arrowgrams/build/cl-build/atest)

subsequent times:
(progn
  (ql:quickload :arrowgrams/build/cl-build/atest)
  (arrowgrams/build/cl-build::atest))
|#

