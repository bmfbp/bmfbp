(in-package :arrowgrams/compiler)

(defclass probe (e/part:code)
  ((index :accessor index :initform 0)))

(defmethod e/part:first-time ((self probe))
)

(defmethod e/part:react ((self probe) e)
  (format *standard-output* "~&probe ~a gets ~s ~s~%" (index self) (@pin self e) (@data self e))
  (ecase (@pin self e)
    (:in (@send self :out (@data self e)))))
