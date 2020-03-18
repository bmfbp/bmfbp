(in-package :arrowgrams/build)

(defclass part-namer (builder)
  ((counter :accessor counter)))

(defmethod e/part:first-time ((self part-namer))
)

(defmethod e/part:react ((self part-namer) e)
  (ecase (@pin self e)
    (:in
     (let ((part-name (pathname-name (@data self e))))
       (@send self :out part-name :tag "part-namer")))))
