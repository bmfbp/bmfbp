(in-package :paip)

;;; N.b. The current state of the world (aka. "the factbase") ends up
;;; in PAIP::*db-predicates*

(defun readfb (stream &key (clear-fb nil))
  "Read a factbase from STREAM

When CLEAR-FB is non nil, clear the existing factbase before reading."
  (when clear-fb
    (paip::clear-db))
  (let ((original-package *package*))
    (unwind-protect
         (progn 
           ;(setf *package* (find-package :arrowgram))
           (setf *package* (find-package :paip))
           (flet ((read1 ()
                    (read stream nil 'eof)))
             (let ((clause (read1)))
               (@:loop
                 (@:exit-when (eq 'eof clause))
                 (paip::add-clause (paip::replace-?-vars (list clause)))
                 (setf clause (read1))))))
      (setf *package* original-package))))

(defun writefb (stream)
  "Write the contents the the current factbase to STREAM"
  (let ((preds paip::*db-predicates*))
    (@:loop
     (@:exit-when (null preds))
     (let ((p (pop preds)))
       (let ((clauses (get p 'paip::clauses)))
         (@:loop
           (@:exit-when (null clauses))
            (let ((c (pop clauses)))
              (assert (= 1 (length c)))
              (format stream "~&~a~%"
                      (string-downcase (format nil "~a" (car c)))))))))))
  
#+nil
(defun main ()
    (let ((in *standard-input*)
	  (out *standard-output*))
      (readfb in)
      (format *error-output* "~&running~%")
FIXME .. 
      (writefb out)))

(defun deb ()
;; should be 11/49/1/3 (rects/texts/speech/ellipse) for build_process.svg
  (with-open-file (in (asdf:system-relative-pathname :arrowgram "../js-compiler/temp5.lisp") :direction :input)
    (with-open-file (out (asdf:system-relative-pathname :arrowgram "../js-compiler/lisp-out.lisp") :direction :output :if-exists :supersede)
      (readfb in :clear-fb t)
      (format *error-output* "~&running (expected (rects/texts/speech/ellipse) 11/49/1/3)~%")
      (bounding-boxes)
      #+nil(assign-parents-to-ellipses)
      #+nil(find-comments)
      (writefb out)
      (values))))

;;; An attempt at generalizing the main loop
(defmacro parse-on-paths ((input-pathname output-pathname) &body body)
  "Run the BODY of compilation on INPUT-PATHNAME placing the results
in OUTPUT-PATHNAME"
  `(with-open-file (in ,input-pathname
                       :direction :input)
     (with-open-file (out ,output-pathname
                          :direction :output
                          :if-exists :supersede)
       (format t "~&Compiling~%~t'~a'~%to~%~t'~a'~^"
               ,input-pathname ,output-pathname)
       (readfb in :clear-fb t)
       ;;; return the values of BODY as a simple list to our caller
       (prog1
           (multiple-value-list ,@body)
         (writefb out)))))

