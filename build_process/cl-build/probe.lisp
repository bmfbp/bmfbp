(in-package :arrowgrams/build)

(defclass probe (builder)
  ())

(defmethod e/part:first-time ((self probe))
)

(defmethod e/part:react ((self probe) e)
  (format *standard-output* "~&probe gets ~s ~s~%" (@pin self e) (@data self e))
  (ecase (@pin self e)
    (:in
     (let ((part-name (pathname-name (@data self e))))
       (@send self :out part-name)))))