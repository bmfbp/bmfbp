(in-package :cl-user)
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

(defmethod asJS-inDeclaration ((self stack-dsl::%stack-dsl-type))
  (asJs self))

(defmethod asJS-inStatement ((self stack-dsl::%stack-dsl-type))
  (let ((s (asJs self)))
    (if (string= s "self")
        "this"
      s)))

(defmethod asJS ((self name))
  (stack-dsl::%value self))

<template id="a">
  ;; { ekind object }
  (let ((k (stack-dsl::%value (ekind self))))
    (cond ((string= "true" k)
	 "true")
	  ((string= "false" k)
	   "false")
	  ((string= "object" k)
	   (asJS (object self)))
	  ((string= "calledObject" k)
  <edit id="1">
	   (asJS (object self)))
  </edit id="1">
	  (t (assert nil)))))

(defmethod asJS ((self expression))
<sameas id="a">
  <edit id="1">
	   (asJS (object self)))
  </edit id="1">
</sameas id="a">


(defmethod asJS-inStatement ((self expression))
<sameas id="a">
  <edit id="1">
	   (asJS-inStatement (object self)))
  </edit id="1">
</sameas id="a">
</template id="a">

(defmethod parameters-p ((self object))
  nil) ;; by definition in exprtypes.dsl

(defmethod asJS ((self field))
  ; { name fkind actualParameterList }
  (let ((params (if (slot-boundp self 'cl-user::actualParameterList)
		    (mapcar #'asJS (stack-dsl:%list (cl-user::actualParameterList self)))
		    nil)))
;;...............................VVV leave ~a in string for format in caller
    ;(format nil "(funcall #'~a ~~a~{~^ ~a~^~})" (asJS (name self)) params)))
    ;; method call mmm(self,{params})
    (format nil "~a(~~a,~{~^~a~^,~})" (asJS (name self)) params)))

(defmethod asJS-inStatement ((self field))
  ; { name fkind actualParameterList }
  (let ((params (if (slot-boundp self 'cl-user::actualParameterList)
		    (mapcar #'asJS (stack-dsl:%list (cl-user::actualParameterList self)))
		    nil)))
;;...............................VVV leave ~a in string for format in caller
    ;(format nil "(funcall #'~a ~~a~{~^ ~a~^~})" (asJS (name self)) params)))
    ;; method call mmm(self,{params})
    (format nil "~a(~~a,~{~^~a~^,~})" (asJS-inStatement (name self)) params)))

(defmethod asNestedJS ((self object))
  ; { name fieldMap }
  (let ((fields (mapcar #'asJS (stack-dsl:%list (fieldMap self)))))
    (let ((result (asJS (name self))))
      (dolist (f fields)
	(setf result (format nil f result)))
      result)))

(defmethod asJS ((self object))
  ; { name fieldMap }

  (let ((field-list (stack-dsl:%list (fieldMap self))))
    (cond ((and (null field-list)
		(not (parameters-p self)))
	   ;; x -> "x"
	   (asJS (name self)))
	  
	  ((and (null field-list)
		(parameters-p self))
	   ;; illegal for esa.dsl
	   ;; x() => assert fail during bootstrap
	   (assert nil))

	  (t 
	   (asNestedJS self)))))

(defmethod asJS-inStatement ((self callExternalStatement))
  (let ((fname (asJS-inStatement (functionReference self))))
    (format nil "~a" fname)))

(defmethod asJS-inStatement ((self callInternalStatement))
  (let ((fname (asJS-inStatement (functionReference self))))
    (format nil "~a" fname)))



(defmethod asJS-inStatement ((self implementation))
  (mapcar #'asJS-inStatement (stack-dsl:%list self)))


(defmethod asJS ((self esaprogram))
  (let ((strings-list (mapcar #'asJS-inDeclaration (stack-dsl:%list (classes self)))))
    (apply 'concatenate 'string strings-list)))

(defmethod asJS ((self esaClass))
  (let ((name (format nil "~a" (asJS (name self)))))
    (let ((fields (mapcar #'(lambda (f) 
			      (format nil "~a" (asJS-inDeclaration (name f))))
			  (stack-dsl:%list (fieldMap self)))))
      (let ((def (if fields
		     (format nil "~&~%class ~a {~%~{~&  ~a;~^~}" name fields)
		     (format nil "~&~%class ~a {~%" name))))
	(let ((methods (mapcar #'asJS-inStatement (stack-dsl:%list (methodsTable self)))))
	  (let ((methodsString (format nil "~%~{~&~a~}" methods)))
	    (concatenate 'string def "
  constructor () { super (); }"  methodsString "
}")))))))

(defmethod asJS ((self methodDeclaration))
  (let ((statements nil))
    (format nil "// external function ~a(~{~a~^,~}){}~%"
            (asJS (name self))
            (cons
             (format nil "self /*:~a*/" (asJS (esaKind self)))
             (mapcar #'(lambda (x)
                         (concatenate 'string (format nil "~a /*:~a*/" (gensym "P") (asJS x))))
                     (stack-dsl:%list (formalList self))))
            statements)))

(defmethod asJS ((self scriptDeclaration))
  (let ((statements (insert-tab 8 (mapcar #'asJS-inStatement (stack-dsl:%list (implementation self))))))
    (format nil "  ~a (~{~a~^,~}) {~%~{~&~v,T~a;~^~%~}~%}~%" 
	    (asJS (name self)) 
            (mapcar #'asJS-inDeclaration (stack-dsl:%list (formalList self)))
	    statements)))

(defun insert-tab (n lis)
  (unless (null lis)
    `(,n ,(car lis) ,@(insert-tab n (cdr lis)))))

(defmethod asJS ((self letStatement))
  (let ((vn (asJS (varName self)))
	(e  (asJS (expression self)))
	(code (asJS (implementation self))))
    (format nil "(let ((~a ~a)) ~{~%~a~})" vn e code)))

(defmethod asJS ((self mapStatement))
  (let ((vn (asJS (varName self)))
	(e  (asJS (expression self)))
	(code (asJS (implementation self))))
    (format nil "(block %map (dolist (~a ~a) ~{~%~a~}))" vn e code)))

(defmethod asJS ((self createStatement))
  (let ((vn (asJS (varName self)))
	(cn  (asJS (name self)))
	(i   (asJS (indirectionKind self)))
	(code (asJS (implementation self))))
    (if (string= "direct" i)
	(format nil "(let ((~a (make-instance '~a)))~%~{~a~^~%~})" vn cn code)
	(format nil "(let ((~a (make-instance ~a)))~%~{~a~^~%~})" vn cn code))))

(defmethod asJS ((self setStatement))
  (let ((lv (asJS (lval self)))
	(e  (asJS (expression self))))
    (format nil "(setf ~a ~a)" lv e)))

(defmethod asJS ((self indirectionKind))
  (stack-dsl:%value self))

(defmethod asJS ((self exitWhenStatement))
  (let ((e (asJS (expression self))))
    (format nil "(when (esa-expr-true ~a) (return))" e)))

(defmethod asJS ((self exitMapStatement))
  "(return-from %map :false)")

(defmethod asJS ((self returnTrueStatement))
  (let ((method-name (asJS (cl-user::methodName self))))
    (format nil "(return-from ~a :true)" method-name)))

(defmethod asJS ((self returnFalseStatement))
  (let ((method-name (asJS (cl-user::methodName self))))
    (format nil "(return-from ~a :false)" method-name)))

(defmethod asJS ((self returnValueStatement))
  (let ((method-name (asJS (cl-user::methodName self))))
    (let ((n (asJS (name self))))
      (format nil "(return-from ~a ~a)" method-name n))))

(defmethod asJS ((self loopStatement))
  (let ((code (asJS (implementation self))))
    (format nil "(loop ~{~%~a~})" code)))

(defmethod asJS ((self ifStatement))
  (let ((e  (asJS (expression self)))
	(then (asJS (thenPart self))))
    (if (stack-dsl:%empty-p (elsePart self))
	(format nil "(when (esa-expr-true ~a)~%~{~a~%~^~})" e then)
	(let ((els (asJS (elsePart self))))
	  (format nil "(if (esa-expr-true ~a)~%(progn~%~{~a~%~^~})~%(progn~%~{~a~%~^~}))" e then els)))))

