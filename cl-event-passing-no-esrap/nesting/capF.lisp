(in-package :cl-event-passing-user)

(defclass capF (e/part:code) () )

(defmethod e/part:busy-p ((self capF))
  (call-next-method))

(defmethod e/part:clone ((self capF))
  (call-next-method))

(defmethod e/part:first-time ((self capF))
)

(defmethod e/part:react ((self capF) (e e/event:event))
  (format *standard-output* "F")
  (cl-event-passing-user:@send self :out "F" :tag "F"))
