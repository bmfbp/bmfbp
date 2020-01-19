(in-package :arrowgrams/compiler/xform)

(cl-peg:into-package :arrowgrams/compiler/xform)

(defun parse-ir (filename &key (trace nil))
  (let ((example-as-string 
	 (alexandria:read-file-into-string
          (asdf:system-relative-pathname :arrowgrams filename))))
    (when trace
      (esrap:trace-rule 'arrowgrams-intermediate-representation :recursive t)
      (esrap:untrace-rule '<not-dquote>)
      (esrap:untrace-rule 'WS)
      (esrap:untrace-rule '<white-space>)
      (esrap:untrace-rule '<comment>)
      (esrap:untrace-rule '<end-of-input>)
      (esrap:untrace-rule '<end-of-line>)
      (esrap:untrace-rule '<same-line>)
      (esrap:untrace-rule 'STRING)
      (esrap:untrace-rule 'IDENT))

    (esrap:parse 'arrowgrams-intermediate-representation example-as-string)))

(defun xtest ()
  (parse-ir (asdf:system-relative-pathname :arrowgrams "svg/cl-compiler/BUILD_PROCESS.ir") :trace t))

(defun cl-user::xtest ()
  (arrowgrams/compiler/xform::xtest))