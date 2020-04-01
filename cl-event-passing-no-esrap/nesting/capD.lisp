(in-package :cl-event-passing-user)

(defclass capD (e/part:code) () )

(defmethod e/part:busy-p ((self capD))
  (call-next-method))

(defmethod e/part:clone ((self capD))
  (call-next-method))

(defmethod e/part:first-time ((self capD))
)

(defmethod e/part:react ((self capD) (e e/event:event))
  (format *standard-output* "D")
  (cl-event-passing-user:@send self :out "D"))
