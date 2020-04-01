(in-package :cl-event-passing-user)

(defclass capC (e/part:code) () )

(defmethod e/part:busy-p ((self capC))
  (call-next-method))

(defmethod e/part:clone ((self capC))
  (call-next-method))

(defmethod e/part:first-time ((self capC))
)

(defmethod e/part:react ((self capC) (e e/event:event))
  (format *standard-output* "C")
  (cl-event-passing-user:@send self :out "C" :tag "C"))
