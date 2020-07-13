(in-package :cl-event-passing-user)

(defclass unity (e/part:code) () )

(defmethod e/part:busy-p ((self unity))
  (call-next-method))

(defmethod e/part:clone ((self unity))
  (call-next-method))

(defmethod e/part:first-time ((self unity))
)

(defmethod e/part:react ((self unity) (e e/event:event))
  (cl-event-passing-user:@send self :out (@data self e) :tag "unity"))
