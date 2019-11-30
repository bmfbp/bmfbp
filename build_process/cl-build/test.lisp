(in-package :arrowgrams/build/cl-build)

(defun arrowgrams/build/cl-build::test-all ()
  (format *standard-output* "~&running json parser~%")
  (let ((peg-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "build_process/cl-build/test.peg"))
        (json-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "build_process/cl-build/test-nowhitespace.json")))
    (json-parser peg-filename json-filename)))

#|
(ql:quickload :arrowgrams/build/cl-build/test)
(arrowgrams/build/cl-build::test-all)
|#