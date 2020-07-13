(in-package :arrowgrams/build)

(defclass children-before-graph (builder)
  ((state :accessor state)
   (graph-name :accessor graph-name)
   (graph :accessor graph)))

(defmethod initially ((self children-before-graph))
  (setf (state self) :idle)
  (reset self))

(defmethod reset ((self children-before-graph))
  (setf (graph self) nil)
  (setf (graph-name self) nil))

(defmethod react ((self children-before-graph) e)
  (ecase (state self)
    (:idle
     (ecase (pin-name (part-pin e))
       (:child
        ;(format *standard-output* "~&child-before-graph sends ~s~%" (@data self e))
	(@send self :descriptor (data e)))
       (:graph-name
	(save-graph-name self e)
	(setf (state self) (send-if-have-both self)))
       (:graph
	(save-graph self e)
	(setf (state self) (send-if-have-both self)))))
    (:waiting-for-graph-name
     (ecase (pin-name (part-pin e))
       (:graph-name
	(save-graph-name self e)
	(setf (state self) (send-if-have-both self)))))
    (:waiting-for-graph
     (ecase (pin-name (part-pin e))
       (:graph
	(save-graph self e)
	(setf (state self) (send-if-have-both self)))))))

(defmethod send-if-have-both ((self children-before-graph))
  (if (and (graph-name self) (graph self))
    (progn
      (send-event self :name (graph-name self))
      (send-event self :graph (graph self))
      (reset self)
      :idle)
    (if (graph-name self)
	:waiting-for-graph
       :waiting-for-graph-name)))

(defmethod save-graph ((self children-before-graph) (e event))
  (setf (graph self) (data e)))

(defmethod save-graph-name ((self children-before-graph) (e event))
  (setf (graph-name self) (data e)))
