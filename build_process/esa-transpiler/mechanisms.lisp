(in-package arrowgrams/esa-transpiler)

(defmethod $expression__NewScope ((p parser))
  stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-expression (env p)))

(defmethod $expression__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-expression (env p)) (arrowgrams/esa-transpiler::input-expression (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-expression (env p))))

(defmethod $expression__setField_ekind_from_ekind ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-ekind (env p)))))
    (stack-dsl:%ensure-field-type "expression" "ekind" val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-expression (env p))) "ekind" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-ekind (env p)))))

(defmethod $expression__setField_object_from_object ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-object (env p)))))
    (stack-dsl:%ensure-field-type "expression" "object" val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-expression (env p))) "object" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-object (env p)))))

(defmethod $ekind__NewScope ((p parser))
  stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-ekind (env p)))

(defmethod $ekind__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-ekind (env p)) (arrowgrams/esa-transpiler::input-ekind (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-ekind (env p))))

(defmethod $_SetEnum_ekind ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (arrowgrams/esa-transpiler::input-ekind (env p)))) "true"))

(defmethod $_SetEnum_ekind ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (arrowgrams/esa-transpiler::input-ekind (env p)))) "false"))

(defmethod $_SetEnum_ekind ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (arrowgrams/esa-transpiler::input-ekind (env p)))) "object"))

(defmethod $object__NewScope ((p parser))
  stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-object (env p)))

(defmethod $object__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-object (env p)) (arrowgrams/esa-transpiler::input-object (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-object (env p))))

(defmethod $object__setField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-name (env p)))))
    (stack-dsl:%ensure-field-type "object" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-object (env p))) "name" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-name (env p)))))

(defmethod $object__setField_fieldMap_from_fieldMap ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-fieldMap (env p)))))
    (stack-dsl:%ensure-field-type "object" "fieldMap" val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-object (env p))) "fieldMap" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-fieldMap (env p)))))

(defmethod $fieldMap__NewScope ((p parser))
  stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-fieldMap (env p)))

(defmethod $fieldMap__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-fieldMap (env p)) (arrowgrams/esa-transpiler::input-fieldMap (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-fieldMap (env p))))

(defmethod $fieldMap__AppendFrom_field ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-field (env p)))))
    (stack-dsl:%ensure-appendable-type (arrowgrams/esa-transpiler::input-fieldMap (env p)))
    (stack-dsl:%ensure-type (stack-dsl:%element-type 
			     (stack-dsl:%top (arrowgrams/esa-transpiler::input-fieldMap (env p))))
			    val)
    (stack-dsl::%append (stack-dsl:%top (arrowgrams/esa-transpiler::input-fieldMap (env p))) val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-field (env p)))))

(defmethod $field__NewScope ((p parser))
  stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-field (env p)))

(defmethod $field__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-field (env p)) (arrowgrams/esa-transpiler::input-field (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-field (env p))))

(defmethod $field__setField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-name (env p)))))
    (stack-dsl:%ensure-field-type "field" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-field (env p))) "name" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-name (env p)))))

(defmethod $field__setField_parameterList_from_parameterList ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-parameterList (env p)))))
    (stack-dsl:%ensure-field-type "field" "parameterList" val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-field (env p))) "parameterList" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-parameterList (env p)))))

(defmethod $parameterList__NewScope ((p parser))
  stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-parameterList (env p)))

(defmethod $parameterList__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-parameterList (env p)) (arrowgrams/esa-transpiler::input-parameterList (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-parameterList (env p))))

(defmethod $parameterList__CoerceFrom_nameMap ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-nameMap (env p)))))
   (stack-dsl:%ensure-type "parameterList" val)
   (stack-dsl:%push (arrowgrams/esa-transpiler::input-parameterList (env p)) val)
   (stack-dsl:%pop (arrowgrams/esa-transpiler::output-nameMap (env p)))))

(defmethod $nameMap__NewScope ((p parser))
  stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-nameMap (env p)))

(defmethod $nameMap__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-nameMap (env p)) (arrowgrams/esa-transpiler::input-nameMap (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-nameMap (env p))))

(defmethod $nameMap__AppendFrom_name ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-name (env p)))))
    (stack-dsl:%ensure-appendable-type (arrowgrams/esa-transpiler::input-nameMap (env p)))
    (stack-dsl:%ensure-type (stack-dsl:%element-type 
			     (stack-dsl:%top (arrowgrams/esa-transpiler::input-nameMap (env p))))
			    val)
    (stack-dsl::%append (stack-dsl:%top (arrowgrams/esa-transpiler::input-nameMap (env p))) val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-name (env p)))))

(defmethod $name__NewScope ((p parser))
  stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-name (env p)))

(defmethod $name__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-name (env p)) (arrowgrams/esa-transpiler::input-name (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-name (env p))))

