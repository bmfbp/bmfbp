(in-package :arrowgrams/build)

(defclass probe (builder)
  ((index :accessor index :initform 1)))

(defmethod e/part:first-time ((self probe))
)

(defmethod e/part:react ((self probe) e)
  (format *standard-output* "~&probe 1 ~s ~s~%" (@pin self e) (@data self e))
  (ecase (@pin self e)
    (:in (@send self :out (@data self e)))))
