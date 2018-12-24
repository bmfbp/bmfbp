(defun list-of-lists-p (tail)
  (and (listp tail)
       (listp (first tail))))

