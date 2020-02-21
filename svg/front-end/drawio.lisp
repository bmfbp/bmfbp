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
     ;(let ((str (arrowgrams/compiler/front-end::front-end-main (@data self e))))
     (let ((str (cl-user::front-end-main (@data self e))))
       (with-input-from-string  (strm str)
         (@send self :output-string-stream strm))))))
