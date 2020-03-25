(in-package :arrowgrams/build)

(defclass hello (kind) ()  )

(defmethod initially ((self hello))
  )

(defmethod react ((self hello) (input-e event))
  (declare (ignore input-e))
  (let ((e (make-instance 'event)))
    (setf (part-name e) (name self))
    (setf (pin-name  e) "s")
    (setf (data      e) "hello")
    (send self e)))
