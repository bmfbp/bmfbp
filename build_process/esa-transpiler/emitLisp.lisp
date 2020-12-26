(in-package :cl-user)
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

(defmethod asLisp ((self name))
  (stack-dsl::%value self))

(defmethod asLisp ((self expression))
  ;; { ekind object }
  (let ((k (stack-dsl::%value (ekind self))))
    (cond ((string= "true" k)
	 ":true")
	  ((string= "false" k)
	   ":false")
	  ((string= "object" k)
	   (asLisp (object self)))
	  ((string= "calledObject" k)
	   (asLisp (object self)))
	  (t (assert nil)))))

(defmethod parameters-p ((self object))
  nil) ;; by definition in exprtypes.dsl

(defmethod asLisp ((self field))
  ; { name fkind actualParameterList }
  (let ((params (if (slot-boundp self 'cl-user::actualParameterList)
		    (mapcar #'asLisp (stack-dsl:%list (cl-user::actualParameterList self)))
		    nil)))
;;...............................VVV leave ~a in string for format in caller
					;(format nil "(funcall #'~a ~~a~{~^ ~a~^~})" (asLisp (name self)) params)))
    (if (slot-boundp self 'cl-user::name)
	(format nil "(~a ~~a~{~^ ~a~^~})" (asLisp (name self)) params)
	(error "** field name not declared **"))))

(defmethod asNestedLisp ((self object))
  ; { name fieldMap }
  (let ((fields (mapcar #'asLisp (stack-dsl:%list (fieldMap self)))))
    (let ((result (asLisp (name self))))
      (dolist (f fields)
	(setf result (format nil f result)))
      result)))

(defmethod asLisp ((self object))
  ; { name fieldMap }

  (let ((field-list (stack-dsl:%list (fieldMap self))))
    (cond ((and (null field-list)
		(not (parameters-p self)))
	   ;; x -> "x"
	   (asLisp (name self)))
	  
	  ((and (null field-list)
		(parameters-p self))
	   ;; illegal for esa.dsl
	   ;; x() => assert fail during bootstrap
	   (assert nil))

	  (t 
	   (asNestedLisp self)))))

(defmethod asLisp ((self callExternalStatement))
  (let ((fname (asLisp (functionReference self))))
    (format nil "~a" fname)))

(defmethod asLisp ((self callInternalStatement))
  (let ((fname (asLisp (functionReference self))))
    (format nil "~a" fname)))

(defmethod asLisp ((self implementation))
  (mapcar #'asLisp (stack-dsl:%list self)))

(defmethod asLisp ((self esaprogram))
  (let ((strings-list (mapcar #'asLisp (stack-dsl:%list (classes self)))))
    (apply 'concatenate 'string strings-list)))

(defmethod asLisp ((self esaClass))
  (let ((name (format nil "~a" (asLisp (name self)))))
    (let ((fields (mapcar #'(lambda (f) 
			      (format nil "(~a :accessor ~a :initform nil)" 
				      (asLisp (name f)) 
				      (asLisp (name f))))
			  (stack-dsl:%list (fieldMap self)))))
      (let ((def (if fields
		     (format nil "~&~%(defclass ~a ()~%(~{~&~a~^~}))~%" name fields)
		     (format nil "~&~%(defclass ~a () ())~%" name))))
	(let ((methods (mapcar #'asLisp (stack-dsl:%list (methodsTable self)))))
	  (let ((methodsString (format nil "~{~&~a~}" methods)))
	    (concatenate 'string def methodsString)))))))

(defmethod asLisp ((self methodDeclaration))
  (format nil "#| external method ((self ~a)) ~a |#~%" (asLisp (esaKind self)) (asLisp (name self))))

(defmethod asLisp ((self scriptDeclaration))
  (let ((statements (insert-tab 8 (mapcar #'asLisp (stack-dsl:%list (implementation self))))))
    (format nil "(defmethod ~a ((self ~a) ~{~a~^ ~})~{~&~v,T~a~^~%~})~%" 
	    (asLisp (name self)) 
	    (asLisp (esaKind self))
            (mapcar #'asLisp (stack-dsl:%list (formalList self)))
	    statements)))

(defun insert-tab (n lis)
  (unless (null lis)
    `(,n ,(car lis) ,@(insert-tab n (cdr lis)))))

(defmethod asLisp ((self letStatement))
  (let ((vn (asLisp (varName self)))
	(e  (asLisp (expression self)))
	(code (asLisp (implementation self))))
    (format nil "(let ((~a ~a)) ~{~%~a~})" vn e code)))

(defmethod asLisp ((self mapStatement))
  (let ((vn (asLisp (varName self)))
	(e  (asLisp (expression self)))
	(code (asLisp (implementation self))))
    (format nil "(block %map (dolist (~a (stack-dsl::%ordered-list ~a))
~%(unless (and (eq 'stack-dsl:%typed-value (type-of ~a))
               (eq (stack-dsl:%type ~a) (stack-dsl::%element-type ~a)))
  (error (format nil \"ESA: [~~a] must be of type [~~a]\" ~a (stack-dsl::%element-type ~a))))
~{~%~a~}))" 
vn e vn vn e vn e code)))

(defmethod asLisp ((self createStatement))
  (let ((vn (asLisp (varName self)))
	(cn  (asLisp (name self)))
	(i   (asLisp (indirectionKind self)))
	(code (asLisp (implementation self))))
    (if (string= "direct" i)
	(format nil "(let ((~a (make-instance '~a)))~%~{~a~^~%~})" vn cn code)
	(format nil "(let ((~a (make-instance ~a)))~%~{~a~^~%~})" vn cn code))))

(defmethod asLisp ((self setStatement))
  (let ((lv (asLisp (lval self)))
	(e  (asLisp (expression self))))
    (format nil "(setf ~a ~a)" lv e)))

(defmethod asLisp ((self indirectionKind))
  (stack-dsl:%value self))

(defmethod asLisp ((self exitWhenStatement))
  (let ((e (asLisp (expression self))))
    (format nil "(when (esa-expr-true ~a) (return))" e)))

(defmethod asLisp ((self exitMapStatement))
  "(return-from %map :false)")

(defmethod asLisp ((self returnTrueStatement))
  (let ((method-name (asLisp (cl-user::methodName self))))
    (format nil "(return-from ~a :true)" method-name)))

(defmethod asLisp ((self returnFalseStatement))
  (let ((method-name (asLisp (cl-user::methodName self))))
    (format nil "(return-from ~a :false)" method-name)))

(defmethod asLisp ((self returnValueStatement))
  (let ((method-name (asLisp (cl-user::methodName self))))
    (let ((n (asLisp (name self))))
      (format nil "(return-from ~a ~a)" method-name n))))

(defmethod asLisp ((self loopStatement))
  (let ((code (asLisp (implementation self))))
    (format nil "(loop ~{~%~a~})" code)))

(defmethod asLisp ((self ifStatement))
  (let ((e  (asLisp (expression self)))
	(then (asLisp (thenPart self))))
    (if (stack-dsl:%empty-p (elsePart self))
	(format nil "(when (esa-expr-true ~a)~%~{~a~%~^~})" e then)
	(let ((els (asLisp (elsePart self))))
	  (format nil "(if (esa-expr-true ~a)~%(progn~%~{~a~%~^~})~%(progn~%~{~a~%~^~}))" e then els)))))

