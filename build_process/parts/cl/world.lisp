(in-package :arrowgrams/build)

(defclass world (kind)
  )

(defmethod initially ((self world))
  )

(defmethod react ((self world) (e event))
  (send self "s" "world")
