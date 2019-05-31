;; see comment in main()

(defparameter *in-stream* nil)
(defparameter *string-map* nil)
(defparameter *input* nil)
(defparameter *output* nil)

(defun die ()
  #+lispworks (quit)
  #+sbcl (exit)
  )
  
(defun @get-uid-for-read-map (sym)
  "helper for @read-map ; return sym, if it is a string-map 'struidGxxx'"
  (when (symbolp sym)
    (let ((namestr (symbol-name sym)))
      (when (string= "stringuidG" (subseq namestr 0 9))
	sym))))

(defun @read-map ()
  "read the temp-string-map.lisp pairs into a local hashtable"
  (setf *string-map* (make-hash-table))
  (with-open-file (f "temp-string-map.lisp" :direction :input)
    (let ((pair (read f nil 'EOF)))
      (loop
	 (when (eq 'EOF pair)
	   (return))
	 (let ((uid (@get-uid-for-read-map (car pair))))
	   (when uid 
	       (setf (gethash uid *string-map*) (second pair)))
	   (setf pair (read *in-stream* nil 'EOF)))))))

(defun @read-input ()
  "set *input* to the sexpr from stdin"
  (let ((sexpr (read *standard-input* nil 'EOF)))
    (when (or 
           (not (listp sexpr))
           (eq 'EOF sexpr))
      (format *error-output* "stdin doesn't contain an intermediate file~%")
      (die))
    (setf *input* sexpr)))

(defun @replace-mapped-strings (in)
  "return the sexpr in 'in' with expanded strings (struidGxxx -> original string)"
  (mapcar #'(lambda (item)
	      (cond ((listp item)
		     (cons (@replace-mapped-strings (first item))
			   (@replace-mapped-strings (rest item))))
		    ((and
		      (stringp item)
		      (> (length item) 7)
		      (string= "struidG" (subseq item 0 7)))
		     (let ((uid (intern item)))
		       (multiple-value-bind (original-string success)
			   (gethash uid *string-map*)
			 (if success
			     original-string
			     item))))
		    (t item)))
	  in))

(defun @rewrite-input-replacing-mapped-strings ()
  (setf *output* (@replace-mapped-strings *input*))
  (unless (and *output* (listp *output*))
    (format *error-output* "something went wrong during replacement~%")
    (die)))

(defun @write-output ()
  (write *output* :stream *standard-output*))

(defun run ()
  "strings were replaced by simple uids (prolog doesn't define strings of arbitrary characters, but it does define simple ids) ; the map (id -> original) was written to temp-string-map.lisp ; now, we read in the map from temp-string-map.lisp, read a sexpr from stdin and replace the ids found in sexpr by the original strings, then write the modified sexpr to stdout ; everything from this point on must be handled by lisp (or any other language that is not prolog)"
  (@read-map)
  (@read-input)
  (@rewrite-input-replacing-mapped-strings)
  (@write-output))

#+lispworks
(defun main ()
  (with-open-file (fin "temp-string-map.lisp" :direction :input)
    (setf *standard-input* fin)
    (run)))

#+sbcl 
(defun main (argv)
  (declare (ignore argv))
  (run))

