(in-package :arrowgrams/build)

(defclass builder (e/part:code)
  ())

(defmethod e/part:busy-p ((self builder))
  (call-next-method))

(defmethod e/part:clone ((self builder))
  (call-next-method))

(defmethod e/part:first-time ((self builder))
)

