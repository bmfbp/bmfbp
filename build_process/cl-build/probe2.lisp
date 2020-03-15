(in-package :arrowgrams/build)

(defclass probe2 (builder)
  ((index :accessor index :initform 2)))

(defmethod e/part:first-time ((self probe2))
)

(defmethod e/part:react ((self probe2) e)
  (format *standard-output* "~&probe ~a gets ~s ~s~%" (index self) (@pin self e) (@data self e))
  (ecase (@pin self e)
    (:in
     (let ((part-name (pathname-name (@data self e))))
       (@send self :out part-name)))))