(defun die (msg)
  (format *error-output* "~%~S~%" msg)
  #+lispworks (error msg) ;(lispworks:quit)
  #+sbcl (exit)
  )

(defun d2-json-raw (infile outfile)
  (arrowgrams/build::compile-to-json infile outfile))

(defun main ()
  (handler-case
      (let ((args (my-command-line)))
	(d2-json-raw
	 (arrowgrams/build::diagram-path \"helloworld-chelloworld\")
	 (arrowgrams/build::json-graph-path \"helloworld-chelloworld\")))	
    (end-of-file (c)
      (format *error-output* "FATAL 'end of file error; in d2json ~a~%" c))
    (simple-error (c)
      (format *error-output* "FATAL error in d2json ~a~%" c))
    (error (c)
      (format *error-output* "FATAL error in d2json ~a~%" c))))

