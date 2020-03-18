(in-package :arrowgrams/build)

(defun chop-str (s)
  (if (and (stringp s)
           (> (length s) 6))
      (concatenate 'string (subseq s 0 50) " ...")
    s))