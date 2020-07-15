(defclass aworld (node) () )

(defmethod initially ((self aworld))
)

(defmethod react ((self aworld) (input-e event))
  (declare (ignore input-e))
  (let ((e (make-instance 'event))
        (pp (make-instance 'part-pin)))
    (setf (part-name pp) (name-in-container self))
    (setf (pin-name  pp) "s")
    (setf (partpin e) pp)
    (setf (data    e) "parts/cl/aWORLD")
    (send self e)))
