(in-package :arrowgrams/build)

(defclass probe3 (builder)
  ((index :accessor index :initform 3)))

(defmethod e/part:first-time ((self probe3))
)

(defmethod e/part:react ((self probe3) e)
  (format *standard-output* "~&probe 3 ~s ~s~%" (@pin self e) (@data self e))
  (ecase (@pin self e)
    (:in (@send self :out (@data self e)))))
