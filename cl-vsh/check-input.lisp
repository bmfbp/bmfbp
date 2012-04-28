(load "io")

#+lispworks
(defun main ()
  (with-open-file (f "test.lisp" :direction :input)
    (read-write-facts
     #'unity
     f
     *standard-output*
     :legal-fact #'(lambda (f) (member (rel f) '(type node geometry kind portName edge source sink component))))))

#-lispworks
(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts
   #'unity
   *standard-input*
   *standard-output*
   :legal-fact #'(lambda (f) (member (rel f) '(type node geometry kind portName edge source sink component))))
  0)

#-lispworks
;(main)

