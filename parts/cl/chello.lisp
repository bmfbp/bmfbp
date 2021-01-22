(defclass chello (node) ()  )

(defmethod initially ((self chello))
  )

(defmethod react ((self chello) (input-e event))
  (declare (ignore input-e))
  (let ((e (make-instance 'event))
        (pp (make-instance 'part-pin)))
    (setf (part-name pp) (name-in-container self))
    (setf (pin-name pp) "s")
    (setf (partpin e) pp)
    (setf (data    e) " (c) Mello")
    (send self e)))
