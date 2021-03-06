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
(defparameter *final-manifest-dir* (asdf:system-relative-pathname :arrowgrams "build_process/parts/"))
(defparameter  *final-diagram-dir* (asdf:system-relative-pathname :arrowgrams "build_process/parts/diagram/"))
(defparameter      *final-src-dir* (asdf:system-relative-pathname :arrowgrams "build_process/parts/cl/"))
(defparameter *bootstrap-manifest-dir* (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/"))
(defparameter  *bootstrap-diagram-dir* (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/"))
(defparameter      *bootstrap-src-dir* (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/"))

(defparameter *manifest-dir* *final-manifest-dir*)
(defparameter  *diagram-dir* *final-diagram-dir*)
(defparameter      *src-dir* *final-src-dir*)

