(in-package :arrowgrams/build)

(defclass get-manifest-file (builder)
  ((counter :accessor counter)))

(defmethod e/part:first-time ((self get-manifest-file))
)

(defmethod e/part:react ((self get-manifest-file) e)
  (ecase (@pin self e)
    (:in
     ;; input is a json string which is a 5-part ref to a manifest file
     (let ((manifest-as-alist (json-to-alist (@data self e))))
       (let ((filename (make-manifest-filename manifest-as-alist)))
	 (if (probe-file filename)
	     (let ((manifest-as-json-string (alexandria:read-file-into-string filename)))
	       (@send self :out manifest-as-json-string))
	     (let ((msg (format nil "manifest file ~s not found" filename)))
	       (format *error-output* "arrowgrams error: ~a~%" msg)
	       (@send self :error msg)
	       (error msg)))))))) ;; lisp error only during bootstrap

(defun read-manifest-file (filename)
  (alexandria:read-file-into-string filename))

#+nil(defun make-manifest-filename (alist)
#|  {    "dir": "build_process/", "file": "lispparts/iterator.json","kindName": "iterator", "ref": "master", "repo": "https://github.com/bmfbp/bmfbp.git" } |#
  (let ((afname (cdr (assoc :file alist))))
    (let ((name1 (format nil "~a.manifest.json" (pathname-name afname))))
      (let ((name2 (merge-pathnames name1 arrowgrams/build::*manifest-dir*)))
       (namestring name2)))))

;; new version depends on path.lisp/(manifest-path ...)
(defun make-manifest-filename (alist)
#|  {    "dir": "build_process/", "file": "lispparts/iterator.json","kindName": "iterator", "ref": "master", "repo": "https://github.com/bmfbp/bmfbp.git" } |#
  (let ((afname (cdr (assoc :file alist))))
    (arrowgrams/build::manifest-path (pathname-name afname))))
