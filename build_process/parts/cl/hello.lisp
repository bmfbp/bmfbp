(in-package :arrowgrams/build)

(defclass hello (kind)
  )

(defmethod initially ((self hello))
  )

(defmethod react ((self hello) (e event))
  (send self "s" "hello")
