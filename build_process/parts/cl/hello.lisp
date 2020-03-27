(in-package :arrowgrams/build)

(defclass hello (node) ()  )

(defmethod initially ((self hello))
  )

(defmethod react ((self hello) (input-e event))
  (declare (ignore input-e))
(format *standard-output* "~&react ~s~%" (name-in-container self))
  (let ((e (make-instance 'event))
        (pp (make-instance 'part-pin)))
    (setf (part-name pp) (name-in-container self))
    (setf (pin-name pp) "s")
    (setf (partpin e) pp)
    (setf (data    e) "hello")
    (send self e)))
