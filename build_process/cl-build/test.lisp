(in-package :arrowgrams/build/cl-build)

(defun arrowgrams/build/cl-build::test-all ()
  (format *standard-output* "~&running json parser~%")
  (let ((debug-rules '(json value object members member arry elements element string)))
    (let ((peg-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "build_process/cl-build/json.peg"))
          (json-filename (asdf:system-relative-pathname :arrowgrams/build/cl-build "build_process/cl-build/test.json")))
      (json-parser peg-filename json-filename :debug debug-rules)))

#|
first time:
  (ql:quickload :arrowgrams/build/cl-build/test)

subsequent times:
(progn
  (ql:quickload :arrowgrams/build/cl-build/test)
  (arrowgrams/build/cl-build::test-all))
|#