(defun list-of-lists-p (tail)
  (and (listp tail)
       (listp (first tail))))

(defparameter *string-map* nil)

(defun gen-string-id ()
  (let ((id (format nil "struid~A" (gensym))))
    id))

(defun string-to-map (str)
  "return a unique id for given string, store string in map ; all to get
   around gprolog problems"
  (let ((uid (gen-string-id)))
    (setf (gethash uid *string-map*)
	  str)
    uid))

(defun init-string-map ()
  (setf *string-map* (make-hash-table)))

(defun write-string-map (fname)
  (with-open-file (f fname :direction :output :if-exists :supersede)
    (maphash
     #'(lambda (k v)
	 (format f "(~A ~S)~%" k v))
     *string-map*)))

(defun die (msg)
  (format *error-output* "~%~S~%" msg)
  #+lispworks (quit)
  #+sbcl (exit)
  )
  
(defmacro exit-loop ()
  `(return nil))
