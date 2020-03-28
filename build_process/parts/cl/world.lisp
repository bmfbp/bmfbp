(in-package :arrowgrams/build)

(defclass world (node) () )

(defmethod initially ((self world))
)

(defmethod react ((self world) (input-e event))
  (declare (ignore input-e))
(format *standard-output* "~&react ~s~%" (name-in-container self))
  (let ((e (make-instance 'event))
        (pp (make-instance 'part-pin)))
    (setf (part-name pp) (name-in-container self))
    (setf (pin-name  pp) "s")
    (setf (partpin e) pp)
    (setf (data    e) "world")
    (send self e)))
