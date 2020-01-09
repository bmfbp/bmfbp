(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl-peg:into-package "ARROWGRAMS/PROLOG-PEG"))

(defparameter *grammars* (list
                          *peg-rules-original*
                          *peg-rules-refactored*
                          *peg-rules-generic*))

(defun init (&optional (index 2))
  (let ((g (cl-peg:fullpeg (nth index *grammars*))))
    (mapc #'(lambda (r) 
              (eval r)) 
          (cdr g))))

