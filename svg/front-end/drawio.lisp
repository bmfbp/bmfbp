(in-package :arrowgrams/compiler)

(defclass front-end (compiler-part)
  ((state :accessor state :initform :idle)))

(defmethod compiler-part-name ((self front-end))
  "FRONT-END")

(defmethod compiler-part-initially ((self front-end))
  (set (state self) :idle))

(defmethod compiler-part-run ((self front-end) e)
  (ecase (state self)
    (:idle
       (let ((str (front-end-main (@data self e))))
       (@send self :out str)))))
