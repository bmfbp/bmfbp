(in-package :arrowgrams/build)

(defclass probe2 (builder)
  ((index :accessor index :initform 2)))

(defmethod e/part:first-time ((self probe2))
)

(defmethod e/part:react ((self probe2) e)
  (format *standard-output* "~&probe 2 ~s ~s~%" (@pin self e) (@data self e))
  (ecase (@pin self e)
    (:in (@send self :out (@data self e) :tag "build probe 2"))))
