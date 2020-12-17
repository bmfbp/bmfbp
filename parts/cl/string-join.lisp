(defclass string-join (node)
  ((state :accessor state)
   (string-a :accessor string-a)
   (string-b :accessor string-b)))

(defmethod initially ((self string-join))
  (setf (state self) :idle))

(defmethod react ((self string-join) (e event))
  (flet ((send-both ()
	   (let ((out-e (make-instance 'event))
                 (pp (make-instance 'part-pin)))
	     (setf (part-name pp) (name-in-container self))
	     (setf (pin-name pp) "c")
             (setf (partpin out-e) pp)
	     (setf (data out-e)    (format nil "~a ~a~%" (string-a self) (string-b self)))
	     (send self out-e))))
    (ecase (state self)
      (:idle
       (cond ((and (string= (pin-name (partpin e)) "a") (stringp (data e)))
	      (setf (string-a self) (data e))
	      (setf (state self) :waiting-for-b))
	     ((and (string= (pin-name (partpin e)) "b") (stringp (data e)))
	      (setf (string-b self) (data e))
	      (setf (state self) :waiting-for-a))
	     (t (error (format nil "string-join in state :idle expected a string on pin a or on pin b, but got pin ~s with data ~s" (pin-name (partpin e)) (data e))))))

      (:waiting-for-b
       (cond ((and (string= (pin-name (partpin e)) "b") (stringp (data e)))
	      (setf (string-b self) (data e))
	      (send-both)
	      (setf (state self) :idle))
	     (t (error (format nil "string-join in state :waiting-for-b expected a string on pin b, but got pin ~s with data ~s" (pin-name (partpin e)) (data e))))))

      (:waiting-for-a
       (cond ((and (string= (pin-name (partpin e)) "a") (stringp (data e)))
	      (setf (string-a self) (data e))
	      (send-both)
	      (setf (state self) :idle))
	     (t (error (format nil "string-join in state :waiting-for-a expected a string on pin a, but got pin ~s with data ~s" (pin-name (partpin e)) (data e)))))))))

     
