(in-package :cl-user)
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

(defmethod asString ((self name))
  (stack-dsl::%value self))

(defmethod asString ((self expression))
  ;; { ekind object }
  (let ((k (stack-dsl::%value (ekind self))))
    (cond ((string= "true" k)
	 "t")
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
    (let ((result (asString (name self))))
      (dolist (f fields)
	(setf result (format nil f result)))
      result)))

(defmethod asString ((self field))
  ; { name fkind actualParameterList }
  (let ((params (if (slot-boundp self 'cl-user::actualParameterList)
		    (mapcar #'asString (stack-dsl:%list (cl-user::actualParameterList self)))
		    nil)))
    (if (null params)
	(format nil "(slot-value ~~a '~a)" (asString (name self)))
	(format nil "((slot-value ~~a '~a) ~{~a~^ ~})" (asString (name self)) params))))

(defmethod asString ((self callExternalStatement))
  (let ((fname (asString (functionReference self))))
    (format nil "~a" fname)))

(defmethod asString ((self callInternalStatement))
  (let ((fname (asString (functionReference self))))
    (format nil "~a" fname)))

(defmethod asString ((self implementation))
  (mapcar #'asString (stack-dsl:%list self)))

(defmethod asString ((self esaprogram))
  (let ((strings-list (mapcar #'asString (stack-dsl:%list (classes self)))))
    (apply 'concatenate 'string strings-list)))

(defmethod asString ((self esaClass))
  (let ((name (format nil "~a" (asString (name self)))))
    (let ((fields (mapcar #'(lambda (f) 
			      (format nil "(~a :accessor ~a)" 
				      (asString (name f)) 
				      (asString (name f))))
			  (stack-dsl:%list (fieldMap self)))))
      (let ((def (if fields
		     (format nil "~&~%(defclass ~a ()~%(~{~&~a~^~}))~%" name fields)
		     (format nil "~&~%(defclass ~a () ())~%" name))))
	(let ((methods (mapcar #'asString (stack-dsl:%list (methodsTable self)))))
	  (let ((methodsString (format nil "~{~&~a~}" methods)))
	    (concatenate 'string def methodsString)))))))

(defmethod asString ((self methodDeclaration))
  (format nil "#| external method (~a) ~a |#~%" (asString (esaKind self)) (asString (name self))))

(defmethod asString ((self scriptDeclaration))
  (let ((statements (insert-tab 8 (mapcar #'asString (stack-dsl:%list (implementation self))))))
    (format nil "(defmethod ~a ((self ~a) ~{~a~^ ~})~{~&~v,T~a~^~%~})~%" 
	    (asString (name self)) 
	    (asString (esaKind self))
            (mapcar #'asString (stack-dsl:%list (formalList self)))
	    statements)))

(defun insert-tab (n lis)
  (unless (null lis)
    `(,n ,(car lis) ,@(insert-tab n (cdr lis)))))

(defmethod asString ((self letStatement))
  (let ((vn (asString (varName self)))
	(e  (asString (expression self)))
	(code (asString (implementation self))))
    (format nil "(let ((~a ~a)) ~{~%~a~})" vn e code)))

(defmethod asString ((self mapStatement))
  (let ((vn (asString (varName self)))
	(e  (asString (expression self)))
	(code (asString (implementation self))))
    (format nil "(block %map (dolist (~a ~a) ~{~%~a~}))" vn e code)))

(defmethod asString ((self createStatement))
  (let ((vn (asString (varName self)))
	(cn  (asString (name self)))
	(i   (asString (indirectionKind self)))
	(code (asString (implementation self))))
    (if (string= "direct" i)
	(format nil "(let ((~a (make-instance '~a)))~%~{~a~^~%~})" vn cn code)
	(format nil "(let ((~a (make-instance ~a)))~%~{~a~&~%~})" vn cn code))))

(defmethod asString ((self setStatement))
  (let ((lv (asString (lval self)))
	(e  (asString (expression self))))
    (format nil "(setf ~a ~a)" lv e)))

(defmethod asString ((self indirectionKind))
  (stack-dsl:%value self))

(defmethod asString ((self exitWhenStatement))
  (let ((e (asString (expression self))))
    (format nil "(when ~a (return))" e)))

(defmethod asString ((self exitMapStatement))
  "(return-from %map)")

(defmethod asString ((self returnTrueStatement))
  "t")

(defmethod asString ((self returnFalseStatement))
  "nil")

(defmethod asString ((self returnValueStatement))
  (let ((n (asString (name self))))
    (format nil "~a" n)))

(defmethod asString ((self loopStatement))
  (let ((code (asString (implementation self))))
    (format nil "(loop ~{~%~a~})" code)))

(defmethod asString ((self ifStatement))
  (let ((e  (asString (expression self)))
	(then (asString (thenPart self))))
    (if (stack-dsl:%empty-p (elsePart self))
	(format nil "(when ~a~%~{~a~%~^~})" e then)
	(let ((els (asString (elsePart self))))
	  (format nil "(if ~a~%(progn~%~{~a~%~^~})~%(progn~%~{~a~%~^~}))" e then els)))))

