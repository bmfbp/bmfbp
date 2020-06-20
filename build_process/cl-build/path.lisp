(in-package :arrowgrams/build)

(defun dir ()
  (asdf:system-relative-pathname :arrowgrams (concatenate 'string "build_process/parts/")))
  
(defun diagram-path (fname)
  (format nil "~adiagram/~a.svg" (dir) fname))

(defun json-graph-path (fname)
  (format nil "~agraph/~a.graph.json" (dir) fname))

(defun alist-graph-path (fname)
  (format nil "~agraph/~a.graph.lisp" (dir) fname))

