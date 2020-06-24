(in-package :arrowgrams/build)

(defclass json-array-splitter (node)
  ((state :accessor state)
   (json-array :accessor json-array)
   (graph :accessor graph)))

(defmethod initially ((self json-array-splitter))
  (setf (state self) :idle)
  (setf (json-array self) nil)
  (setf (graph self) nil))

(defmethod react ((self json-array-splitter) (e event))
    (flet ((split-and-send-array ()
           (let ((string-json-array (arrowgrams/compiler::strip-quotes (json-array self))))
             (with-input-from-string (json-array string-json-array)
               (let ((array (json:decode-json json-array)))
                 (@:loop
                   (@:exit-when (null array))
                   (let ((jstr (alist-to-json-string (first array))))
                     (send self (new-event self :items jstr))
                     (pop array)))))))
         (send-graph ()
           (send-event self :graph (graph self)))
         (save-array () (setf (json-array self) (data e)))
         (save-graph () (setf (graph self) (data e))))
      (flet ((send-all ()
               (split-and-send-array)
               (send-graph)))
             
        
        ;; ensure that graph is sent out before array is split and sent out

	(let ((pp (partpin e)))
	  (assert (eq (name-in-container self) (part-name pp) ))
	  (let ((pin (part-pin pp)))
	    (ecase (state self)
	      (:idle
	       (ecase pin
		 (:array
		  (save-array)
		  (setf (state self) :wait-for-graph))
		 
		 (:json
		  (save-graph)
		  (setf (state self) :wait-for-array))))
	      
	      (:wait-for-graph
	       (ecase pin
		 (:json
		  (save-graph)
		  (send-all)
		  (setf (state self) :idle))))
	      
	      (:wait-for-array
	       (ecase pin
		 (:array
		  (save-array)
		  (send-all)
		  (setf (state self) :idle))))
	      
	      ))))))
