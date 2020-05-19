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

(defmethod $expression__NewScope ((p parser))
  (stack-dsl:%push-empty (cl-user::input-expression (env p))))

(defmethod $expression__setField_ekind_from_ekind ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-ekind (env p)))))
    (stack-dsl:%ensure-field-type "expression" "ekind" val)
    (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-expression (env p))) "ekind" val)
    (stack-dsl:%pop (cl-user::output-ekind (env p)))))

(defmethod $expression__setField_object_from_object ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-object (env p)))))
    (stack-dsl:%ensure-field-type "expression" "object" val)
    (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-expression (env p))) "object" val)
    (stack-dsl:%pop (cl-user::output-object (env p)))))

(defmethod $expression__Output ((p parser))
  (stack-dsl:%output (cl-user::output-expression (env p)) (cl-user::input-expression (env p)))
  (stack-dsl:%pop (cl-user::input-expression (env p))))

(defmethod $expression__Emit ((p parser))
  (break (stack-dsl:%top (cl-user::output-expression (env p))))
  (stack-dsl:%pop (cl-user::output-expression (env p))))

;; ekind
(defmethod $ekind__NewScope ((p parser))
  (stack-dsl:%push-empty (cl-user::input-ekind (env p))))

(defmethod $ekind__Output ((p parser))
  (stack-dsl:%output (cl-user::output-ekind (env p))
		     (cl-user::input-ekind  (env p)))
  (stack-dsl:%pop (cl-user::input-ekind (env p))))

(defmethod $ekind__SetEnum_true ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (cl-user::input-ekind (env p)))) "true"))
(defmethod $ekind__SetEnum_false ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (cl-user::input-ekind (env p)))) "false"))
(defmethod $ekind__SetEnum_object ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (cl-user::input-ekind (env p)))) "object"))

;; name 
(defmethod $name__NewScope ((p arrowgrams/esa-transpiler::parser))
  (stack-dsl:%push-empty (cl-user::input-name (env p))))

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

(defmethod $name__Output ((p arrowgrams/esa-transpiler::parser))
  (stack-dsl:%output (cl-user::output-name (env p)) (cl-user::input-name (env p)))
  (stack-dsl:%pop (cl-user::input-name (env p))))

;; object
(defmethod $object__NewScope ((p arrowgrams/esa-transpiler::parser))
  (stack-dsl:%push-empty (cl-user::input-object (env p))))

(defmethod $object__Output ((p arrowgrams/esa-transpiler::parser))
  (stack-dsl:%output (cl-user::output-object (env p)) (cl-user::input-object (env p)))
  (stack-dsl:%pop (cl-user::input-object (env p))))

(defmethod $object__setField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-name (env p)))))
    (stack-dsl:%ensure-field-type
     "object"
     "name"
     val)
    (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-object (env p))) "name" val)
    (stack-dsl:%pop (cl-user::output-name (env p)))))

(defmethod $object__setField_parameterList_from_parameterList ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-parameterList (env p)))))
    (stack-dsl:%ensure-field-type
     "object"
     "parameterList"
     val)
    (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-object (env p))) "parameterList" val)
    (stack-dsl:%pop (cl-user::output-parameterList (env p)))))

(defmethod $object__setField_field_from_field ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-field (env p)))))
    (stack-dsl:%ensure-field-type
     "object"
     "field"
     val)
    (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-object (env p))) "field" val)
    (stack-dsl:%pop (cl-user::output-field (env p)))))


;; field
(defmethod $field__NewScope ((p parser))
  (stack-dsl:%push-empty (cl-user::input-field (env p))))

(defmethod $field__Output ((p parser))
  (stack-dsl:%output (cl-user::output-field (env p)) (cl-user::input-field (env p)))
  (stack-dsl:%pop (cl-user::input-field (env p))))

(defmethod $field__CoerceFrom_empty ((p parser))
  ;; push tos(empty) onto field, pop(empty)
  (let ((val (stack-dsl:%top (cl-user::output-empty (env p)))))
    (stack-dsl:%ensure-type "field" val)
    (stack-dsl:%push (cl-user::input-field (env p)) val)
    (stack-dsl:%pop (cl-user::output-empty (env p)))))

(defmethod $field__CoerceFrom_object ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-object (env p)))))
    (stack-dsl:%ensure-type "field" val)
    (stack-dsl:%push (cl-user::input-field (env p)) val)
    (stack-dsl:%pop (cl-user::output-object (env p)))))

;; parameterList
(defmethod $parameterList__NewScope ((p parser))
  (stack-dsl:%push-empty (cl-user::input-parameterList (env p))))

(defmethod $parameterList__Output ((p parser))
  (stack-dsl:%output (cl-user::output-parameterList (env p)) (cl-user::input-parameterList (env p)))
  (stack-dsl:%pop (cl-user::input-parameterList (env p))))

(defmethod $parameterList__CoerceFrom_empty ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-empty (env p)))))
    (stack-dsl:%ensure-type "parameterList" val)
    (stack-dsl:%push (cl-user::input-parameterList (env p)) val)
    (stack-dsl:%pop (cl-user::output-empty (env p)))))

(defmethod $parameterList__CoerceFrom_nameList ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-nameList (env p)))))
    (stack-dsl:%ensure-type "parameterList" val)
    (stack-dsl:%push (cl-user::input-parameterList (env p)) val)
    (stack-dsl:%pop (cl-user::output-nameList (env p)))))

;; nameList
(defmethod $nameList__NewScope ((p parser))
  (stack-dsl:%push-empty (cl-user::input-nameList (env p))))

(defmethod $nameList__Output ((p parser))
  (stack-dsl:%output (cl-user::output-nameList (env p)) (cl-user::input-nameList (env p)))
  (stack-dsl:%pop (cl-user::input-nameList (env p))))

(defmethod $nameList__AppendFrom_name ((p parser))
  (let ((val (stack-dsl:%top (cl-user::output-name (env p)))))
    (stack-dsl:%ensure-appendable-type (cl-user::input-nameList (env p)))
    (stack-dsl:%ensure-type (stack-dsl:%element-type 
			     (stack-dsl:%top (cl-user::input-nameList (env p))))
			    val)
    (stack-dsl::%append (stack-dsl:%top (cl-user::input-nameList (env p))) val)
    (stack-dsl:%pop (cl-user::output-name (env p)))))

;; empty
(defmethod $empty__NewScope ((p parser))
  (stack-dsl:%push-empty (cl-user::input-empty (env p))))

(defmethod $empty__Output ((p parser))
  (stack-dsl:%output (cl-user::output-empty (env p)) (cl-user::input-empty (env p)))
  (stack-dsl:%pop (cl-user::input-empty (env p))))
