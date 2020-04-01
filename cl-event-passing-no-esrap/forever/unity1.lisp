(in-package :cl-event-passing-user)

(defclass unity1 (e/part:code) () )

(defmethod e/part:busy-p ((self unity1))
  (call-next-method))

(defmethod e/part:clone ((self unity1))
  (call-next-method))

(defmethod e/part:first-time ((self unity1))
)

(defmethod e/part:react ((self unity1) (e e/event:event))
  (cl-event-passing-user:@send self :out (@data self e) :tag "unity1"))
