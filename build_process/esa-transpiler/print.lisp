(in-package :cl-user)

(defmethod asString ((self name))
  (stack-dsl::%value self))

(defmethod asString ((self returnTrueStatement))
  ":true")

(defmethod asString ((self returnFalsStatement))
  nil)

(defmethod asString ((self expression))
  ;; { ekind object }
  (cond ((string= "true" (ekind self))
	 ":true")
	((string= "false" (ekind self))
	 nil)
	((string= "object" (ekind self))
	 (asString (object self)))
	((string= "calledObject" (ekind self)))
	(asString (object self))
	(t (assert nil))))

(defmethod asString ((self object))
  ; { name fieldMap }
  (let ((fieldStrings (mapcar #'(lambda (f)  
				  (format nil ".~a" (asString f)))
			      (fieldMap self))))
    (if (null fieldStrings)
	(format nil "~a" (asString (name self)))
	(format nil "~a~a" (asString (name self)) fieldStrings))))

(defmethod asString ((self field))
  ; { name fkind actualParameterList }
  (let ((params (mapcar #'(lambda (p) (format nil " ~a" (asString p))))))
    (if (null params)
	(format nil "~a" (asString (name self)))
	(format nil "~a(~a)" (asString (name self)) params))))
