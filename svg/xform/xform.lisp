(in-package :arrowgrams/compiler/xform)

(cl-peg:into-package :arrowgrams/compiler/xform)

(defun parse-ir (filename &key (trace nil))
  (let ((string-to-be-parsed 
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

    (let ((result (esrap:parse 'arrowgrams-intermediate-representation string-to-be-parsed)))
      (esrap:untrace-rule 'arrowgrams-intermediate-representation :recursive t)
      result)))

(defun convert-ir-to-lisp (filename &key (trace nil))
  (let ((string-to-be-parsed 
	 (alexandria:read-file-into-string
          (asdf:system-relative-pathname :arrowgrams filename))))
    (when trace
      (esrap:trace-rule 'ir-to-lisp-grammar :recursive t)
      (esrap:untrace-rule '<not-dquote>)
      (esrap:untrace-rule 'WS)
      (esrap:untrace-rule '<white-space>)
      (esrap:untrace-rule '<comment>)
      (esrap:untrace-rule '<end-of-input>)
      (esrap:untrace-rule '<end-of-line>)
      (esrap:untrace-rule '<same-line>)
      (esrap:untrace-rule 'STRING)
      (esrap:untrace-rule 'IDENT))

    (let ((result (esrap:parse 'ir-to-lisp-grammar string-to-be-parsed)))
      (esrap:untrace-rule 'ir-to-lisp-grammar :recursive t)
      result)))
  
(defun clear ()
  (esrap::clear-rules)
  (ql:quickload :arrowgrams/compiler/xform))

(defun xtest ()
  (let ((ir-filename (asdf:system-relative-pathname :arrowgrams "svg/cl-compiler/BUILD_PROCESS.ir")))
    (let ((a (parse-ir ir-filename :trace t))
	  (b (convert-ir-to-lisp ir-filename :trace t)))
      (list a b))
    ))

(defun cl-user::xtest ()
  (arrowgrams/compiler/xform::xtest))

(defun cl-user::clear ()
  (arrowgrams/compiler/xform::clear))
