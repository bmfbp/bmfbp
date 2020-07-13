(in-package :cl-event-passing-user)

(defclass unity2 (e/part:code) () )

(defmethod e/part:busy-p ((self unity2))
  (call-next-method))

(defmethod e/part:clone ((self unity2))
  (call-next-method))

(defmethod e/part:first-time ((self unity2))
)

(defmethod e/part:react ((self unity2) (e e/event:event))
  (cl-event-passing-user:@send self :out (@data self e) :tag "unity2"))
