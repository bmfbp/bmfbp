(in-package :cl-user)
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

(defun filter-name (s)
  (substitute #\P #\' 
	      (substitute #\Q #\? 
			  (substitute #\_ #\- s))))

(defmethod asJS ((self name))
  (stack-dsl::%value self))

(defmethod asJS ((self expression))
  ;; { ekind object }
  (let ((k (stack-dsl::%value (ekind self))))
    (cond ((string= "true" k)
	 "true")
	  ((string= "false" k)
	   "false")
	  ((string= "object" k)
	   (asJS (object self)))
	  ((string= "calledObject" k)
	   (asJS (object self)))
	  (t (assert nil)))))

(defmethod parameters-p ((self object))
  nil) ;; by definition in exprtypes.dsl

(defmethod asJS ((self field))
  ; { name fkind actualParameterList }
  (let ((params (if (slot-boundp self 'cl-user::actualParameterList)
		    (mapcar #'asJS (stack-dsl:%list (cl-user::actualParameterList self)))
		    nil)))
;;...............................VVV leave ~a in string for format in caller
    ;(format nil "(funcall #'~a ~~a~{~^ ~a~^~})" (asJS (uname self)) params)))
    (if params
	(format nil ".~a (~{~a~^, ~})" (filter-name (asJS (name self))) params)
	(format nil ".~a ()" (filter-name (asJS (name self)))))))

(defmethod asJS ((self object))
  ; { name fieldMap }

  (let ((field-list (mapcar #'asJS (stack-dsl:%list (fieldMap self)))))
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
	   ;; at this point, (name object) will return the object's name
	   ;; and field-list is a (lisp) list of fields
	   (format nil "~a~{~a~}" (filter-name (asJS (name self))) field-list))
	  )))

(defmethod asJS ((self callExternalStatement))
  (let ((fname (asJS (functionReference self))))
    (format nil "~a;" (filter-name fname))))

(defmethod asJS ((self callInternalStatement))
  (let ((fname (asJS (functionReference self))))
    (format nil "~a;" (filter-name fname))))

(defmethod asJS ((self implementation))
  (mapcar #'asJS (stack-dsl:%list self)))

(defmethod asJS ((self esaprogram))
  (let ((strings-list (mapcar #'asJS (stack-dsl:%list (classes self)))))
    (apply 'concatenate 'string strings-list)))

(defmethod asJS ((self esaClass))
  (let ((name (format nil "~a" (filter-name (asJS (name self))))))
    (let ((fields (mapcar #'(lambda (f) 
			      (format nil "this.attribute_~a = null;~%this.~a = function () { return attribute_~a; };" 
				      (filter-name (asJS (name f)))
				      (filter-name (asJS (name f)))
				      (filter-name (asJS (name f)))
				      ))
			  (stack-dsl:%list (fieldMap self)))))
      (let ((def (if fields
		     (format nil "~&~%function ~a () {~%~{~a~^~%~}~%}~%" (filter-name name) fields)
		     (format nil "~&~%function ~a () {}~%" (filter-name name)))))
	(let ((methods (mapcar #'asJS (stack-dsl:%list (methodsTable self)))))
	  (let ((methodsString (format nil "~{~&~a~}" methods)))
	    (concatenate 'string def methodsString)))))))

(defmethod asJS ((self methodDeclaration))
  (format nil "// external method ((self ~a)) ~a~%" (asJS (esaKind self)) (filter-name (asJS (name self)))))

(defmethod asJS ((self scriptDeclaration))
  (let ((statements (insert-tab 8 (mapcar #'asJS (stack-dsl:%list (implementation self))))))
    (format nil "function ~a (self~{, ~a~^~}) {~{~&~v,T~a~^~%~}~%};~%" 
	    (filter-name (asJS (name self)) )
            (mapcar #'(lambda (x) (filter-name (asJS x))) (stack-dsl:%list (formalList self)))
	    statements)))

(defun insert-tab (n lis)
  (unless (null lis)
    `(,n ,(car lis) ,@(insert-tab n (cdr lis)))))

(defmethod asJS ((self letStatement))
  (let ((vn (asJS (varName self)))
	(e  (asJS (expression self)))
	(code (asJS (implementation self))))
    (format nil "{ /*let*/~%let ~a = ~a;~{~%~a~}~%} /* end let */" (filter-name vn) e code)))

(defmethod asJS ((self mapStatement))
  (let ((vn (asJS (varName self)))
	(e  (asJS (expression self)))
	(code (asJS (implementation self))))
    ;; a :map becomes a function - return from map becomes return
    (format nil "(function () {~%for (const ~a in ~a) {~{~%~a~}~%};~%}) ();" (filter-name vn) e code)))
    
(defmethod asJS ((self createStatement))
  (let ((vn (asJS (varName self)))
	(cn  (asJS (name self)))
	(i   (asJS (indirectionKind self)))
	(code (asJS (implementation self))))
    ;; create is not special-cased in JS
    ;; JS's "new" checks to see that its argument is a class or is a variable holding a class
    (if (string= "direct" i)
	(format nil "{ let ~a = new ~a;~%~{~a~^~%~}}~%" (filter-name vn) cn code)
	(format nil "{ let ~a = new ~a;~%~{~a~^~%~}}~%" (filter-name vn) cn code))))

(defmethod asJS ((self setStatement))
  (let ((lv (asJS (lval self)))
	(e  (asJS (expression self))))
    (format nil "~a = ~a;" (filter-name lv) e)))

(defmethod asJS ((self indirectionKind))
  (stack-dsl:%value self))

(defmethod asJS ((self exitWhenStatement))
  (let ((e (asJS (expression self))))
    (format nil "if (~a) {break;};~%" e)))

(defmethod asJS ((self exitMapStatement))
  "return;")

(defmethod asJS ((self returnTrueStatement))
  (let ((method-name (asJS (cl-user::methodName self))))
    (format nil "return true;" method-name)))

(defmethod asJS ((self returnFalseStatement))
  (let ((method-name (asJS (cl-user::methodName self))))
    (format nil "return false;" method-name)))

(defmethod asJS ((self returnValueStatement))
  (let ((method-name (asJS (cl-user::methodName self))))
    (let ((n (asJS (name self))))
      (format nil "return ~a;" (filter-name n)))))

(defmethod asJS ((self loopStatement))
  (let ((code (asJS (implementation self))))
    (format nil "for (;;) {~{~%~a~}}" code))
)
(defmethod asJS ((self ifStatement))
  (let ((e  (asJS (expression self)))
	(then (asJS (thenPart self))))
    (if (stack-dsl:%empty-p (elsePart self))
	(format nil "if (~a) {~%~%~{~a~%~^~}}" e then)
	(let ((els (asJS (elsePart self))))
	  (format nil "if (~a) {~%~{~a~%~^~}} else {~%~{~a~%~^~}}" e then els)))))


