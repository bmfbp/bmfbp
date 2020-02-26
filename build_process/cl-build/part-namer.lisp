(in-package :arrowgrams/build)

(defclass part-namer (builder)
  ((counter :accessor counter)))

(defmethod e/part:first-time ((self part-namer))
  (setf (counter self) 0))

(defmethod e/part:react ((self part-namer) e)
(incf (counter self))
(format *standard-output* "~&~a part namer gets ~a ~s~%" (counter self) (@pin self e) (@data self e))
  (ecase (@pin self e)
    (:in
     (let ((part-name (pathname-name (@data self e))))
       (@send self :out part-name)))))