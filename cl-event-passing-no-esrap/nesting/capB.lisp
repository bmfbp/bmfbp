(in-package :cl-event-passing-user)

(defclass capB (e/part:code) () )

(defmethod e/part:busy-p ((self capB))
  (call-next-method))

(defmethod e/part:clone ((self capB))
  (call-next-method))

(defmethod e/part:first-time ((self capB))
)

(defmethod e/part:react ((self capB) (e e/event:event))
  (format *standard-output* "B")
  (cl-event-passing-user:@send self :out "B"))
