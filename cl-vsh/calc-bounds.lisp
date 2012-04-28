(load "io")

(defun calc-bound (id info)
  ;; create a new "bounds" fact for every node that has geometry
  (declare (ignorable id))
  (when-match (g 'geometry info)
              (destructuring-bind (rrel rid x y w h) g
		(declare (ignore rrel rid))
                (setf (gethash 'bounds info)
                      (list 'bounds id x y (+ x w) (+ y h))))))

(defun calc-bounds (facts)
  (maphash #'calc-bound facts))

(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts #'calc-bounds *standard-input* *standard-output*)
  0)

#-lispworks
;(main)