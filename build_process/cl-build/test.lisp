(in-package :arrowgrams/build/cl-build)

(defun arrowgrams/build/cl-build::test-all ()
  (format *standard-output* "~&running json parer~%")
  (let ((peg-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "test.peg"))
        (json-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "test.json")))
    (json-parser peg-filename json-filename)))

