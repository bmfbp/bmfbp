(in-package :arrowgrams/build)

(defclass world (kind) () )

(defmethod initially ((self world))
  )

(defmethod react ((self world) (input-e event))
  (declare (ignore input-e))
  (let ((e (make-instance 'event)))
    (setf (part-name e) (name self))
    (setf (pin-name  e) "s")
    (setf (data      e) "hello")
    (send self e)))
