(in-package :cl-user)

(prove:plan 2)
(let ((input-pathname
       (asdf:system-relative-pathname
        :arrowgram "../js-compiler/temp5.lisp"))
      (output-pathname
       (asdf:system-relative-pathname
        :arrowgram "../js-compiler/lisp-out.lisp")))
  (prove:ok (probe-file input-pathname)
            (format nil "Whether the input file ~a exists…" input-pathname))
  (with-open-file (in input-pathname
                      :direction :input)
    (with-open-file (out output-pathname
                         :direction :output :if-exists :supersede)
      (arrowgram::readfb in :clear-fb t)
      (prove:ok (length paip::*db-predicates*))
      (format *error-output* "~&running (expected (rects/texts/speech/ellipse) 11/49/1/3)~%")
      (let ((bounding-results (arrowgram::bounding-boxes)))
        (prove:is bounding-results
                  '(11 49 1 3)
                  "Checking results of bounding boxes…"))
      (arrowgram::assign-parents-to-ellipses)
      #+nil
      (arrowgram::find-comments)
      (arrowgram::writefb out))))

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
                '(11 49 1 3)
                "Compiling for bounding boxes…"))))

(prove:finalize)
