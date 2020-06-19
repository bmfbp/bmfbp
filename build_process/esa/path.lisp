(in-package :arrowgrams/esa)

(defun path (str)
  (asdf:system-relative-pathname :arrowgrams (format nil "build_process/esa/~a" str)))
