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

(defmethod $expr__NewScope ((p parser))
  (stack-dsl:%push-empty (cl-user::input-expression (env p))))

(defmethod $expr__SetKindTrue ((p parser))
  (stack-dsl:%ensure-field-type "expression" "kind" "true")
  (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-expression (env p))) "kind" "true"))
(defmethod $expr__SetKindFalse ((p parser))
  (stack-dsl:%ensure-field-type "expression" "kind" "false")
  (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-expression (env p))) "kind" "false"))
(defmethod $expr__SetKindObject ((p parser))
  (stack-dsl:%ensure-field-type "expression" "kind" "object")
  (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-expression (env p))) "kind" "object"))

(defmethod $expr__setField_object_from_object ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-object (env p)))))
    (stack-dsl:%ensure-field-type "expression" "object" val)
    (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-expression (env p))) "object" val)
    (stack-dsl:%pop (cl-user::output-object (env p)))))
  
(defmethod $expr__Output ((p parser))
  (stack-dsl:%output (cl-user::output-expression (env p)) (cl-user::input-expression (env p)))
  (stack-dsl:%pop (cl-user::input-expression (env p))))

(defmethod $expr__Emit ((p parser))
  (break (stack-dsl:%top (cl-user::output-expression (env p))))
  (stack-dsl:%pop (cl-user::output-expression (env p))))

;; name 
(defmethod $name__NewScope ((self arrowgrams/esa-transpiler::parser))
  (stack-dsl:%push-empty (cl-user::input-name (env self))))

(defmethod $name__GetName ((self arrowgrams/esa-transpiler::parser))
  ;; put accepted symbol name onto input stack of "name" (replace top of name stack)
  (let ((str (scanner:token-text (pasm:accepted-token self)))
	(name-object (make-instance (stack-dsl:lisp-sym "name"))))
    (setf (stack-dsl:%value name-object) str)
    ;; 2 steps to replace top of name stack (pop then push)
    (stack-dsl:%pop (cl-user::input-name (env self)))
    (stack-dsl:%push (cl-user::input-name (env self)) name-object)))

(defmethod $name__combine ((p parser))
  (let ((name-tos (stack-dsl:%top (cl-user::input-name (env p)))))
    (let ((suffix (string (scanner:token-text (pasm:accepted-token p)))))
      (let ((new-text (concatenate 'string (stack-dsl:%value name-tos) suffix)))
	(setf (stack-dsl:%value name-tos) new-text)))))

(defmethod $name__Output ((self arrowgrams/esa-transpiler::parser))
  (stack-dsl:%output (cl-user::output-name (env self)) (cl-user::input-name (env self)))
  (stack-dsl:%pop (cl-user::input-name (env self))))

;; object
(defmethod $object__NewScope ((self arrowgrams/esa-transpiler::parser))
  (stack-dsl:%push-empty (cl-user::input-object (env self))))

(defmethod $object__Output ((self arrowgrams/esa-transpiler::parser))
  (stack-dsl:%output (cl-user::output-object (env self)) (cl-user::input-object (env self)))
  (stack-dsl:%pop (cl-user::input-object (env self))))

(defmethod $object__setField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-name (env p)))))
    (stack-dsl:%ensure-field-type
     "object"
     "name"
     val)
    (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-object (env p))) "name" val)
    (stack-dsl:%pop (cl-user::output-name (env p)))))

(defmethod $object__setField_fieldMap_from_fieldMap ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-fieldMap (env p)))))
    (stack-dsl:%ensure-field-type
     "object"
     "fieldMap"
     val)
    (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-fieldMap (env p))) "fieldMap" val)
    (stack-dsl:%pop (cl-user::output-fieldMap (env p)))))



;; fieldMap
(defmethod $fieldMap__NewScope ((p parser))
  (stack-dsl:%push-empty (cl-user::input-object (env self))))

(defmethod $fieldMap_append_from_field ((p parser))
)

;; field
(defmethod $field__NewScope ((p parser))
  )
