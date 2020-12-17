(defclass hello (node) ()  )

(defmethod initially ((self hello))
  )

(defmethod react ((self hello) (input-e event))
  (declare (ignore input-e))
  (let ((e (make-instance 'event))
        (pp (make-instance 'part-pin)))
    (setf (part-name pp) (name-in-container self))
    (setf (pin-name pp) "s")
    (setf (partpin e) pp)
    (setf (data    e) "Hello")
    (send self e)))
