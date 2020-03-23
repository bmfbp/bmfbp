(in-package :arrowgrams/build)

(defclass string-join (kind)
  (state :accessor state)
  (string-a :accessor string-a)
  (string-b :accessor string-b))

(defmethod initially ((self string-join))
  (setf (state self) :idle))

(defmethod react ((self string-join) (e event))
  (ecase (state self)
    (:idle
     (cond ((and (string= (pin e) "a") (stringp (data e)))
	    (setf (string-a self) (data event))
	    (setf (state self) :waiting-for-b))
	   ((and (string= (pin e) "b") (stringp (data e)))
	    (setf (string-b self) (data event))
	    (setf (state self) :waiting-for-a))
	   (t (error (format nil "hello in state :idle expected a string on pin a or on pin b, but got pin ~s with data ~s" (pin e) (data e))))))

    (:waiting-for-b
     (cond ((and (string= (pin e) "b") (stringp (data e)))
	    (setf (string-b self) (data event))
	    (send self "c" (concatenate 'string (string-a self) (string-b self)))
	    (setf (state self) :idle))
	   (t (error (format nil "hello in state :waiting-for-b expected a string on pin b, but got pin ~s with data ~s" (pin e) (data e))))))

    (:waiting-for-a
     (cond ((and (string= (pin e) "a") (stringp (data e)))
	    (setf (string-b self) (data event))
	    (send self "c" (concatenate 'string (string-a self) (string-b self)))
	    (setf (state self) :idle))
	   (t (error (format nil "hello in state :waiting-for-a expected a string on pin a, but got pin ~s with data ~s" (pin e) (data e))))))))

     
