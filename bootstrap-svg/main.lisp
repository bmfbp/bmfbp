(defun main (argv)
  (declare (ignore argv))
  (let ((list (read *standard-input*)))
    (assert (listp list))
    (let ((fixed 
           (fix-translates
            (collapse-lines
             (fix-arrows
              (fix-lines
               (create-text-objects list)))))))
      (to-prolog fixed *standard-output*))))

