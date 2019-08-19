;; see comment in main()

(defparameter *map-stream* nil)
(defparameter *fixup-stream* nil)
(defparameter *string-map* nil)
(defparameter *sexpr-to-be-fixed* nil)
(defparameter *fixed-up-sexpr* nil)

(defun replacement-uid-p (sym)
  "check if the symbol is of the form stringuidG, retuns T or nil"
  (if (symbolp sym)
      (let ((str (symbol-name sym)))
        (let ((replacement-prefix "STRUIDG"))
          (let ((len (length replacement-prefix)))
            (and
             (stringp str)  ;; redundant
             (>= (length str) len)
             (string= replacement-prefix (subseq str 0 len))))))
    nil))
  
(defun replacement-string-uid-p (str)
  "check if the string is of the form stringuidG, if symbolp then compare against stringguidg, returns T or nil"
  (if (stringp str)
      (let ((replacement-prefix "struidG"))
        (let ((len (length replacement-prefix)))
          (and
           (>= (length str) len)
           (string= replacement-prefix (subseq str 0 len)))))
      (if (symbolp str)
	  (let ((replacement-prefix "struidg")
		(string (string-downcase (symbol-name str))))
            (let ((len (length replacement-prefix)))
              (and
               (>= (length string) len)
               (string= replacement-prefix (subseq string 0 len)))))
	  nil)))
  
(defun @get-uid-for-read-map (sym)
  "helper for @read-map ; return sym, if it is a string-map id of the form 'struidGxxx'"
  (when (symbolp sym)
      (when (replacement-uid-p sym)
	sym)))

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
	   (setf pair (read *map-stream* nil 'EOF)))))))

(defun @read-input ()
  "set *sexpr-to-be-fixed* to the sexpr from stdin"
  (let ((sexpr (read *fixup-stream* nil 'EOF)))
    (when (or 
           (not (listp sexpr))
           (eq 'EOF sexpr))
      (die (format nil "stdin doesn't contain an intermediate file~%")))
    (setf *sexpr-to-be-fixed* sexpr)))

(defun @replace-mapped-strings (to-be-fixed-up)
  "return the sexpr in 'in' with expanded strings (struidGxxx -> original string)"
  (if (null to-be-fixed-up)
      nil
    (if (listp to-be-fixed-up)
        (mapcar #'@replace-mapped-strings to-be-fixed-up)
      (let ((item to-be-fixed-up))
        (cond
         ((replacement-string-uid-p item)
          (assert (or (stringp item) (symbolp item)))
          (let ((uid (if (stringp item)
			 (intern (string-upcase item))
			 item)))
            (multiple-value-bind (original-string success)
                (gethash uid *string-map*)
              (if success
                  original-string
                item))))
         (t item))))))

(defun @rewrite-input-replacing-mapped-strings ()
  (setf *fixed-up-sexpr* (@replace-mapped-strings *sexpr-to-be-fixed*))
  (unless (and *fixed-up-sexpr* (listp *fixed-up-sexpr*))
    (die (format nil "something went wrong during replacement"))))

(defun @write-output ()
  (write *fixed-up-sexpr* :stream *standard-output*))

(defun run ()
  "strings were replaced by simple uids (prolog doesn't define strings of arbitrary characters, but it does define simple ids) ; the map (id -> original) was written to temp-string-map.lisp ; now, we read in the map from temp-string-map.lisp, read a sexpr from stdin and replace the ids found in sexpr by the original strings, then write the modified sexpr to stdout ; everything from this point on must be handled by lisp (or any other language that is not prolog)"
  (@read-map)
  (@read-input)
  (@rewrite-input-replacing-mapped-strings)
  (@write-output))

#+lispworks
(defun main ()
  (with-open-file (fixup "temp21a.lisp" :direction :input)
    (setf *fixup-stream* fixup)
    (with-open-file (map "temp-string-map.lisp" :direction :input)
      (setf *map-stream* map)
      (run))))

#+sbcl 
(defun main (argv)
  (declare (ignore argv))
  (handler-case
      (progn
	(setf *fixup-stream* *standard-input*)
	(with-open-file (map "temp-string-map.lisp" :direction :input)
	  (setf *map-stream* map)
	  (run)))
    (end-of-file (c)
      (format *error-output* "FATAL 'end of file error' in unmap-strings /~S/~%" c)
      (values))      
    (simple-error (c)
      (format *error-output* "FATAL error b in unmap-strings /~S/~%" c))
    (error (c)
      (format *error-output* "FATAL error c in unmap-strings /~S/~%" c))))
  
