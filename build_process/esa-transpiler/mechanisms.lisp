(proclaim '(optimize (debug 3) (safety 3) (speed 0)))(in-package "ARROWGRAMS/ESA-TRANSPILER")

(defmethod $esaprogram__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-esaprogram (env p))))

(defmethod $esaprogram__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-esaprogram (env p)) (CL-USER::input-esaprogram (env p)))
  (stack-dsl:%pop (CL-USER::input-esaprogram (env p))))

(defmethod $esaprogram__SetField_typeDecls_from_typeDecls ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-typeDecls (env p)))))
    (stack-dsl:%ensure-field-type "esaprogram" "typeDecls" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-esaprogram (env p))) "typeDecls" val)
    (stack-dsl:%pop (CL-USER::output-typeDecls (env p)))))

(defmethod $esaprogram__SetField_situations_from_situations ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-situations (env p)))))
    (stack-dsl:%ensure-field-type "esaprogram" "situations" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-esaprogram (env p))) "situations" val)
    (stack-dsl:%pop (CL-USER::output-situations (env p)))))

(defmethod $esaprogram__SetField_classes_from_classes ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-classes (env p)))))
    (stack-dsl:%ensure-field-type "esaprogram" "classes" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-esaprogram (env p))) "classes" val)
    (stack-dsl:%pop (CL-USER::output-classes (env p)))))

(defmethod $esaprogram__SetField_whenDeclarations_from_whenDeclarations ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-whenDeclarations (env p)))))
    (stack-dsl:%ensure-field-type "esaprogram" "whenDeclarations" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-esaprogram (env p))) "whenDeclarations" val)
    (stack-dsl:%pop (CL-USER::output-whenDeclarations (env p)))))

(defmethod $typeDecls__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-typeDecls (env p))))

(defmethod $typeDecls__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-typeDecls (env p)) (CL-USER::input-typeDecls (env p)))
  (stack-dsl:%pop (CL-USER::input-typeDecls (env p))))

(defmethod $typeDecls__AppendFrom_typeDecl ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-typeDecl (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-typeDecls (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-typeDecl (env p))))))

(defmethod $situations__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-situations (env p))))

(defmethod $situations__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-situations (env p)) (CL-USER::input-situations (env p)))
  (stack-dsl:%pop (CL-USER::input-situations (env p))))

(defmethod $situations__AppendFrom_situationDefinition ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-situationDefinition (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-situations (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-situationDefinition (env p))))))

(defmethod $classes__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-classes (env p))))

(defmethod $classes__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-classes (env p)) (CL-USER::input-classes (env p)))
  (stack-dsl:%pop (CL-USER::input-classes (env p))))

(defmethod $classes__AppendFrom_esaclass ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-esaclass (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-classes (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-esaclass (env p))))))

(defmethod $whenDeclarations__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-whenDeclarations (env p))))

(defmethod $whenDeclarations__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-whenDeclarations (env p)) (CL-USER::input-whenDeclarations (env p)))
  (stack-dsl:%pop (CL-USER::input-whenDeclarations (env p))))

(defmethod $whenDeclarations__AppendFrom_whenDeclaration ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-whenDeclaration (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-whenDeclarations (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-whenDeclaration (env p))))))

(defmethod $typeDecl__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-typeDecl (env p))))

(defmethod $typeDecl__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-typeDecl (env p)) (CL-USER::input-typeDecl (env p)))
  (stack-dsl:%pop (CL-USER::input-typeDecl (env p))))

(defmethod $typeDecl__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "typeDecl" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-typeDecl (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $typeDecl__SetField_typeName_from_typeName ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-typeName (env p)))))
    (stack-dsl:%ensure-field-type "typeDecl" "typeName" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-typeDecl (env p))) "typeName" val)
    (stack-dsl:%pop (CL-USER::output-typeName (env p)))))

(defmethod $situationDefinition__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-situationDefinition (env p))))

(defmethod $situationDefinition__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-situationDefinition (env p)) (CL-USER::input-situationDefinition (env p)))
  (stack-dsl:%pop (CL-USER::input-situationDefinition (env p))))

(defmethod $situationDefinition__CoerceFrom_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
   (stack-dsl:%ensure-type "situationDefinition" val)
   (stack-dsl:%set-top (CL-USER::input-situationDefinition (env p)) val)
   (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $esaclass__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-esaclass (env p))))

(defmethod $esaclass__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-esaclass (env p)) (CL-USER::input-esaclass (env p)))
  (stack-dsl:%pop (CL-USER::input-esaclass (env p))))

(defmethod $esaclass__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "esaclass" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-esaclass (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $esaclass__SetField_fieldMap_from_fieldMap ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-fieldMap (env p)))))
    (stack-dsl:%ensure-field-type "esaclass" "fieldMap" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-esaclass (env p))) "fieldMap" val)
    (stack-dsl:%pop (CL-USER::output-fieldMap (env p)))))

(defmethod $esaclass__SetField_methodsTable_from_methodsTable ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-methodsTable (env p)))))
    (stack-dsl:%ensure-field-type "esaclass" "methodsTable" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-esaclass (env p))) "methodsTable" val)
    (stack-dsl:%pop (CL-USER::output-methodsTable (env p)))))

(defmethod $whenDeclaration__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-whenDeclaration (env p))))

(defmethod $whenDeclaration__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-whenDeclaration (env p)) (CL-USER::input-whenDeclaration (env p)))
  (stack-dsl:%pop (CL-USER::input-whenDeclaration (env p))))

(defmethod $whenDeclaration__SetField_situationReferenceList_from_situationReferenceList ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-situationReferenceList (env p)))))
    (stack-dsl:%ensure-field-type "whenDeclaration" "situationReferenceList" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-whenDeclaration (env p))) "situationReferenceList" val)
    (stack-dsl:%pop (CL-USER::output-situationReferenceList (env p)))))

(defmethod $whenDeclaration__SetField_esaKind_from_esaKind ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-esaKind (env p)))))
    (stack-dsl:%ensure-field-type "whenDeclaration" "esaKind" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-whenDeclaration (env p))) "esaKind" val)
    (stack-dsl:%pop (CL-USER::output-esaKind (env p)))))

(defmethod $whenDeclaration__SetField_methodDeclarationsAndScriptDeclarations_from_methodDeclarationsAndScriptDeclarations ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-methodDeclarationsAndScriptDeclarations (env p)))))
    (stack-dsl:%ensure-field-type "whenDeclaration" "methodDeclarationsAndScriptDeclarations" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-whenDeclaration (env p))) "methodDeclarationsAndScriptDeclarations" val)
    (stack-dsl:%pop (CL-USER::output-methodDeclarationsAndScriptDeclarations (env p)))))

(defmethod $situationReferenceList__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-situationReferenceList (env p))))

(defmethod $situationReferenceList__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-situationReferenceList (env p)) (CL-USER::input-situationReferenceList (env p)))
  (stack-dsl:%pop (CL-USER::input-situationReferenceList (env p))))

(defmethod $situationReferenceList__AppendFrom_situationReferenceName ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-situationReferenceName (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-situationReferenceList (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-situationReferenceName (env p))))))

(defmethod $situationReferenceName__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-situationReferenceName (env p))))

(defmethod $situationReferenceName__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-situationReferenceName (env p)) (CL-USER::input-situationReferenceName (env p)))
  (stack-dsl:%pop (CL-USER::input-situationReferenceName (env p))))

(defmethod $situationReferenceName__CoerceFrom_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
   (stack-dsl:%ensure-type "situationReferenceName" val)
   (stack-dsl:%set-top (CL-USER::input-situationReferenceName (env p)) val)
   (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $methodDeclarationsAndScriptDeclarations__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-methodDeclarationsAndScriptDeclarations (env p))))

(defmethod $methodDeclarationsAndScriptDeclarations__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-methodDeclarationsAndScriptDeclarations (env p)) (CL-USER::input-methodDeclarationsAndScriptDeclarations (env p)))
  (stack-dsl:%pop (CL-USER::input-methodDeclarationsAndScriptDeclarations (env p))))

(defmethod $methodDeclarationsAndScriptDeclarations__AppendFrom_declarationMethodOrScript ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-declarationMethodOrScript (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-methodDeclarationsAndScriptDeclarations (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-declarationMethodOrScript (env p))))))

(defmethod $declarationMethodOrScript__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-declarationMethodOrScript (env p))))

(defmethod $declarationMethodOrScript__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-declarationMethodOrScript (env p)) (CL-USER::input-declarationMethodOrScript (env p)))
  (stack-dsl:%pop (CL-USER::input-declarationMethodOrScript (env p))))

(defmethod $declarationMethodOrScript__CoerceFrom_methodDeclaration ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-methodDeclaration (env p)))))
   (stack-dsl:%ensure-type "declarationMethodOrScript" val)
   (stack-dsl:%set-top (CL-USER::input-declarationMethodOrScript (env p)) val)
   (stack-dsl:%pop (CL-USER::output-methodDeclaration (env p)))))

(defmethod $declarationMethodOrScript__CoerceFrom_scriptDeclaration ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-scriptDeclaration (env p)))))
   (stack-dsl:%ensure-type "declarationMethodOrScript" val)
   (stack-dsl:%set-top (CL-USER::input-declarationMethodOrScript (env p)) val)
   (stack-dsl:%pop (CL-USER::output-scriptDeclaration (env p)))))

(defmethod $methodDeclaration__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-methodDeclaration (env p))))

(defmethod $methodDeclaration__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-methodDeclaration (env p)) (CL-USER::input-methodDeclaration (env p)))
  (stack-dsl:%pop (CL-USER::input-methodDeclaration (env p))))

(defmethod $methodDeclaration__SetField_esaKind_from_esaKind ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-esaKind (env p)))))
    (stack-dsl:%ensure-field-type "methodDeclaration" "esaKind" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-methodDeclaration (env p))) "esaKind" val)
    (stack-dsl:%pop (CL-USER::output-esaKind (env p)))))

(defmethod $methodDeclaration__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "methodDeclaration" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-methodDeclaration (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $methodDeclaration__SetField_formalList_from_formalList ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-formalList (env p)))))
    (stack-dsl:%ensure-field-type "methodDeclaration" "formalList" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-methodDeclaration (env p))) "formalList" val)
    (stack-dsl:%pop (CL-USER::output-formalList (env p)))))

(defmethod $methodDeclaration__SetField_returnType_from_returnType ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-returnType (env p)))))
    (stack-dsl:%ensure-field-type "methodDeclaration" "returnType" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-methodDeclaration (env p))) "returnType" val)
    (stack-dsl:%pop (CL-USER::output-returnType (env p)))))

(defmethod $scriptDeclaration__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-scriptDeclaration (env p))))

(defmethod $scriptDeclaration__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-scriptDeclaration (env p)) (CL-USER::input-scriptDeclaration (env p)))
  (stack-dsl:%pop (CL-USER::input-scriptDeclaration (env p))))

(defmethod $scriptDeclaration__SetField_esaKind_from_esaKind ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-esaKind (env p)))))
    (stack-dsl:%ensure-field-type "scriptDeclaration" "esaKind" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-scriptDeclaration (env p))) "esaKind" val)
    (stack-dsl:%pop (CL-USER::output-esaKind (env p)))))

(defmethod $scriptDeclaration__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "scriptDeclaration" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-scriptDeclaration (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $scriptDeclaration__SetField_formalList_from_formalList ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-formalList (env p)))))
    (stack-dsl:%ensure-field-type "scriptDeclaration" "formalList" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-scriptDeclaration (env p))) "formalList" val)
    (stack-dsl:%pop (CL-USER::output-formalList (env p)))))

(defmethod $scriptDeclaration__SetField_returnType_from_returnType ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-returnType (env p)))))
    (stack-dsl:%ensure-field-type "scriptDeclaration" "returnType" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-scriptDeclaration (env p))) "returnType" val)
    (stack-dsl:%pop (CL-USER::output-returnType (env p)))))

(defmethod $scriptDeclaration__SetField_implementation_from_implementation ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-implementation (env p)))))
    (stack-dsl:%ensure-field-type "scriptDeclaration" "implementation" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-scriptDeclaration (env p))) "implementation" val)
    (stack-dsl:%pop (CL-USER::output-implementation (env p)))))

(defmethod $returnType__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-returnType (env p))))

(defmethod $returnType__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-returnType (env p)) (CL-USER::input-returnType (env p)))
  (stack-dsl:%pop (CL-USER::input-returnType (env p))))

(defmethod $returnType__SetField_returnKind_from_returnKind ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-returnKind (env p)))))
    (stack-dsl:%ensure-field-type "returnType" "returnKind" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-returnType (env p))) "returnKind" val)
    (stack-dsl:%pop (CL-USER::output-returnKind (env p)))))

(defmethod $returnType__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "returnType" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-returnType (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $returnKind__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-returnKind (env p))))

(defmethod $returnKind__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-returnKind (env p)) (CL-USER::input-returnKind (env p)))
  (stack-dsl:%pop (CL-USER::input-returnKind (env p))))

(defmethod $returnKind__SetEnum_map ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-returnKind (env p)))) "map"))

(defmethod $returnKind__SetEnum_simple ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-returnKind (env p)))) "simple"))

(defmethod $returnKind__SetEnum_void ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-returnKind (env p)))) "void"))

(defmethod $formalList__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-formalList (env p))))

(defmethod $formalList__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-formalList (env p)) (CL-USER::input-formalList (env p)))
  (stack-dsl:%pop (CL-USER::input-formalList (env p))))

(defmethod $formalList__AppendFrom_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-formalList (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-name (env p))))))

(defmethod $esaKind__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-esaKind (env p))))

(defmethod $esaKind__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-esaKind (env p)) (CL-USER::input-esaKind (env p)))
  (stack-dsl:%pop (CL-USER::input-esaKind (env p))))

(defmethod $esaKind__CoerceFrom_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
   (stack-dsl:%ensure-type "esaKind" val)
   (stack-dsl:%set-top (CL-USER::input-esaKind (env p)) val)
   (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $typeName__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-typeName (env p))))

(defmethod $typeName__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-typeName (env p)) (CL-USER::input-typeName (env p)))
  (stack-dsl:%pop (CL-USER::input-typeName (env p))))

(defmethod $typeName__CoerceFrom_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
   (stack-dsl:%ensure-type "typeName" val)
   (stack-dsl:%set-top (CL-USER::input-typeName (env p)) val)
   (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $expression__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-expression (env p))))

(defmethod $expression__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-expression (env p)) (CL-USER::input-expression (env p)))
  (stack-dsl:%pop (CL-USER::input-expression (env p))))

(defmethod $expression__SetField_ekind_from_ekind ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-ekind (env p)))))
    (stack-dsl:%ensure-field-type "expression" "ekind" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-expression (env p))) "ekind" val)
    (stack-dsl:%pop (CL-USER::output-ekind (env p)))))

(defmethod $expression__SetField_object_from_object ((p parser))
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

(defmethod $ekind__SetEnum_calledObject ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-ekind (env p)))) "calledObject"))

(defmethod $object__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-object (env p))))

(defmethod $object__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-object (env p)) (CL-USER::input-object (env p)))
  (stack-dsl:%pop (CL-USER::input-object (env p))))

(defmethod $object__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "object" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-object (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $object__SetField_fieldMap_from_fieldMap ((p parser))
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

(defmethod $field__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "field" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-field (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $field__SetField_fkind_from_fkind ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-fkind (env p)))))
    (stack-dsl:%ensure-field-type "field" "fkind" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-field (env p))) "fkind" val)
    (stack-dsl:%pop (CL-USER::output-fkind (env p)))))

(defmethod $field__SetField_actualParameterList_from_actualParameterList ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-actualParameterList (env p)))))
    (stack-dsl:%ensure-field-type "field" "actualParameterList" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-field (env p))) "actualParameterList" val)
    (stack-dsl:%pop (CL-USER::output-actualParameterList (env p)))))

(defmethod $fkind__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-fkind (env p))))

(defmethod $fkind__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-fkind (env p)) (CL-USER::input-fkind (env p)))
  (stack-dsl:%pop (CL-USER::input-fkind (env p))))

(defmethod $fkind__SetEnum_map ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-fkind (env p)))) "map"))

(defmethod $fkind__SetEnum_simple ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-fkind (env p)))) "simple"))

(defmethod $actualParameterList__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-actualParameterList (env p))))

(defmethod $actualParameterList__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-actualParameterList (env p)) (CL-USER::input-actualParameterList (env p)))
  (stack-dsl:%pop (CL-USER::input-actualParameterList (env p))))

(defmethod $actualParameterList__AppendFrom_expression ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-expression (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-actualParameterList (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-expression (env p))))))

(defmethod $name__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-name (env p))))

(defmethod $name__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-name (env p)) (CL-USER::input-name (env p)))
  (stack-dsl:%pop (CL-USER::input-name (env p))))

(defmethod $methodsTable__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-methodsTable (env p))))

(defmethod $methodsTable__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-methodsTable (env p)) (CL-USER::input-methodsTable (env p)))
  (stack-dsl:%pop (CL-USER::input-methodsTable (env p))))

(defmethod $methodsTable__AppendFrom_declarationMethodOrScript ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-declarationMethodOrScript (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-methodsTable (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-declarationMethodOrScript (env p))))))

(defmethod $externalMethod__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-externalMethod (env p))))

(defmethod $externalMethod__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-externalMethod (env p)) (CL-USER::input-externalMethod (env p)))
  (stack-dsl:%pop (CL-USER::input-externalMethod (env p))))

(defmethod $externalMethod__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "externalMethod" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-externalMethod (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $externalMethod__SetField_formalList_from_formalList ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-formalList (env p)))))
    (stack-dsl:%ensure-field-type "externalMethod" "formalList" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-externalMethod (env p))) "formalList" val)
    (stack-dsl:%pop (CL-USER::output-formalList (env p)))))

(defmethod $externalMethod__SetField_returnType_from_returnType ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-returnType (env p)))))
    (stack-dsl:%ensure-field-type "externalMethod" "returnType" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-externalMethod (env p))) "returnType" val)
    (stack-dsl:%pop (CL-USER::output-returnType (env p)))))

(defmethod $internalMethod__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-internalMethod (env p))))

(defmethod $internalMethod__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-internalMethod (env p)) (CL-USER::input-internalMethod (env p)))
  (stack-dsl:%pop (CL-USER::input-internalMethod (env p))))

(defmethod $internalMethod__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "internalMethod" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-internalMethod (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $internalMethod__SetField_formalList_from_formalList ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-formalList (env p)))))
    (stack-dsl:%ensure-field-type "internalMethod" "formalList" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-internalMethod (env p))) "formalList" val)
    (stack-dsl:%pop (CL-USER::output-formalList (env p)))))

(defmethod $internalMethod__SetField_returnType_from_returnType ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-returnType (env p)))))
    (stack-dsl:%ensure-field-type "internalMethod" "returnType" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-internalMethod (env p))) "returnType" val)
    (stack-dsl:%pop (CL-USER::output-returnType (env p)))))

(defmethod $internalMethod__SetField_implementation_from_implementation ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-implementation (env p)))))
    (stack-dsl:%ensure-field-type "internalMethod" "implementation" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-internalMethod (env p))) "implementation" val)
    (stack-dsl:%pop (CL-USER::output-implementation (env p)))))

(defmethod $implementation__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-implementation (env p))))

(defmethod $implementation__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-implementation (env p)) (CL-USER::input-implementation (env p)))
  (stack-dsl:%pop (CL-USER::input-implementation (env p))))

(defmethod $implementation__AppendFrom_statement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-statement (env p)))))
    (let ((dest (stack-dsl:%top (CL-USER::input-implementation (env p)))))
      (stack-dsl:%ensure-appendable-type dest)
      (stack-dsl:%ensure-type (stack-dsl:%element-type dest) val)
      (stack-dsl::%append dest val)
      (stack-dsl:%pop (CL-USER::output-statement (env p))))))

(defmethod $statement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-statement (env p))))

(defmethod $statement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-statement (env p)) (CL-USER::input-statement (env p)))
  (stack-dsl:%pop (CL-USER::input-statement (env p))))

(defmethod $statement__CoerceFrom_letStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-letStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-letStatement (env p)))))

(defmethod $statement__CoerceFrom_mapStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-mapStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-mapStatement (env p)))))

(defmethod $statement__CoerceFrom_exitMapStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-exitMapStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-exitMapStatement (env p)))))

(defmethod $statement__CoerceFrom_setStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-setStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-setStatement (env p)))))

(defmethod $statement__CoerceFrom_createStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-createStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-createStatement (env p)))))

(defmethod $statement__CoerceFrom_ifStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-ifStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-ifStatement (env p)))))

(defmethod $statement__CoerceFrom_loopStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-loopStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-loopStatement (env p)))))

(defmethod $statement__CoerceFrom_exitWhenStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-exitWhenStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-exitWhenStatement (env p)))))

(defmethod $statement__CoerceFrom_callInternalStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-callInternalStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-callInternalStatement (env p)))))

(defmethod $statement__CoerceFrom_callExternalStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-callExternalStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-callExternalStatement (env p)))))

(defmethod $statement__CoerceFrom_returnTrueStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-returnTrueStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-returnTrueStatement (env p)))))

(defmethod $statement__CoerceFrom_returnFalseStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-returnFalseStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-returnFalseStatement (env p)))))

(defmethod $statement__CoerceFrom_returnValueStatement ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-returnValueStatement (env p)))))
   (stack-dsl:%ensure-type "statement" val)
   (stack-dsl:%set-top (CL-USER::input-statement (env p)) val)
   (stack-dsl:%pop (CL-USER::output-returnValueStatement (env p)))))

(defmethod $letStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-letStatement (env p))))

(defmethod $letStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-letStatement (env p)) (CL-USER::input-letStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-letStatement (env p))))

(defmethod $letStatement__SetField_varName_from_varName ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-varName (env p)))))
    (stack-dsl:%ensure-field-type "letStatement" "varName" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-letStatement (env p))) "varName" val)
    (stack-dsl:%pop (CL-USER::output-varName (env p)))))

(defmethod $letStatement__SetField_expression_from_expression ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-expression (env p)))))
    (stack-dsl:%ensure-field-type "letStatement" "expression" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-letStatement (env p))) "expression" val)
    (stack-dsl:%pop (CL-USER::output-expression (env p)))))

(defmethod $letStatement__SetField_implementation_from_implementation ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-implementation (env p)))))
    (stack-dsl:%ensure-field-type "letStatement" "implementation" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-letStatement (env p))) "implementation" val)
    (stack-dsl:%pop (CL-USER::output-implementation (env p)))))

(defmethod $mapStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-mapStatement (env p))))

(defmethod $mapStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-mapStatement (env p)) (CL-USER::input-mapStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-mapStatement (env p))))

(defmethod $mapStatement__SetField_varName_from_varName ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-varName (env p)))))
    (stack-dsl:%ensure-field-type "mapStatement" "varName" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-mapStatement (env p))) "varName" val)
    (stack-dsl:%pop (CL-USER::output-varName (env p)))))

(defmethod $mapStatement__SetField_expression_from_expression ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-expression (env p)))))
    (stack-dsl:%ensure-field-type "mapStatement" "expression" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-mapStatement (env p))) "expression" val)
    (stack-dsl:%pop (CL-USER::output-expression (env p)))))

(defmethod $mapStatement__SetField_implementation_from_implementation ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-implementation (env p)))))
    (stack-dsl:%ensure-field-type "mapStatement" "implementation" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-mapStatement (env p))) "implementation" val)
    (stack-dsl:%pop (CL-USER::output-implementation (env p)))))

(defmethod $exitMapStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-exitMapStatement (env p))))

(defmethod $exitMapStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-exitMapStatement (env p)) (CL-USER::input-exitMapStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-exitMapStatement (env p))))

(defmethod $exitMapStatement__SetField_filler_from_filler ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-filler (env p)))))
    (stack-dsl:%ensure-field-type "exitMapStatement" "filler" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-exitMapStatement (env p))) "filler" val)
    (stack-dsl:%pop (CL-USER::output-filler (env p)))))

(defmethod $setStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-setStatement (env p))))

(defmethod $setStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-setStatement (env p)) (CL-USER::input-setStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-setStatement (env p))))

(defmethod $setStatement__SetField_lval_from_lval ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-lval (env p)))))
    (stack-dsl:%ensure-field-type "setStatement" "lval" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-setStatement (env p))) "lval" val)
    (stack-dsl:%pop (CL-USER::output-lval (env p)))))

(defmethod $setStatement__SetField_expression_from_expression ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-expression (env p)))))
    (stack-dsl:%ensure-field-type "setStatement" "expression" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-setStatement (env p))) "expression" val)
    (stack-dsl:%pop (CL-USER::output-expression (env p)))))

(defmethod $createStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-createStatement (env p))))

(defmethod $createStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-createStatement (env p)) (CL-USER::input-createStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-createStatement (env p))))

(defmethod $createStatement__SetField_varName_from_varName ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-varName (env p)))))
    (stack-dsl:%ensure-field-type "createStatement" "varName" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-createStatement (env p))) "varName" val)
    (stack-dsl:%pop (CL-USER::output-varName (env p)))))

(defmethod $createStatement__SetField_indirectionKind_from_indirectionKind ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-indirectionKind (env p)))))
    (stack-dsl:%ensure-field-type "createStatement" "indirectionKind" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-createStatement (env p))) "indirectionKind" val)
    (stack-dsl:%pop (CL-USER::output-indirectionKind (env p)))))

(defmethod $createStatement__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "createStatement" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-createStatement (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $createStatement__SetField_implementation_from_implementation ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-implementation (env p)))))
    (stack-dsl:%ensure-field-type "createStatement" "implementation" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-createStatement (env p))) "implementation" val)
    (stack-dsl:%pop (CL-USER::output-implementation (env p)))))

(defmethod $ifStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-ifStatement (env p))))

(defmethod $ifStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-ifStatement (env p)) (CL-USER::input-ifStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-ifStatement (env p))))

(defmethod $ifStatement__SetField_expression_from_expression ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-expression (env p)))))
    (stack-dsl:%ensure-field-type "ifStatement" "expression" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-ifStatement (env p))) "expression" val)
    (stack-dsl:%pop (CL-USER::output-expression (env p)))))

(defmethod $ifStatement__SetField_thenPart_from_thenPart ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-thenPart (env p)))))
    (stack-dsl:%ensure-field-type "ifStatement" "thenPart" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-ifStatement (env p))) "thenPart" val)
    (stack-dsl:%pop (CL-USER::output-thenPart (env p)))))

(defmethod $ifStatement__SetField_elsePart_from_elsePart ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-elsePart (env p)))))
    (stack-dsl:%ensure-field-type "ifStatement" "elsePart" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-ifStatement (env p))) "elsePart" val)
    (stack-dsl:%pop (CL-USER::output-elsePart (env p)))))

(defmethod $loopStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-loopStatement (env p))))

(defmethod $loopStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-loopStatement (env p)) (CL-USER::input-loopStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-loopStatement (env p))))

(defmethod $loopStatement__SetField_implementation_from_implementation ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-implementation (env p)))))
    (stack-dsl:%ensure-field-type "loopStatement" "implementation" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-loopStatement (env p))) "implementation" val)
    (stack-dsl:%pop (CL-USER::output-implementation (env p)))))

(defmethod $exitWhenStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-exitWhenStatement (env p))))

(defmethod $exitWhenStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-exitWhenStatement (env p)) (CL-USER::input-exitWhenStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-exitWhenStatement (env p))))

(defmethod $exitWhenStatement__SetField_expression_from_expression ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-expression (env p)))))
    (stack-dsl:%ensure-field-type "exitWhenStatement" "expression" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-exitWhenStatement (env p))) "expression" val)
    (stack-dsl:%pop (CL-USER::output-expression (env p)))))

(defmethod $returnTrueStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-returnTrueStatement (env p))))

(defmethod $returnTrueStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-returnTrueStatement (env p)) (CL-USER::input-returnTrueStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-returnTrueStatement (env p))))

(defmethod $returnTrueStatement__SetField_methodName_from_methodName ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-methodName (env p)))))
    (stack-dsl:%ensure-field-type "returnTrueStatement" "methodName" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-returnTrueStatement (env p))) "methodName" val)
    (stack-dsl:%pop (CL-USER::output-methodName (env p)))))

(defmethod $returnFalseStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-returnFalseStatement (env p))))

(defmethod $returnFalseStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-returnFalseStatement (env p)) (CL-USER::input-returnFalseStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-returnFalseStatement (env p))))

(defmethod $returnFalseStatement__SetField_methodName_from_methodName ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-methodName (env p)))))
    (stack-dsl:%ensure-field-type "returnFalseStatement" "methodName" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-returnFalseStatement (env p))) "methodName" val)
    (stack-dsl:%pop (CL-USER::output-methodName (env p)))))

(defmethod $returnValueStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-returnValueStatement (env p))))

(defmethod $returnValueStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-returnValueStatement (env p)) (CL-USER::input-returnValueStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-returnValueStatement (env p))))

(defmethod $returnValueStatement__SetField_methodName_from_methodName ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-methodName (env p)))))
    (stack-dsl:%ensure-field-type "returnValueStatement" "methodName" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-returnValueStatement (env p))) "methodName" val)
    (stack-dsl:%pop (CL-USER::output-methodName (env p)))))

(defmethod $returnValueStatement__SetField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
    (stack-dsl:%ensure-field-type "returnValueStatement" "name" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-returnValueStatement (env p))) "name" val)
    (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $callInternalStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-callInternalStatement (env p))))

(defmethod $callInternalStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-callInternalStatement (env p)) (CL-USER::input-callInternalStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-callInternalStatement (env p))))

(defmethod $callInternalStatement__SetField_functionReference_from_functionReference ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-functionReference (env p)))))
    (stack-dsl:%ensure-field-type "callInternalStatement" "functionReference" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-callInternalStatement (env p))) "functionReference" val)
    (stack-dsl:%pop (CL-USER::output-functionReference (env p)))))

(defmethod $callExternalStatement__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-callExternalStatement (env p))))

(defmethod $callExternalStatement__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-callExternalStatement (env p)) (CL-USER::input-callExternalStatement (env p)))
  (stack-dsl:%pop (CL-USER::input-callExternalStatement (env p))))

(defmethod $callExternalStatement__SetField_functionReference_from_functionReference ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-functionReference (env p)))))
    (stack-dsl:%ensure-field-type "callExternalStatement" "functionReference" val)
    (stack-dsl:%set-field (stack-dsl:%top (CL-USER::input-callExternalStatement (env p))) "functionReference" val)
    (stack-dsl:%pop (CL-USER::output-functionReference (env p)))))

(defmethod $lval__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-lval (env p))))

(defmethod $lval__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-lval (env p)) (CL-USER::input-lval (env p)))
  (stack-dsl:%pop (CL-USER::input-lval (env p))))

(defmethod $lval__CoerceFrom_expression ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-expression (env p)))))
   (stack-dsl:%ensure-type "lval" val)
   (stack-dsl:%set-top (CL-USER::input-lval (env p)) val)
   (stack-dsl:%pop (CL-USER::output-expression (env p)))))

(defmethod $varName__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-varName (env p))))

(defmethod $varName__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-varName (env p)) (CL-USER::input-varName (env p)))
  (stack-dsl:%pop (CL-USER::input-varName (env p))))

(defmethod $varName__CoerceFrom_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
   (stack-dsl:%ensure-type "varName" val)
   (stack-dsl:%set-top (CL-USER::input-varName (env p)) val)
   (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $functionReference__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-functionReference (env p))))

(defmethod $functionReference__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-functionReference (env p)) (CL-USER::input-functionReference (env p)))
  (stack-dsl:%pop (CL-USER::input-functionReference (env p))))

(defmethod $functionReference__CoerceFrom_expression ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-expression (env p)))))
   (stack-dsl:%ensure-type "functionReference" val)
   (stack-dsl:%set-top (CL-USER::input-functionReference (env p)) val)
   (stack-dsl:%pop (CL-USER::output-expression (env p)))))

(defmethod $thenPart__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-thenPart (env p))))

(defmethod $thenPart__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-thenPart (env p)) (CL-USER::input-thenPart (env p)))
  (stack-dsl:%pop (CL-USER::input-thenPart (env p))))

(defmethod $thenPart__CoerceFrom_implementation ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-implementation (env p)))))
   (stack-dsl:%ensure-type "thenPart" val)
   (stack-dsl:%set-top (CL-USER::input-thenPart (env p)) val)
   (stack-dsl:%pop (CL-USER::output-implementation (env p)))))

(defmethod $elsePart__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-elsePart (env p))))

(defmethod $elsePart__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-elsePart (env p)) (CL-USER::input-elsePart (env p)))
  (stack-dsl:%pop (CL-USER::input-elsePart (env p))))

(defmethod $elsePart__CoerceFrom_implementation ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-implementation (env p)))))
   (stack-dsl:%ensure-type "elsePart" val)
   (stack-dsl:%set-top (CL-USER::input-elsePart (env p)) val)
   (stack-dsl:%pop (CL-USER::output-implementation (env p)))))

(defmethod $indirectionKind__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-indirectionKind (env p))))

(defmethod $indirectionKind__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-indirectionKind (env p)) (CL-USER::input-indirectionKind (env p)))
  (stack-dsl:%pop (CL-USER::input-indirectionKind (env p))))

(defmethod $indirectionKind__SetEnum_indirect ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-indirectionKind (env p)))) "indirect"))

(defmethod $indirectionKind__SetEnum_direct ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (CL-USER::input-indirectionKind (env p)))) "direct"))

(defmethod $methodName__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-methodName (env p))))

(defmethod $methodName__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-methodName (env p)) (CL-USER::input-methodName (env p)))
  (stack-dsl:%pop (CL-USER::input-methodName (env p))))

(defmethod $methodName__CoerceFrom_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
   (stack-dsl:%ensure-type "methodName" val)
   (stack-dsl:%set-top (CL-USER::input-methodName (env p)) val)
   (stack-dsl:%pop (CL-USER::output-name (env p)))))

(defmethod $filler__NewScope ((p parser))
  (stack-dsl:%push-empty (CL-USER::input-filler (env p))))

(defmethod $filler__Output ((p parser))
  (stack-dsl:%output (CL-USER::output-filler (env p)) (CL-USER::input-filler (env p)))
  (stack-dsl:%pop (CL-USER::input-filler (env p))))

(defmethod $filler__CoerceFrom_name ((p parser))
  (let ((val (stack-dsl:%top (CL-USER::output-name (env p)))))
   (stack-dsl:%ensure-type "filler" val)
   (stack-dsl:%set-top (CL-USER::input-filler (env p)) val)
   (stack-dsl:%pop (CL-USER::output-name (env p)))))

