(in-package :arrowgrams/build)

(defclass part-namer (builder)
  ((counter :accessor counter)))

(defmethod e/part:first-time ((self part-namer))
  (setf (counter self) 0))

(defmethod e/part:react ((self part-namer) e)
(incf (counter self))
  (ecase (@pin self e)
    (:in
     (let ((part-name (pathname-name (@data self e))))
       (@send self :out part-name)))))