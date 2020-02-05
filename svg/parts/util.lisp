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

(defun @escape-strings-for-sed (s)
  s)

(defun write-string-map (fname sed-fname pure-sed-fname)
  (with-open-file (f fname :direction :output :if-exists :supersede)
    (with-open-file (sed sed-fname :direction :output :if-exists :supersede)
      (with-open-file (u pure-sed-fname :direction :output :if-exists :supersede)
	(maphash
	 #'(lambda (k v)
	     (format f "(~A ~S)~%" k v)
	     (let ((str (@escape-strings-for-sed v)))
	       (format sed "s@ ~A@[~A]@g~%" k str)
	       (format u   "s@~a@\~s@g~%" k str)))
	 *string-map*)
	(format sed "s@] @].@g~%")
	(format sed "s@null null null@N.C.@g~%")
	(format sed "s@ null @.self.@g~%")
	(format sed "s@parent_source_wire_parent_sink@@g~%")))))

(defun die (msg)
  (format *error-output* "~%~S~%" msg)
  #+lispworks (quit)
  #+sbcl (exit)
  )
  
(defmacro exit-loop ()
  `(return nil))
