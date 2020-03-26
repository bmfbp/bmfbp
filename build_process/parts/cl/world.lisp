(in-package :arrowgrams/build)

(defclass world (node) () )

(defmethod initialize-instance :after ((self world) &key &allow-other-keys)
  (format *standard-output* "~&initialize-instance world~%"))

(defmethod initially ((self world))
  )

(defmethod react ((self world) (input-e event))
  (declare (ignore input-e))
(format *standard-output* "~&react ~s~%" (name-in-container self))
  (let ((e (make-instance 'event)))
    (setf (part-name e) (name self))
    (setf (pin-name  e) "s")
    (setf (data      e) "world")
    (send self e)))
