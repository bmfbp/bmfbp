(in-package :cl-event-passing-user)

(defclass lowD (e/part:code) () )

(defmethod e/part:busy-p ((self lowD))
  (call-next-method))

(defmethod e/part:clone ((self lowD))
  (call-next-method))

(defmethod e/part:first-time ((self lowD))
)

(defmethod e/part:react ((self lowD) (e e/event:event))
  (format *standard-output* "d")
  (cl-event-passing-user:@send self :out "d" :tag "d"))
