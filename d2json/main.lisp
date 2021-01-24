(defun suicide (msg)
  (format *error-output* "~%~S~%" msg)
  #+lispworks (error msg) ;(lispworks:quit)
  #+sbcl (exit)
  )

(defun d2json-raw (infile outfile)
  (unless (probe-file infile)
    (error (format nil "d2json: infile not found ~a~%" infile)))
  (arrowgrams/build::compile-to-json infile outfile))

(defun d2json (infile outfile)
  (handler-case
      (d2json-raw infile outfile)
    (end-of-file (c)
      (format *error-output* "FATAL 'end of file error; in d2json ~a~%" c))
    (simple-error (c)
      (format *error-output* "FATAL error in d2json ~a~%" c))
    (error (c)
      (format *error-output* "FATAL error in d2json ~a~%" c))))

(defun main (x)
  (declare (ignore x))
  (let ((args (arrowgrams/build::my-command-line)))
    (declare (ignore args))
    (d2json-raw
     "~/quicklisp/local-projects/arrowgrams/work/diagrams/helloworld-helloworld-bootstrap.svg"
     "~/quicklisp/local-projects/arrowgrams/work/json/helloworld-helloworld-bootstrap.15.json")))
