(in-package :arrowgrams/compiler)

(defclass front-end (compiler-part) ())

(defmethod e/part:first-time ((self front-end))
  (call-next-method))

(defmethod e/part:react ((self front-end) e)
  (ecase (state self)
    (:idle
     (let ((filename (cl-event-passing-user:@data self e)))
       (let ((s (cl-user::front-end-main filename)))
         (let ((strm (cl:make-string-input-stream s)))
           (cl-event-passing-user:@send self :output-string-stream strm)))))))
