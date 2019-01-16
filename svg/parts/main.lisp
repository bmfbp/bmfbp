(defun run (strm)
  ;; temp fix for front-end - returns 2 lists instead of 1
  (let* ((list1 (read strm nil '(nothing)))
	 (list2 (read strm nil nil))
	 (list3 `(component ,(string-downcase (symbol-name (second list1)))))
	 (list (cons list3 list2))) 
    (assert (and list3 list2) () "run expected two lists /~A/ /~A/" list3 list2)
    (assert (listp list) () "run not a list (check args vs. redirection to first pass) list=/~a/ list3=/~A/ list2=/~A/" list list3 list2)
    (let ((fixed 
           (mapcar #'fix-translates
		   (mapcar #'collapse-lines
			   (mapcar #'fix-arrows
				   (mapcar #'fix-lines
					   (mapcar #'create-text-objects list)))))))
      (to-prolog fixed *standard-output*))))

#-lispworks
(defun main (argv)
  (declare (ignore argv))
  (run *standard-input*))

#+lispworks
(defun main (fname)
  (with-open-file (f fname :direction :input)
    (run f)))
