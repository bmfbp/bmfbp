(in-package :arrowgrams/build)

(defclass string-join (kind)
  ((state :accessor state)
   (string-a :accessor string-a)
   (string-b :accessor string-b)))

(defmethod initially ((self string-join))
  (setf (state self) :idle))

(defmethod react ((self string-join) (e event))
(break)
  (flet ((send-both ()
	   (let ((out-e (make-instance 'event)))
	     (setf (part-name out-e) (name self))
	     (setf (pin-name out-e) "c")
	     (setf (data out-e) (concatenate 'string (string-a self) (string-b self)))
	     (send self out-e))))
    
    (ecase (state self)
      (:idle
       (cond ((and (string= (pin-name e) "a") (stringp (data e)))
	      (setf (string-a self) (data e))
	      (setf (state self) :waiting-for-b))
	     ((and (string= (pin-name e) "b") (stringp (data e)))
	      (setf (string-b self) (data e))
	      (setf (state self) :waiting-for-a))
	     (t (error (format nil "hello in state :idle expected a string on pin a or on pin b, but got pin ~s with data ~s" (pin-name e) (data e))))))

      (:waiting-for-b
       (cond ((and (string= (pin-name e) "b") (stringp (data e)))
	      (setf (string-b self) (data e))
	      (send-both)
	      (setf (state self) :idle))
	     (t (error (format nil "hello in state :waiting-for-b expected a string on pin b, but got pin ~s with data ~s" (pin-name e) (data e))))))

      (:waiting-for-a
       (cond ((and (string= (pin-name e) "a") (stringp (data e)))
	      (setf (string-b self) (data e))
	      (send-both)
	      (setf (state self) :idle))
	     (t (error (format nil "hello in state :waiting-for-a expected a string on pin a, but got pin ~s with data ~s" (pin-name e) (data e)))))))))

     
