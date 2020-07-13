(in-package :arrowgrams/build)

(defclass paths ()
  ((root :accessor root :initform (cl:namestring (asdf:system-relative-pathname :arrowgrams "")))))

(defun fixup-root-reference (str)
  (let ((p (make-instance 'paths)))
    (cl-ppcre:regex-replace-all "\\$" str (root p))))
