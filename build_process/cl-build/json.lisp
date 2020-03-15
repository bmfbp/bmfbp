(in-package :arrowgrams/build)

(defun json-to-alist (json-string)
  (with-input-from-string (s json-string)
    (json:decode-json s)))

(defun alist-to-json-string (alist)
  (json:encode-json alist))
