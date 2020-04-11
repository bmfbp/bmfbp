(defclass aa () () )

(defmethod react ((self aa))
  (format *standard-output* "~&react aa~%"))

(defmethod initialize-instance ((self aa) &key &allow-other-keys)
  (format *standard-output* "~&initialize instance aa~%"))

(defclass bb (aa) ())

(defmethod react ((self bb))
  (format *standard-output* "~&react bb~%")
  (call-next-method))

(defmethod initialize-instance ((self bb) &key &allow-other-keys)
  (format *standard-output* "~&initialize instance bb~%")
  (call-next-method))

(load (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/package.lisp"))
(load (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/esa.lisp"))
 
(defun ootest()
  (let ((xx (make-instance 'bb)))
    (let ((b (make-instance (type-of xx))))
      (react b)
      (let ((nn (make-instance (find-class 'arrowgrams/build::node))))
        nn))))

