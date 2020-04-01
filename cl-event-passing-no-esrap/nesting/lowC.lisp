(in-package :cl-event-passing-user)

(defclass lowC (e/part:code) () )

(defmethod e/part:busy-p ((self lowC))
  (call-next-method))

(defmethod e/part:clone ((self lowC))
  (call-next-method))

(defmethod e/part:first-time ((self lowC))
)

(defmethod e/part:react ((self lowC) (e e/event:event))
  (format *standard-output* "c")
  (cl-event-passing-user:@send self :out "c"))
