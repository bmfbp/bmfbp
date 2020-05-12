(in-package :arrowgrams/build)

(defclass get-manifest-file (node)
  ((counter :accessor counter)))

(defmethod initially ((self get-manifest-file))
)

(defmethod react ((self get-manifest-file) e)
  (ecase (pin-name e)
    (:in
     ;; input is a json string which is a 5-part ref to a manifest file
     (let ((manifest-as-alist (json-to-alist (data e))))
       (let ((filename (make-manifest-filename manifest-as-alist)))
	 (if (probe-file filename)
	     (let ((manifest-as-json-string (alexandria:read-file-into-string filename)))
	       (send-event self :out manifest-as-json-string))
	     (let ((msg (format nil "manifest file ~s not found" filename)))
	       (send-event self :error msg)
	       (error msg)))))))) ;; lisp error only during bootstrap

(defun read-manifest-file (filename)
  (alexandria:read-file-into-string filename))

(defun make-manifest-filename (alist)
#|  {    "dir": "build_process/", "file": "lispparts/iterator.json","kindName": "iterator", "ref": "master", "repo": "https://github.com/bmfbp/bmfbp.git" } |#
  (let ((afname (cdr (assoc :file alist))))
    (let ((name1 (format nil "~a.manifest.json" (pathname-name afname))))
      (let ((name2 (merge-pathnames name1 arrowgrams/build::*manifest-dir*)))
       (namestring name2)))))
