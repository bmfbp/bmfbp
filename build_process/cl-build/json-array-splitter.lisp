(in-package :arrowgrams/build)

(defclass json-array-splitter (builder)
  ((state :accessor state)
   (json-array :accessor json-array)
   (graph :accessor graph)))

(defmethod e/part:first-time ((self json-array-splitter))
  (setf (state self) :idle)
  (setf (json-array self) nil)
  (setf (graph self) nil))

(defmethod e/part:react ((self json-array-splitter) e)
    (flet ((split-and-send-array ()
           (let ((string-json-array (arrowgrams/compiler::strip-quotes (json-array self))))
             (with-input-from-string (json-array string-json-array)
               (let ((array (json:decode-json json-array)))
                 (@:loop
                   (@:exit-when (null array))
                   (let ((jstr (json:encode-json-alist-to-string (first array))))
                     (@send self :items jstr)
                     (pop array)))))))
         (send-graph ()
           (@send self :graph (graph self)))
         (save-array () (setf (json-array self) (@data self e)))
         (save-graph () (setf (graph self) (@data self e))))
      (flet ((send-all () (send-graph) (split-and-send-array)))
        
        ;; ensure that graph is sent out before array is split and sent out
        
        (ecase (state self)
          (:idle
           (ecase (@pin self e)
             (:array
              (save-array)
              (setf (state self) :wait-for-graph))
             
             (:json
              (save-graph)
              (setf (state self) :wait-for-array))))
          
          (:wait-for-graph
           (ecase (@pin self e)
             (:json
              (save-graph)
              (send-all)
              (setf (state self) :idle))))
          
          (:wait-for-array
           (ecase (@pin self e)
             (:array
              (save-array)
              (send-all)
              (setf (state self) :idle))))
          
          ))))