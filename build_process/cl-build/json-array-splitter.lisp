(in-package :arrowgrams/build)

(defclass json-array-splitter (builder)
  ((state :accessor state)
   (graph :accessor graph)))

(defmethod e/part:first-time ((self json-array-splitter))
  (setf (state self) :idle)
  (setf (graph self) nil))

(defmethod e/part:react ((self json-array-splitter) e)
  (flet ((split-array ()
           (let ((string-json-array (arrowgrams/compiler::strip-quotes (@data self e))))
             (with-input-from-string (json-array string-json-array)
               (let ((array (json:decode-json json-array)))
                 (@:loop
                   (@:exit-when (null array))
                   (let ((jstr (json:encode-json-alist-to-string (first array))))
                     (@send self :out jstr)
                     (pop array))))))))

    ;; ensure that array is split and sent out before graph

    (ecase (state self)
      (:idle
       (ecase (@pin self e)
         (:array
          (split-array)
          (setf (state self) :wait-for-graph))
         
         (:json
          (setf (graph self) (@data self e))
          (setf (state self) :wait-for-array))))

       (:wait-for-graph
        (ecase (@pin self e)
          (:json
           (@send self :graph (@data self e))
           (setf (state self) :idle))))

       (:wait-for-array
        (ecase (@pin self e)
          (:array
           (split-array)
           (@send self :graph (graph self))
           (setf (state self) :idle))))

          )))