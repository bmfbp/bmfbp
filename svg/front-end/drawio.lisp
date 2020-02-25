(in-package :arrowgrams/compiler)

(defclass front-end (compiler-part)
  ((state :accessor state :initform :idle)))

(defmethod compiler-part-name ((self front-end))
  "FRONT-END")

(defmethod compiler-part-initially ((self front-end))
  (set (state self) :idle))

(defmethod compiler-part-run ((self front-end) e)
(format *standard-output* "~&drawio ~s ~S~%" (@pin self e) (@data self e))
  (ecase (state self)
    (:idle
     (let ((filename (cl-event-passing-user:@data self e)))
       (let ((s (cl-user::front-end-main filename)))
         (let ((strm (cl:make-string-input-stream s)))
           (with-open-file (f "/Users/tarvydas/test.pro" :direction :output :if-exists :supersede)
             (write s :stream f))
           (cl-event-passing-user:@send self :output-string-stream strm)))))))
