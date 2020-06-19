(in-package :arrowgrams/build)

(defun diagram-path (fname)
  (asdf:system-relative-pathname :arrowgrams (concatenate 'string "build_process/parts/diagram/" fname)))

