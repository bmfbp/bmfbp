(defun main (argv)
  (declare (ignore argv))
  (let ((list (read *standard-input*)))
    (assert (listp list))
    (let ((fixed 
           (mapcar #'fix-translates
		   (mapcar #'collapse-lines
			   (mapcar #'fix-arrows
				   (mapcar #'fix-lines
					   (mapcar #'create-text-objects list)))))))
      (to-prolog fixed *standard-output*))))

