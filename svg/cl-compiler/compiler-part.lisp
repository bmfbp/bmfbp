(in-package :arrowgrams/compiler)

(defclass compiler-part (e/part:code)
  ((state :accessor state)
   (fb :accessor fb)))

(defmethod e/part:busy-p ((self compiler-part)) (call-next-method))
(defmethod e/part:clone ((self compiler-part)) (call-next-method))

(defmethod e/part:first-time ((self compiler-part))
  (setf (fb self) nil)
  (setf (state self) :idle)
  (call-next-method))


