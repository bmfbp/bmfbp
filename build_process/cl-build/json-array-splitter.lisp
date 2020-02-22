(in-package :arrowgrams/build)

(defclass json-array-splitter (e/part:code)
  ())

(defmethod e/part:busy-p ((self json-array-splitter))
  (call-next-method))

(defmethod e/part:clone ((self json-array-splitter))
  (call-next-method))

(defmethod e/part:first-time ((self json-array-splitter))
)

(defmethod e/part:react ((self json-array-splitter) e)
  (ecase (@pin self e)
    (:in
     (let ((string-json-array (arrowgrams/compiler::strip-quotes (@data self e))))
       (with-input-from-string (json-array string-json-array)
         (let ((array (json:decode-json json-array)))
           (@:loop
             (@:exit-when (null array))
             (let ((jstr (json:encode-json-alist-to-string (first array))))
               (@send self :out jstr)
               (pop array)))))))))