(in-package :arrowgrams/build)

(defun chop-str (s)
  (if (and (stringp s)
           (> (length s) 6))
      (concatenate 'string (subseq (replace-newline s) 0 50) " ...")
    s))

(defun replace-newline (s)
  (cl-ppcre:regex-replace-all "
" s "."))

#|
(defparameter *manifest-dir* (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/")) ;; for bootstrap
(defparameter  *diagram-dir* (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/")) ;; for bootstrap
(defparameter      *src-dir* (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/" )) ;; for bootstrap
|#
(defparameter *manifest-dir* (asdf:system-relative-pathname :arrowgrams "build_process/parts/"))
(defparameter  *diagram-dir* (asdf:system-relative-pathname :arrowgrams "build_process/parts/diagram/"))
(defparameter      *src-dir* (asdf:system-relative-pathname :arrowgrams "build_process/parts/cl/)"))
