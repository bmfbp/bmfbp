(in-package :arrowgrams/esa-transpiler)

(defun path (str)
  (asdf:system-relative-pathname :arrowgrams (format nil "build_process/esa-transpiler/~a" str)))