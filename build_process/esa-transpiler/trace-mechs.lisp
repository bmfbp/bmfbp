(in-package :arrowgrams/esa-transpiler)
(defun trace-mechs ()
(trace $expression__NewScope)
(trace $expression__Output)
(trace $expression__setField_ekind_from_ekind)
(trace $expression__setField_object_from_object)
(trace $ekind__NewScope)
(trace $ekind__Output)
(trace $ekind__SetEnum_true)
(trace $ekind__SetEnum_false)
(trace $ekind__SetEnum_object)
(trace $object__NewScope)
(trace $object__Output)
(trace $object__setField_name_from_name)
(trace $object__setField_fieldMap_from_fieldMap)
(trace $fieldMap__NewScope)
(trace $fieldMap__Output)
(trace $fieldMap__AppendFrom_field)
(trace $field__NewScope)
(trace $field__Output)
(trace $field__setField_name_from_name)
(trace $field__setField_parameterList_from_parameterList)
(trace $parameterList__NewScope)
(trace $parameterList__Output)
(trace $parameterList__AppendFrom_name)
(trace $name__NewScope)
(trace $name__Output)
)