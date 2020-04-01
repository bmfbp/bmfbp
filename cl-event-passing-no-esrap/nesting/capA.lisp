(in-package :cl-event-passing-user)

(defclass capA (e/part:code) () )

(defmethod e/part:busy-p ((self capA))
  (call-next-method))

(defmethod e/part:clone ((self capA))
  (call-next-method))

(defmethod e/part:first-time ((self capA))
)

(defmethod e/part:react ((self capA) (e e/event:event))
  (format *standard-output* "A")
  (cl-event-passing-user:@send self :out "A"))
