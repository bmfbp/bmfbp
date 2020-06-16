(in-package :cl-user)
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

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
	   (asString (object self)))
	  (t (assert nil)))))

(defmethod asString ((self object))
  ; { name fieldMap }
  (let ((fields (mapcar #'asString (stack-dsl:%list (fieldMap self)))))
    (format nil "~a~{.~a~}" (asString (name self)) fields)))

(defmethod asString ((self field))
  ; { name fkind actualParameterList }
  (let ((params (if (slot-boundp self 'cl-user::actualParameterList)
		    (mapcar #'asString (stack-dsl:%list (cl-user::actualParameterList self)))
		    nil)))
    (format nil "~a(~{~a~^,~})" (asString (name self)) params)))

(defmethod asString ((self callExternalStatement))
  (let ((fname (asString (functionReference self))))
    (format nil "callExternal ~a" fname)))

(defmethod asString ((self callInternalStatement))
  (let ((fname (asString (functionReference self))))
    (format nil "callInternal ~a" fname)))

(defmethod asString ((self implementation))
  (mapcar #'asString (stack-dsl:%list self)))

(defmethod asString ((self esaprogram))
  (mapcar #'asString (stack-dsl:%list (classes self))))

(defmethod asString ((self esaClass))
  (let ((name (format nil "class ~a~%" (asString (name self)))))
    (let ((fields (mapcar #'(lambda (f) (format nil "field ~a~%" (asString (name f)))) (stack-dsl:%list (fieldMap self)))))
      (let ((methods (mapcar #'asString (stack-dsl:%list (methodsTable self)))))
	(format nil "~a~{~4,T~a~}~{~4,T~a~}end class" name fields methods)))))

(defmethod asString ((self methodDeclaration))
  (format nil "ext-method ~a~%" (asString (name self))))

(defmethod asString ((self scriptDeclaration))
  (let ((statements (insert-tab 8 (mapcar #'asString (stack-dsl:%list (implementation self))))))
    (format nil "method ~a~{~&~v,T(~a)~%~}~&~4,Tend method~%" (asString (name self)) statements)))

(defun insert-tab (n lis)
  (unless (null lis)
    `(,n ,(car lis) ,@(insert-tab n (cdr lis)))))

(defmethod asString ((self letStatement))
  (let ((vn (asString (varName self)))
	(e  (asString (expression self)))
	(code (asString (implementation self))))
    (format nil "let ~a=~a in ~{~%~a~}~%end let" vn e code)))
