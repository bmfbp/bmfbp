;;; Use the ARROWGRAM::PARSE-ON-PATHS macro to test various compilation passes

;;; Test the PARSE-ON-PATHS macro just for the bounding boxes
(prove:plan 1)
(let ((input-pathname
       (asdf:system-relative-pathname
        :arrowgram "../js-compiler/temp5.lisp"))
      (output-pathname
       (asdf:system-relative-pathname
        :arrowgram "../js-compiler/lisp-out.lisp")))
  (arrowgram::parse-on-paths (input-pathname output-pathname)
    (let ((bounding-results (arrowgram::bounding-boxes))
          (expected '(11 49 1 3)))
      (prove:is bounding-results
                expected
                (format nil "Bounding box compilation produces ~a elements"
                        expected)))))

(prove:plan 1)
(let ((input-pathname
       (asdf:system-relative-pathname
        :arrowgram "../js-compiler/temp5.lisp"))
      (output-pathname
       (asdf:system-relative-pathname
        :arrowgram "../js-compiler/lisp-out.lisp")))
  (arrowgram::parse-on-paths (input-pathname output-pathname)
     (progn
       (arrowgram::bounding-boxes)
       (arrowgram::assign-parents-to-ellipses)
       (prove:isnt
        (arrowgram::find-comments)
        nil
        "Testing that find-comments returns something…"))))
                                    
(prove:finalize)
