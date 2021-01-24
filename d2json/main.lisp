(defun suicide (msg)
  (format *error-output* "~%~S~%" msg)
  #+lispworks (error msg) ;(lispworks:quit)
  #+sbcl (exit)
  )

(defun d2json-raw (infile outfile)
  (unless (probe-file infile)
    (error (format nil "d2json infile not found ~a~%" infile)))
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

(defun main ()
  (let ((args (my-command-line)))
    (d2json
     (arrowgrams/build::diagram-path \"helloworld-chelloworld\")
     (arrowgrams/build::json-graph-path \"helloworld-chelloworld\"))))
