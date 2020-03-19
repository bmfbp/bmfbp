(in-package :arrowgrams/build)

(defun chop-str (s)
  (if (and (stringp s)
           (> (length s) 6))
      (concatenate 'string (subseq (replace-newline s) 0 50) " ...")
    s))

(defun replace-newline (s)
  (cl-ppcre:regex-replace-all "
" s "."))