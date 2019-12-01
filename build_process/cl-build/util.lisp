(in-package :arrowgrams/build/cl-build)

(defun strip-quotes (s)
  (let ((s (esrap:text s)))
    (if (and
         (char= (char s 0) #\")
         (char= (char s (1- (length s))) #\"))
        (subseq s 1 (1- (length s)))
      s)))
         