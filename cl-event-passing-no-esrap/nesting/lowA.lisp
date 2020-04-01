(in-package :cl-event-passing-user)

(defclass lowA (e/part:code) () )

(defmethod e/part:busy-p ((self lowA))
  (call-next-method))

(defmethod e/part:clone ((self lowA))
  (call-next-method))

(defmethod e/part:first-time ((self lowA))
)

(defmethod e/part:react ((self lowA) (e e/event:event))
  (format *standard-output* "a")
  (cl-event-passing-user:@send self :out "a" :tag "a" :detail :data))
