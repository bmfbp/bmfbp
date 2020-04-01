(in-package :cl-event-passing-user)

(defclass capE (e/part:code) () )

(defmethod e/part:busy-p ((self capE))
  (call-next-method))

(defmethod e/part:clone ((self capE))
  (call-next-method))

(defmethod e/part:first-time ((self capE))
)

(defmethod e/part:react ((self capE) (e e/event:event))
  (format *standard-output* "E")
  (cl-event-passing-user:@send self :out "E"))

