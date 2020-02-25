(in-package :arrowgrams/compiler)

(defclass front-end (compiler-part) ())

(defmethod e/part:first-time ((self front-end))
  (call-next-method))

(defmethod e/part:react ((self front-end) e)
(format *standard-output* "~&drawio ~s ~S~%" (@pin self e) (@data self e))
  (ecase (state self)
    (:idle
     (let ((filename (cl-event-passing-user:@data self e)))
       (let ((s (cl-user::front-end-main filename)))
         (let ((strm (cl:make-string-input-stream s)))
           (with-open-file (f "/Users/tarvydas/test.pro" :direction :output :if-exists :supersede)
             (write s :stream f))
           (cl-event-passing-user:@send self :output-string-stream strm)))))))
