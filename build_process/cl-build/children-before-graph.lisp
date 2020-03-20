(in-package :arrowgrams/build)

(defclass children-before-graph (builder)
  ((state :accessor state)
   (graph-name :accessor graph-name)
   (graph :accessor graph)))

(defmethod e/part:first-time ((self children-before-graph))
  (setf (state self) :idle)
  (reset self))

(defmethod reset ((self children-before-graph))
  (setf (graph self) nil)
  (setf (graph-name self) nil))

(defmethod e/part:react ((self children-before-graph) e)
  (ecase (state self)
    (:idle
     (ecase (@pin self e)
       (:child
        (format *standard-output* "~&child-before-graph sends ~s~%" (@data self e))
	(@send self :descriptor (@data self e)))
       (:graph-name
	(save-graph-name self e)
	(setf (state self) (send-if-have-both self)))
       (:graph
	(save-graph self e)
	(setf (state self) (send-if-have-both self)))))
    (:waiting-for-graph-name
     (ecase (@pin self e)
       (:graph-name
	(save-graph-name self e)
	(setf (state self) (send-if-have-both self)))))
    (:waiting-for-graph
     (ecase (@pin self e)
       (:graph
	(save-graph self e)
	(setf (state self) (send-if-have-both self)))))))

(defmethod send-if-have-both ((self children-before-graph))
  (if (and (graph-name self) (graph self))
    (progn
      (@send self :name (graph-name self))
      (@send self :graph (graph self))
      (reset self)
      :idle)
    (if (graph-name self)
	:waiting-for-graph
       :waiting-for-graph-name)))

(defmethod save-graph ((self children-before-graph) e)
  (setf (graph self) (@data self e)))

(defmethod save-graph-name ((self children-before-graph) e)
  (setf (graph-name self) (@data self e)))
