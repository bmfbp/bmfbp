(in-package :arrowgrams/compiler/xform)

(cl-peg:into-package :arrowgrams/compiler/xform)

(defun parse-ir ()
  (let ((example-as-string (alexandria:read-file-into-string
                            (asdf:system-relative-pathname :arrowgrams "svg/xform/test.ir"))))
    (esrap:trace-rule 'arrowgrams-intermediate-representation :recursive t)
    (esrap:parse 'arrowgrams-intermediate-representation example-as-string)))

