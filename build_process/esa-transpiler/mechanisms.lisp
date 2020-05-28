(in-package "ARROWGRAMS/ESA-TRANSPILER")

(defmethod $expression__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-expression (env p))))

(defmethod $expression__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-expression (env p)) (CL-USER::input-expression (env p)))
  (stack-dsl:%pop (CL-USER::input-expression (env p))))

(defmethod $expression__setField_ekind_from_ekind ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-ekind (env p)))))
    (stack-dsl:%ensure-field-type "expression" "ekind" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-expression (env p))) "ekind" val)
    (stack-dsl:%pop (CL-USER::output-ekind (env p)))))

(defmethod $expression__setField_object_from_object ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-object (env p)))))
    (stack-dsl:%ensure-field-type "expression" "object" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-expression (env p))) "object" val)
    (stack-dsl:%pop (CL-USER::output-object (env p)))))

(defmethod $ekind__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-ekind (env p))))

(defmethod $ekind__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-ekind (env p)) (CL-USER::input-ekind (env p)))
  (stack-dsl:%pop (CL-USER::input-ekind (env p))))

(defmethod $ekind__SetEnum_true ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-ekind (env p)))) "true"))

(defmethod $ekind__SetEnum_false ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-ekind (env p)))) "false"))

(defmethod $ekind__SetEnum_object ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-ekind (env p)))) "object"))

(defmethod $object__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-object (env p))))

(defmethod $object__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-object (env p)) (CL-USER::input-object (env p)))
  (stack-dsl:%pop (CL-USER::input-object (env p))))

(defmethod $object__setField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "object" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-object (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $object__setField_fieldMap_from_fieldMap ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-fieldMap (env p)))))
    (stack-dsl:%ensure-field-type "object" "fieldMap" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-object (env p))) "fieldMap" val)
    (stack-dsl:%pop (CL-USER::output-fieldMap (env p)))))

(defmethod $fieldMap__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-fieldMap (env p))))

(defmethod $fieldMap__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-fieldMap (env p)) (CL-USER::input-fieldMap (env p)))
  (stack-dsl:%pop (CL-USER::input-fieldMap (env p))))

(defmethod $fieldMap__AppendFrom_field ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-field (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-fieldMap (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-field (env p))))))

(defmethod $field__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-field (env p))))

(defmethod $field__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-field (env p)) (CL-USER::input-field (env p)))
  (stack-dsl:%pop (CL-USER::input-field (env p))))

(defmethod $field__setField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "field" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-field (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $field__setField_parameterList_from_parameterList ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-parameterList (env p)))))
    (stack-dsl:%ensure-field-type "field" "parameterList" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-field (env p))) "parameterList" val)
    (stack-dsl:%pop (CL-USER::output-parameterList (env p)))))

(defmethod $parameterList__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-parameterList (env p))))

(defmethod $parameterList__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-parameterList (env p)) (CL-USER::input-parameterList (env p)))
  (stack-dsl:%pop (CL-USER::input-parameterList (env p))))

(defmethod $parameterList__AppendFrom_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-parameterList (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-name (env p))))))

(defmethod $name__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-name (env p))))

(defmethod $name__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-name (env p)) (CL-USER::input-name (env p)))
  (stack-dsl:%pop (CL-USER::input-name (env p))))

(defmethod $esaclass__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-esaclass (env p))))

(defmethod $esaclass__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-esaclass (env p)) (CL-USER::input-esaclass (env p)))
  (stack-dsl:%pop (CL-USER::input-esaclass (env p))))

(defmethod $esaclass__setField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "esaclass" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-esaclass (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

