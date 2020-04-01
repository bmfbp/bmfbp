(in-package :cl-event-passing-user)

(defclass strcat4 (e/part:code) 
  ((state :accessor state)
   (x :accessor x)
   (y :accessor y)))

(defmethod e/part:busy-p ((self strcat4))
  (call-next-method))

(defmethod e/part:clone ((self strcat4))
  (call-next-method))

(defmethod e/part:first-time ((self strcat4))
  (setf (state self) :idle)
  (setf (x self) "")
  (setf (y self) ""))

(defmethod e/part:react ((self strcat4) (e e/event:event))
  (ecase (state self)
    (:idle
     (ecase (cl-event-passing-user:@pin self e)
       (:x
        (setf (x self) (cl-event-passing-user:@data self e))
        (setf (state self) :wait-for-y))
       (:y
        (setf (y self) (cl-event-passing-user:@data self e))
        (setf (state self) :wait-for-x))))
    
    (:wait-for-x
     (setf (x self) (cl-event-passing-user:@data self e))
     (send-result self))
    
    (:wait-for-y
     (setf (y self) (cl-event-passing-user:@data self e))
     (send-result self))))

(defmethod send-result ((self strcat4))
  (let ((result (concatenate 'string (x self) (y self))))
    (cl-event-passing-user:@send self :out result)
    (setf (state self) :idle)))
