(defun main(dont-care)
  (declare (ignore dont-care))
  (let ((argv uiop:*command-line-arguments*))
(format *standard-output* "~&len=~A args = /~S/~%" (length argv) argv)
    (arrowgrams/compiler::compiler)))

;     (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/kk5.pro")
;     (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/kk-temp-string-map.lisp")
;     (asdf:system-relative-pathname :arrowgrams/compiler "svg/cl-compiler/output.prolog"))))
