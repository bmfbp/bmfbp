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
     (let ((filename (@data self e)))
       (let ((component-name (pathname-name filename)))
         (let ((str (concatenate 'string
                                 (format nil "(COMPONENT ~a)~%" (string-upcase component-name))
                                 (cl-user::front-end-main filename))))          
           (with-input-from-string  (strm str)
             (@send self :output-string-stream strm))))))))
