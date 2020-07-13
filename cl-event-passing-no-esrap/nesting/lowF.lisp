(in-package :cl-event-passing-user)

(defclass lowF (e/part:code) () )

(defmethod e/part:busy-p ((self lowF))
  (call-next-method))

(defmethod e/part:clone ((self lowF))
  (call-next-method))

(defmethod e/part:first-time ((self lowF))
)

(defmethod e/part:react ((self lowF) (e e/event:event))
  (format *standard-output* "f")
  (cl-event-passing-user:@send self :out "f"))
