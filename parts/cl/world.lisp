(defclass world (node) () )

(defmethod initially ((self world))
)

(defmethod react ((self world) (input-e event))
  (declare (ignore input-e))
  (let ((e (make-instance 'event))
        (pp (make-instance 'part-pin)))
    (setf (part-name pp) (name-in-container self))
    (setf (pin-name  pp) "s")
    (setf (partpin e) pp)
    (setf (data    e) "World")
    (send self e)))
