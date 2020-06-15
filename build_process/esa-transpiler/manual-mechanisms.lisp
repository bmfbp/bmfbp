(in-package :arrowgrams/esa-transpiler)
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

;; see file exprtypes.lisp generated from exprtypes.dsl (see README.org)
;;
;; The generated class is environment.
;; All of the expression types are within the generated class environment.

;;;; v2 mechanisms
(defmethod emitHeader ((p parser))
  (pasm:emit-string p "(in-package :arrowgrams/esa)"))

;; an expression is true or false or an object ref
;; an object ref is an object name optionally dotted with fields
;; fields might have parameters
;; e.g. x
;; e.g. x.a.b.c
;; e.g. x.a(g).b(h i).c


;; name 

(defmethod $name__GetName ((p arrowgrams/esa-transpiler::parser))
  ;; put accepted symbol name onto input stack of "name" (replace top of name stack)
  (let ((str (scanner:token-text (pasm:accepted-token p)))
	(name-object (make-instance (stack-dsl:lisp-sym "name"))))
    (setf (stack-dsl:%value name-object) str)
    ;; 2 steps to replace top of name stack (pop then push)
    (stack-dsl:%pop (cl-user::input-name (env p)))
    (stack-dsl:%push (cl-user::input-name (env p)) name-object)))

(defmethod $name__combine ((p parser))
  (let ((name-tos (stack-dsl:%top (cl-user::input-name (env p)))))
    (let ((suffix (string (scanner:token-text (pasm:accepted-token p)))))
      (let ((new-text (concatenate 'string (stack-dsl:%value name-tos) suffix)))
	(setf (stack-dsl:%value name-tos) new-text)))))

(defmethod $name__IgnoreInPass1 ((p parser))
  (stack-dsl:%pop (cl-user::output-name (env p))))

(defmethod $name__IgnoreInPass2 ((p parser))
  (stack-dsl:%pop (cl-user::output-name (env p))))

(defmethod $expression__IgnoreInPass1 ((p parser))
  (stack-dsl:%pop (cl-user::output-expression (env p))))

;; emission

(defmethod true-p ((e cl-user::expression))
  (string= "true" (stack-dsl:%as-string (cl-user::ekind e))))
(defmethod false-p ((e cl-user::expression))
  (string= "false" (stack-dsl:%as-string (cl-user::ekind e))))
(defmethod object-p ((e cl-user::expression))
  (string= "object" (stack-dsl:%as-string (cl-user::ekind e))))

(defmethod empty-p ((x T))
(format *error-output* "~&empty-p T ~s~%" x)
  nil)
#+nil(defmethod empty-p ((self arrowgrams/esa-transpiler::empty))
(format *error-output* "~&empty-p self ~s~%" self)
  t)

(defmethod lispify ((self STRING))
  ;(intern (string-upcase self) "ARROWGRAMS/ESA"))
  ;; during early debug
  (intern (string-upcase self) "CL-USER"))

(defmethod lispify ((self stack-dsl:%string))
  (lispify (stack-dsl:%as-string self)))

(defmethod lispify ((self cl-user::name))
  (lispify (stack-dsl:%value self)))

(defmethod $emit__expression ((p parser))
  ;; abc --> abc
  ;; self.def -> (slot-value self 'def)
  ;; self.def.ghi (slot-value (slot-values self 'def) 'ghi)
  ;; self.def(ghi) -> ((slot-value abc 'def) ghi)
  ;; self.def(ghi).L -> *illegal for now* -> (slot-value ((slot-value abc 'def) ghi) 'L)
  ;; self.ensure-input-pin-not-declared(name) -> ((slot-value self 'ensure-input-pin-not-declared) name)
  (let ((e (stack-dsl:%top (cl-user::output-expression (env p)))))
    (break e))) ;; this causes an error, but allows inspect of e - OK during early debug


(defmethod set-current-method ((p parser))
  (setf (current-method p) (scanner:token-text (pasm:accepted-token p))))

(defmethod set-current-class ((p parser))
  (setf (current-class p) (scanner:token-text (pasm:accepted-token p))))

(defmethod $bp ((p parser))
  (break "forced break")
  (format *standard-output* "~&forced break ~s~%" p))




;; pass2

(defmethod $esaprogram__BeginScope ((p parser))
  ;; transpile-to-string sets (esaprogram p) to the result of pass1
  (stack-dsl:%push (cl-user::input-esaprogram (env p)) (esaprogram p)))

(defmethod $esaprogram__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-esaprogram (env p))))



(defmethod $whenDeclarations__FromProgram_BeginScope ((p parser))
  (let ((top-esaprogram (stack-dsl:%top (cl-user::input-esaprogram (env p)))))
    (stack-dsl:%push (cl-user::input-whenDeclarations (env p)) (cl-user::whenDeclarations top-esaprogram))))

(defmethod $whenDeclarations__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-whenDeclarations (env p))))

(defmethod $whenDeclarations__BeginMapping ((p parser))
  (let ((whenDeclaration-list (cl-user::as-list (stack-dsl:%top (cl-user::input-whenDeclarations (env p))))))
    (cl:push whenDeclaration-list (map-stack p))))

(defmethod $whenDeclarations__Next ((p parser))
  (cl:pop (cl:first (map-stack p))))

(defmethod $whenDeclarations__EndMapping ((p parser))
  (cl:pop (map-stack p)))



(defmethod $whenDeclaration__FromWhenDeclarationsMap_BeginScope ((p parser))
  (let ((first-when (cl:first (cl:first (map-stack p)))))
    (stack-dsl:%push (cl-user::input-whenDeclaration (env p)) first-when)))

(defmethod $whenDeclaration__EndScope((p parser))
  (stack-dsl:%pop (cl-user::input-whenDeclaration (env p))))



(defmethod $methodDeclarationsAndScriptDeclarations__FromWhenDeclaration_BeginScope ((p parser))
  (let ((top-when (stack-dsl:%top (cl-user::input-whenDeclaration (env p)))))
    (stack-dsl:%push (cl-user::input-methodDeclarationsAndScriptDeclarations (env p))
		     (cl-user::methodDeclarationsAndScriptDeclarations top-when))))

(defmethod $methodDeclarationsAndScriptDeclarations__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-methodDeclarationsAndScriptDeclarations (env p))))

(defmethod $methodDeclarationsAndScriptDeclarations__BeginMapping ((p parser))
  (cl:push (cl-user::as-list (stack-dsl:%top (cl-user::input-methodDeclarationsAndScriptDeclarations (env p))))
	   (map-stack p)))

(defmethod $methodDeclarationsAndScriptDeclarations__Next ((p parser))
  (cl:pop (cl:first (map-stack p))))

(defmethod $methodDeclarationsAndScriptDeclarations__EndMapping ((p parser))
  (cl:pop (map-stack p)))


(defmethod $methodDeclaration__FromMap_BeginScope ((p parser))
  (let ((methodDeclaration (cl:first (cl:first (map-stack p)))))
    (unless (eq 'cl-user::methodDeclaration (type-of methodDeclaration))
      (error (format nil "~a must be a methodDeclaration, but is ~a"
		     methodDeclaration (type-of methodDeclaration))))
    (stack-dsl:%push (cl-user::input-methodDeclaration (env p)) methodDeclaration)))

(defmethod $methodDeclaration__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-methodDeclaration (env p))))

(defmethod $scriptDeclaration__FromMap_BeginScope ((p parser))
  (let ((scriptDeclaration (cl:first (cl:first (map-stack p)))))
    (unless (eq 'cl-user::scriptDeclaration (type-of scriptDeclaration))
      (error (format nil "~a must be a scriptDeclaration, but is ~a"
		     scriptDeclaration (type-of scriptDeclaration))))
    (stack-dsl:%push (cl-user::input-scriptDeclaration (env p)) scriptDeclaration)))

(defmethod $scriptDeclaration__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-scriptDeclaration (env p))))


(defmethod $classes__FromProgram_BeginScope ((p parser))
  (let ((top-program (stack-dsl:%top (cl-user::input-esaprogram (env p)))))
    (stack-dsl:%push (cl-user::input-classes (env p))
		     (cl-user::classes top-program))))

(defmethod $classes__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-classes (env p))))


(defmethod $esaclass__LookupFromClasses_BeginScope ((p parser))
  (let ((top-name (cl-user::as-string (stack-dsl:%top (cl-user::output-name (env p))))))
    (let ((top-classmap (stack-dsl:%top (cl-user::input-classes (env p)))))
      (let ((found-class (cl-user::lookup-class top-classmap top-name)))
	(stack-dsl:%push (cl-user::input-esaclass (env p)) found-class))))
  (stack-dsl:%pop (cl-user::output-name (env p))))

(defmethod $esaclass__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-esaclass (env p))))


(defmethod $esaclass__SetField_methodsTable_empty ((p parser))
  (let ((top-class (stack-dsl:%top (cl-user::input-esaclass (env p)))))
    (setf (cl-user::methodsTable top-class) 
	  (stack-dsl:%make-empty-map "declarationMethodOrScript"))))


(defmethod $methodsTable__FromClass_BeginScope ((p parser))
  (let ((top-class (stack-dsl:%top (cl-user::input-esaclass (env p)))))
    (let ((m-list (cl-user::methodsTable top-class)))
      (stack-dsl:%push (cl-user::input-methodsTable (env p)) m-list))))

(defmethod $methodsTable__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-methodsTable (env p))))


(defmethod $scriptDeclaration__LookupFromTable_BeginScope ((p parser))
  (let ((script-name (cl-user::as-string (stack-dsl:%top (cl-user::output-name (env p))))))
    (let ((top-table (stack-dsl:%top (cl-user::input-methodsTable (env p)))))
      (let ((m (cl-user::lookup-method top-table script-name)))
	(unless (eq 'cl-user::scriptDeclaration (type-of m))
	  (error (format nil "~s is not a script ; it is declared as a ~s" script-name (type-of m))))
	(unless (cl-user::implementation-empty-p m)
	  (error (format nil "~s is multiply defined" script-name)))
	(stack-dsl:%push (cl-user::input-scriptDeclaration (env p)) m)))
    (stack-dsl::%pop (cl-user::output-name (env p)))))

(defmethod $scriptDeclaration__SetField_implementation_empty ((p parser))
  (let ((top-script (stack-dsl:%top (cl-user::input-scriptDeclaration (env p)))))
    (setf (cl-user::implementation top-script)
	  (stack-dsl:%make-empty-map "statement"))))


(defun check-stacks (p)
  (format *standard-output* "~%*** check stacks ***~%")
  (let ((i 0))
    (dolist (stack cl-user::*stacks*)
      (let ((name (symbol-name stack)))
	(let ((sym (intern name "CL-USER")))
	  #+nil(let ((wm (cl-user::%water-mark (env p))))
	    (format *standard-output* "~&sym=~a i=~a eq=~a~%" sym i (eq (nth i wm) (stack-dsl::%stack (slot-value (env p) sym)))))
	  (unless (zerop (length (stack-dsl::%stack (slot-value (env p) sym))))
	    (format *standard-output* "~&~a ~a~%" name (length (stack-dsl::%stack (slot-value (env p) sym)))))))
      (incf i))))

