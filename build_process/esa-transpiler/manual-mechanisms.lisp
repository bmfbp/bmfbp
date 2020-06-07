(in-package :arrowgrams/esa-transpiler)

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
  (break p "forced break"))


;; methods + lookups during code emission
(defmethod $esaprogram__class_BeginScope_LookupByName ((p parser))
  (stack-dsl:%push p (cl-user::lookup-class p (cl-user::output-name (env p))))
  (stack-dsl:%pop p (cl-user::output-name (env p))))

(defmethod $class_EndScope ((p parser))
  (stack-dsl:%pop p (cl-user::input-esaclass (env p))))

(defmethod $expression__OverwriteField_from_ekind ((p parser))
  ;; reset field kind of TOs(output-expression)
  (setf (cl-user::ekind (stack-dsl:%top (cl-user::output-expression (env p))))
	(stack-dsl:%top (cl-user::output-ekind (env p))))
  (stack-dsl:%pop (cl-user::output-ekind (env p))))

(defmethod $methodDeclaraction__SetField_implementation_empty ((p parser))
  (setf (cl-user::implementation (stack-dsl:%top (cl-user::methodDeclaration (env p))))
        nil))

(defmethod $scriptdDeclaraction__SetField_implementation_empty ((p parser))
  (setf (cl-user::implementation (stack-dsl:%top (cl-user::scriptDeclaration (env p))))
        nil))

;; pass2

(defmethod $esaprogram__BeginScope ((p parser))
  ;; transpile-to-string sets (esaprogram p) to the result of pass1
  (stack-dsl:%push (cl-user::input-esaprogram (env p)) (esaprogram p)))

(defmethod $esaprogram__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-esaprogram (env p))))

(defmethod $esaclass__LookupByName_BeginScope ((p parser))
  (let ((name (cl-user::as-string (stack-dsl:%top (cl-user::output-name (env p))))))
(format *standard-output* "~&searching for class ~a~%" name)
    (let ((c (cl-user::lookup-class (stack-dsl:%top (cl-user::input-esaprogram (env p))) name)))
      (stack-dsl:%push (cl-user::input-esaclass (env p)) c))
    (stack-dsl:%pop (cl-user::output-name (env p)))))

(defmethod $esaclass__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-esaclass (env p))))

(defmethod $esaclass__SetField_methodsTable_empty ((p parser))
  (let ((top-class (stack-dsl:%top (cl-user::esaclass (env p)))))
    (setf (cl-user::scriptsTable top-class) (make-instance 'stack-dsl::%map :%element-type 'cl-user::methodsTable))))

(defmethod $esaclass__SetField_scriptsTable_empty ((p parser))
  (let ((top-class (stack-dsl:%top (cl-user::esaclass (env p)))))
    (setf (cl-user::scriptsTable top-class) (make-instance 'stack-dsl::%map :%element-type 'cl-user::scriptsTable))))

(defmethod $scriptsTable__BeginScopeFrom_esaclass ((p parser))
  (let ((top-class (stack-dsl:%top (cl-user::esaclass (env p)))))
    (stack-dsl:%push p (cl-user::scriptsTable (env p)))))

(defmethod $scriptsTable__EndScope ((p parser))
  (stack-dsl:%pop p (cl-user::scriptsTable (env p))))

(defmethod $scriptsTable__AppendFrom_internalMethod ((p parser))
  (let ((top-scriptsTable (stack-dsl:%top (cl-user::input-scriptsTable (env p)))))
    (let ((top-internalMethod (stack-dsl:%top (cl-user::output-internalMethod (env p)))))
      (stack-dsl:%ensure-appendable-type top-scriptsTable)
      (stack-dsl:%append top-scriptsTable top-internalMethod)
      (stack-dsl:%pop (cl-user::output-internalMethod (env p))))))


(defmethod $methodsTable__BeginScopeFrom_esaclass ((p parser))
  (let ((top-class (stack-dsl:%top (cl-user::esaclass (env p)))))
    (stack-dsl:%push (cl-user::methodsTable (env p)))))

(defmethod $methodsTable__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::methodsTable (env p))))

(defmethod $methodsTable__AppendFrom_externalMethod ((p parser))
  (let ((top-methodsTable (stack-dsl:%top (cl-user::input-methodsTable (env p)))))
    (let ((top-internalMethod (stack-dsl:%top (cl-user::output-externalMethod (env p)))))
      (stack-dsl:%ensure-appendable-type top-methodsTable)
      (stack-dsl:%append top-methodsTable top-externalMethod)
      (stack-dsl:%pop (cl-user::output-externalMethod (env p))))))

(defmethod $name__EndOutputScope ((p parser))
  (stack-dsl:%pop (output-name (env p))))

(defparameter *stacks* '(
			 input-esaprogram
			 output-esaprogram
			 input-typeDecls
			 output-typeDecls
			 input-situations
			 output-situations
			 input-classes
			 output-classes
			 input-whenDeclarations
			 output-whenDeclarations
			 input-scriptImplementations
			 output-scriptImplementations
			 input-typeDecl
			 output-typeDecl
			 input-name
			 output-name
			 input-typeName
			 output-typeName
			 input-situationDefinition
			 output-situationDefinition
			 input-esaclass
			 output-esaclass
			 input-fieldMap
			 output-fieldMap
			 input-methodsTable
			 output-methodsTable
			 input-scriptsTable
			 output-scriptsTable
			 input-whenDeclaration
			 output-whenDeclaration
			 input-situationReferenceList
			 output-situationReferenceList
			 input-esaKind
			 output-esaKind
			 input-methodDeclarationsAndScriptDeclarations
			 output-methodDeclarationsAndScriptDeclarations
			 input-situationReferenceName
			 output-situationReferenceName
			 input-declarationMethodOrScript
			 output-declarationMethodOrScript
			 input-methodDeclaration
			 output-methodDeclaration
			 input-scriptDeclaration
			 output-scriptDeclaration
			 input-formalList
			 output-formalList
			 input-returnType
			 output-returnType
			 input-implementation
			 output-implementation
			 input-returnKind
			 output-returnKind
			 input-expression
			 output-expression
			 input-ekind
			 output-ekind
			 input-object
			 output-object
			 input-field
			 output-field
			 input-fkind
			 output-fkind
			 input-actualParameterList
			 output-actualParameterList
			 input-externalMethod
			 output-externalMethod
			 input-internalMethod
			 output-internalMethod
			 input-statement
			 output-statement
			 input-letStatement
			 output-letStatement
			 input-mapStatement
			 output-mapStatement
			 input-exitMapStatement
			 output-exitMapStatement
			 input-setStatement
			 output-setStatement
			 input-createStatement
			 output-createStatement
			 input-ifStatement
			 output-ifStatement
			 input-loopStatement
			 output-loopStatement
			 input-exitWhenStatement
			 output-exitWhenStatement
			 input-returnStatement
			 output-returnStatement
			 input-callInternalStatement
			 output-callInternalStatement
			 input-callExternalStatement
			 output-callExternalStatement
			 input-varName
			 output-varName
			 input-filler
			 output-filler
			 input-maybeIndirectExpression
			 output-maybeIndirectExpression
			 input-thenPart
			 output-thenPart
			 input-elsePart
			 output-elsePart
			 input-functionReference
			 output-functionReference
			 input-indirectionKind
			 output-indirectionKind
			 ))

(defun check-stacks (p)
  (dolist (stack *stacks*)
    (let ((name (symbol-name stack)))
      (let ((sym (intern name "CL-USER")))
	(unless (zerop (length (stack-dsl::%stack (slot-value (env p) sym))))
	  (format *standard-output* "~&~a ~a~%" name (length (stack-dsl::%stack (slot-value (env p) sym)))))))))

