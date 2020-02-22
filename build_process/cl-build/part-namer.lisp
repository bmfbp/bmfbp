(in-package :arrowgrams/build)

(defclass part-namer (e/part:code)
  ())

(defmethod e/part:busy-p ((self part-namer))
  (call-next-method))

(defmethod e/part:clone ((self part-namer))
  (call-next-method))

(defmethod e/part:first-time ((self part-namer))
)

(defmethod e/part:react ((self part-namer) e)
  (ecase (@pin self e)
    (:in
     (let ((part-name (pathname-name (@data self e))))
       (@send self :out part-name)))))