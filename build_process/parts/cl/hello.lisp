(in-package :arrowgrams/build)

(defclass hello (node) ()  )

(defmethod initially ((self hello))
  )

(defmethod react ((self hello) (input-e event))
  (declare (ignore input-e))
(format *standard-output* "~&react ~s~%" (name-in-container self))
  (let ((e (make-instance 'event)))
    (setf (part-name e) (name self))
    (setf (pin-name  e) "s")
    (setf (data      e) "hello")
    (send self e)))
