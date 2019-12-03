(in-package :arrowgrams/build/cl-build)

(defun arrowgrams/build/cl-build::atest ()
  (format *standard-output* "~&running pseudo code parser~%")
  (let ((debug-rules '(pseudo value j-object members member j-array elements element j-string)))
    (let ((peg-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "build_process/cl-build/pseudo.peg"))
          (pseudo-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "build_process/cl-build/build-process.pseudo")))
      (pseudo-parser peg-filename pseudo-filename))))

#|
first time:
  (ql:quickload :arrowgrams/build/cl-build/atest)

subsequent times:
(progn
  (ql:quickload :arrowgrams/build/cl-build/atest)
  (arrowgrams/build/cl-build::atest))
|#

