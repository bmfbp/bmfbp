(in-package :cl-user)

(defmethod asString ((self name))
  (stack-dsl::%value self))

(defmethod asString ((self expression))
  ;; { ekind object }
  (let ((k (stack-dsl::%value (ekind self))))
    (cond ((string= "true" k)
	 ":true")
	  ((string= "false" k)
	   nil)
	  ((string= "object" k)
	   (asString (object self)))
	  ((string= "calledObject" k)
	   (asString (object self))
	   (t (assert nil))))))

(defmethod asString ((self object))
  ; { name fieldMap }
  (let ((fieldStrings (mapcar #'(lambda (f)  
				  (format nil ".~a" (asString f)))
			      (stack-dsl:%list (fieldMap self)))))
    (if (null fieldStrings)
	(format nil "~a" (asString (name self)))
	(format nil "~a~a" (asString (name self)) fieldStrings))))

(defmethod asString ((self field))
  ; { name fkind actualParameterList }
  (let ((params (mapcar #'(lambda (p) (format nil " ~a" (asString p))))))
    (if (null params)
	(format nil "~a" (asString (name self)))
	(format nil "~a(~a)" (asString (name self)) params))))
