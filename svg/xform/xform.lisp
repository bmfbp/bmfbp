(in-package :arrowgrams/compiler/xform)

(cl-peg:into-package :arrowgrams/compiler/xform)

(defun parse-ir ()
  (let ((example-as-string 
	 (alexandria:read-file-into-string
          (asdf:system-relative-pathname :arrowgrams "svg/xform/test.ir"))))
#|
    (esrap:trace-rule 'arrowgrams-intermediate-representation)
    (esrap:trace-rule '<self-Part>)
    (esrap:trace-rule '<self-kind>)
    (esrap:trace-rule '<self-inputs>)
    (esrap:trace-rule '<self-outputs>)
    (esrap:trace-rule '<self-wiring>)
    (esrap:trace-rule '<self-part-decls>)
    (esrap:trace-rule '<wire>)
    (esrap:trace-rule '<wire-id>)
    (esrap:trace-rule '<froms>)
    (esrap:trace-rule '<tos>)
    (esrap:trace-rule '<part-pin>)
    (esrap:trace-rule '<part-decl>)
    (esrap:trace-rule '<id>)
    (esrap:trace-rule '<kind>)
    (esrap:trace-rule '<inputs>)
    (esrap:trace-rule '<outputs>)
    (esrap:trace-rule '<part-id-or-self>)
    (esrap:trace-rule '<part-id>)
    (esrap:trace-rule '<pin-id>)

    (esrap:trace-rule '<react-function>)
    (esrap:trace-rule '<first-time-function>)
  
|#
    (esrap:trace-rule 'arrowgrams-intermediate-representation :recursive t)
    (esrap:untrace-rule '<not-dquote>)
    (esrap:untrace-rule 'LPAR)
    (esrap:untrace-rule 'RPAR)
    (esrap:untrace-rule 'WS)
    (esrap:untrace-rule '<white-space>)
    (esrap:untrace-rule '<comment>)
    (esrap:untrace-rule '<end-of-input>)
    (esrap:untrace-rule '<end-of-line>)
    (esrap:untrace-rule '<same-line>)

    (esrap:parse 'arrowgrams-intermediate-representation example-as-string)))

