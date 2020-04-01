(in-package :cl-event-passing-user)

(defclass lowE (e/part:code) () )

(defmethod e/part:busy-p ((self lowE))
  (call-next-method))

(defmethod e/part:clone ((self lowE))
  (call-next-method))

(defmethod e/part:first-time ((self lowE))
)

(defmethod e/part:react ((self lowE) (e e/event:event))
  (format *standard-output* "e")
  (cl-event-passing-user:@send self :out "e" :tag "e"))
