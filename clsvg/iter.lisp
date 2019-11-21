;;INPUTS
;; (:begin T)            begin iterating, once for each :next input
;; (:next  T)            send t to :next
;; (:end   T)            end iteration (send nothing)

;; 
;;OUTPUTS
;; (:next t)             request next iteration
;; (:fatal details)      fatal error (NIY)
;;

(in-package :cl-event-passing-user)

(defparameter *stream* nil)
(defparameter *iter-state* 'idle)

(defmethod iter-reset ((self e/part:part))
  (declare (ignore part))
  (setf *iter-state* 'idle))

(defmethod iter ((self e/part:part) (e e/event:event))
  (let ((data (e/event:data e))
        (action (e/event::sym e)))

    (e/util::logging (format nil "iter action=~S data=~S" action data))

    (case *iter-state*

      (idle
           (case action

             (:begin
              (@send self :next t)
              (setf *iter-state* 'running))

             (otherwise  (@send self :fatal t))))

      (running
           (case action
             (:next (@send self :next t))

             (:finish (setf state 'idle))
             
             (otherwise (@send self :fatal t))))
      
       (otherwise (@send self :fatal t)))))

