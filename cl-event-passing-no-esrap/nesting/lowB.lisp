(in-package :cl-event-passing-user)

(defclass lowB (e/part:code) () )

(defmethod e/part:busy-p ((self lowB))
  (call-next-method))

(defmethod e/part:clone ((self lowB))
  (call-next-method))

(defmethod e/part:first-time ((self lowB))
)

(defmethod e/part:react ((self lowB) (e e/event:event))
  (format *standard-output* "b")
  (cl-event-passing-user:@send self :out "b" :tag "b" :detail :data))
