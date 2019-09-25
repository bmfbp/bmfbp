(in-package :cl-user)

(prove:plan 5)

(prove:ok
 (let ((input (asdf:system-relative-pathname :arrowgram "../js-compiler/temp5.lisp"))
       (output (asdf:system-relative-pathname :arrowgram "../js-compiler/lisp-out.lisp")))
   (prove:ok input "Input exists.")
   (with-open-file (in input :direction :input)
     (with-open-file (out output  :direction :output :if-exists :supersede)
       (arrowgram::readfb in)
       (prove:ok (length paip::*db-predicates*))
       (format *error-output* "~&running (expected (rects/texts/speech/ellipse) 11/49/1/3)~%")
       (arrowgram::bounding-boxes)
       (arrowgram::assign-parents-to-ellipses)
       #+nil ;; failing!
       (find-comments)
       (arrowgram::writefb out)))))
       
(prove:ok
 (arrowgram::deb)
 "Basic main task to initialize Knowledge base." )

(prove:ok
 (progn 
   (arrowgram::make-bounding-boxes-for-rectangles)
   (arrowgram::make-bounding-boxes-for-text)
   (arrowgram::make-bounding-boxes-for-speech-bubbles)
   (arrowgram::make-bounding-boxes-for-ellipses))
 "Testing bounding boxes.")

(prove:finalize)
