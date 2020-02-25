(in-package :arrowgrams/build)

(defparameter *src-dir* (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/"))

(defclass schematic-or-leaf (e/part:code)
  ())

(defmethod e/part:busy-p ((self schematic-or-leaf))
  (call-next-method))

(defmethod e/part:clone ((self schematic-or-leaf))
  (call-next-method))

(defmethod e/part:first-time ((self schematic-or-leaf)))

(defmethod e/part:react ((self schematic-or-leaf) e)
  (ecase (@pin self e)
    (:json-ref
     ;; stubbed out for now - all files reside in a working directory
     (with-input-from-string (json-ref (@data self e))
         (let ((file-ref-alist (json:decode-json json-ref)))
           ;(format *standard-output* "~&file ref list ~S~%" file-ref-alist)
           (let ((file-ref (cdr (assoc :file file-ref-alist))))
             (let ((fname (fixup-filename (pathname-name file-ref))))
               (let ((svg-filename (merge-pathnames (format nil "~a.svg" fname) *src-dir* )))
                 (if (probe-file svg-filename)
                     (@send self :schematic-json-ref svg-filename)
                   (let ((lisp-filename (merge-pathnames (format nil "~a.lisp" fname) *src-dir*)))
                     (if (probe-file lisp-filename)
                         (@send self :leaf-json-ref lisp-filename)
                       (@send self :error (format nil "no file /~s/ (.svg or .lisp)" fname))))))))))))) 
    

(defun fixup-filename (s)
  (let ((r1 (cl-ppcre:regex-replace-all " " s "-")))
    r1))
