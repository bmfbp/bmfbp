(proclaim '(optimize (debug 3) (safety 3) (speed 0)))(in-package "CL-USER")
(defclass esaprogram (stack-dsl::%compound-type) () (:default-initargs :%type "esaprogram"))
(defmethod initialize-instance :after ((self esaprogram) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(typeDeclssituationsclasseswhenDeclarations)))
(defclass esaprogram-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "esaprogram"))

(defclass typeDecls (stack-dsl::%map) () (:default-initargs :%type "typeDecls"))
(defmethod initialize-instance :after ((self typeDecls) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) typeDecls))
(defclass typeDecls-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self typeDecls-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "typeDecls"))

(defclass situations (stack-dsl::%map) () (:default-initargs :%type "situations"))
(defmethod initialize-instance :after ((self situations) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) situations))
(defclass situations-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self situations-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "situations"))

(defclass classes (stack-dsl::%map) () (:default-initargs :%type "classes"))
(defmethod initialize-instance :after ((self classes) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) classes))
(defclass classes-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self classes-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "classes"))

(defclass whenDeclarations (stack-dsl::%map) () (:default-initargs :%type "whenDeclarations"))
(defmethod initialize-instance :after ((self whenDeclarations) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) whenDeclarations))
(defclass whenDeclarations-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self whenDeclarations-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "whenDeclarations"))

(defclass typeDecl (stack-dsl::%compound-type) () (:default-initargs :%type "typeDecl"))
(defmethod initialize-instance :after ((self typeDecl) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(nametypeName)))
(defclass typeDecl-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "typeDecl"))

(defclass situationDefinition (stack-dsl::%compound-type) () (:default-initargs :%type "situationDefinition"))
(defmethod initialize-instance :after ((self situationDefinition) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(name)))
(defclass situationDefinition-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "situationDefinition"))

(defclass esaclass (stack-dsl::%compound-type) () (:default-initargs :%type "esaclass"))
(defmethod initialize-instance :after ((self esaclass) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(namefieldMapmethodsTable)))
(defclass esaclass-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "esaclass"))

(defclass whenDeclaration (stack-dsl::%compound-type) () (:default-initargs :%type "whenDeclaration"))
(defmethod initialize-instance :after ((self whenDeclaration) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(situationReferenceListesaKindmethodDeclarationsAndScriptDeclarations)))
(defclass whenDeclaration-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "whenDeclaration"))

(defclass situationReferenceList (stack-dsl::%map) () (:default-initargs :%type "situationReferenceList"))
(defmethod initialize-instance :after ((self situationReferenceList) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) situationReferenceList))
(defclass situationReferenceList-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self situationReferenceList-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "situationReferenceList"))

(defclass situationReferenceName (stack-dsl::%compound-type) () (:default-initargs :%type "situationReferenceName"))
(defmethod initialize-instance :after ((self situationReferenceName) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(name)))
(defclass situationReferenceName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "situationReferenceName"))

(defclass methodDeclarationsAndScriptDeclarations (stack-dsl::%map) () (:default-initargs :%type "methodDeclarationsAndScriptDeclarations"))
(defmethod initialize-instance :after ((self methodDeclarationsAndScriptDeclarations) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) methodDeclarationsAndScriptDeclarations))
(defclass methodDeclarationsAndScriptDeclarations-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self methodDeclarationsAndScriptDeclarations-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "methodDeclarationsAndScriptDeclarations"))

(defclass declarationMethodOrScript (stack-dsl::%compound-type) () (:default-initargs :%type "declarationMethodOrScript"))
(defmethod initialize-instance :after ((self declarationMethodOrScript) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(methodDeclarationscriptDeclaration)))
(defclass declarationMethodOrScript-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "declarationMethodOrScript"))

(defclass methodDeclaration (stack-dsl::%compound-type) () (:default-initargs :%type "methodDeclaration"))
(defmethod initialize-instance :after ((self methodDeclaration) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(esaKindnameformalListreturnType)))
(defclass methodDeclaration-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "methodDeclaration"))

(defclass scriptDeclaration (stack-dsl::%compound-type) () (:default-initargs :%type "scriptDeclaration"))
(defmethod initialize-instance :after ((self scriptDeclaration) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(esaKindnameformalListreturnTypeimplementation)))
(defclass scriptDeclaration-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "scriptDeclaration"))

(defclass returnType (stack-dsl::%compound-type) () (:default-initargs :%type "returnType"))
(defmethod initialize-instance :after ((self returnType) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(returnKindname)))
(defclass returnType-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "returnType"))

(defclass returnKind (stack-dsl::%enum) () (:default-initargs :%type "returnKind"))
(defmethod initialize-instance :after ((self returnKind) &key &allow-other-keys)
  (setf (stack-dsl::%value-list self) '(mapsimplevoid)))
(defclass returnKind-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self returnKind-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "returnKind"))

(defclass formalList (stack-dsl::%map) () (:default-initargs :%type "formalList"))
(defmethod initialize-instance :after ((self formalList) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) formalList))
(defclass formalList-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self formalList-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "formalList"))

(defclass esaKind (stack-dsl::%compound-type) () (:default-initargs :%type "esaKind"))
(defmethod initialize-instance :after ((self esaKind) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(name)))
(defclass esaKind-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "esaKind"))

(defclass typeName (stack-dsl::%compound-type) () (:default-initargs :%type "typeName"))
(defmethod initialize-instance :after ((self typeName) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(name)))
(defclass typeName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "typeName"))

(defclass expression (stack-dsl::%compound-type) () (:default-initargs :%type "expression"))
(defmethod initialize-instance :after ((self expression) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(ekindobject)))
(defclass expression-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "expression"))

(defclass ekind (stack-dsl::%enum) () (:default-initargs :%type "ekind"))
(defmethod initialize-instance :after ((self ekind) &key &allow-other-keys)
  (setf (stack-dsl::%value-list self) '(truefalseobjectcalledObject)))
(defclass ekind-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self ekind-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "ekind"))

(defclass object (stack-dsl::%compound-type) () (:default-initargs :%type "object"))
(defmethod initialize-instance :after ((self object) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(namefieldMap)))
(defclass object-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "object"))

(defclass fieldMap (stack-dsl::%map) () (:default-initargs :%type "fieldMap"))
(defmethod initialize-instance :after ((self fieldMap) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) fieldMap))
(defclass fieldMap-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self fieldMap-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "fieldMap"))

(defclass field (stack-dsl::%compound-type) () (:default-initargs :%type "field"))
(defmethod initialize-instance :after ((self field) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(namefkindactualParameterList)))
(defclass field-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "field"))

(defclass fkind (stack-dsl::%enum) () (:default-initargs :%type "fkind"))
(defmethod initialize-instance :after ((self fkind) &key &allow-other-keys)
  (setf (stack-dsl::%value-list self) '(mapsimple)))
(defclass fkind-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self fkind-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "fkind"))

(defclass actualParameterList (stack-dsl::%map) () (:default-initargs :%type "actualParameterList"))
(defmethod initialize-instance :after ((self actualParameterList) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) actualParameterList))
(defclass actualParameterList-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self actualParameterList-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "actualParameterList"))

(defclass name (stack-dsl::%string) () (:default-initargs :%type "name"))
(defclass name-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self ~a-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "name"))

(defclass methodsTable (stack-dsl::%map) () (:default-initargs :%type "methodsTable"))
(defmethod initialize-instance :after ((self methodsTable) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) methodsTable))
(defclass methodsTable-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self methodsTable-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "methodsTable"))

(defclass externalMethod (stack-dsl::%compound-type) () (:default-initargs :%type "externalMethod"))
(defmethod initialize-instance :after ((self externalMethod) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(nameformalListreturnType)))
(defclass externalMethod-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "externalMethod"))

(defclass internalMethod (stack-dsl::%compound-type) () (:default-initargs :%type "internalMethod"))
(defmethod initialize-instance :after ((self internalMethod) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(nameformalListreturnTypeimplementation)))
(defclass internalMethod-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "internalMethod"))

(defclass implementation (stack-dsl::%map) () (:default-initargs :%type "implementation"))
(defmethod initialize-instance :after ((self implementation) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) implementation))
(defclass implementation-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self implementation-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "implementation"))

(defclass statement (stack-dsl::%compound-type) () (:default-initargs :%type "statement"))
(defmethod initialize-instance :after ((self statement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(letStatementmapStatementexitMapStatementsetStatementcreateStatementifStatementloopStatementexitWhenStatementcallInternalStatementcallExternalStatementreturnTrueStatementreturnFalseStatementreturnValueStatement)))
(defclass statement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "statement"))

(defclass letStatement (stack-dsl::%compound-type) () (:default-initargs :%type "letStatement"))
(defmethod initialize-instance :after ((self letStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(varNameexpressionimplementation)))
(defclass letStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "letStatement"))

(defclass mapStatement (stack-dsl::%compound-type) () (:default-initargs :%type "mapStatement"))
(defmethod initialize-instance :after ((self mapStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(varNameexpressionimplementation)))
(defclass mapStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "mapStatement"))

(defclass exitMapStatement (stack-dsl::%compound-type) () (:default-initargs :%type "exitMapStatement"))
(defmethod initialize-instance :after ((self exitMapStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(filler)))
(defclass exitMapStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "exitMapStatement"))

(defclass setStatement (stack-dsl::%compound-type) () (:default-initargs :%type "setStatement"))
(defmethod initialize-instance :after ((self setStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(lvalexpression)))
(defclass setStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "setStatement"))

(defclass createStatement (stack-dsl::%compound-type) () (:default-initargs :%type "createStatement"))
(defmethod initialize-instance :after ((self createStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(varNameindirectionKindnameimplementation)))
(defclass createStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "createStatement"))

(defclass ifStatement (stack-dsl::%compound-type) () (:default-initargs :%type "ifStatement"))
(defmethod initialize-instance :after ((self ifStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(expressionthenPartelsePart)))
(defclass ifStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "ifStatement"))

(defclass loopStatement (stack-dsl::%compound-type) () (:default-initargs :%type "loopStatement"))
(defmethod initialize-instance :after ((self loopStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(implementation)))
(defclass loopStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "loopStatement"))

(defclass exitWhenStatement (stack-dsl::%compound-type) () (:default-initargs :%type "exitWhenStatement"))
(defmethod initialize-instance :after ((self exitWhenStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(expression)))
(defclass exitWhenStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "exitWhenStatement"))

(defclass returnTrueStatement (stack-dsl::%compound-type) () (:default-initargs :%type "returnTrueStatement"))
(defmethod initialize-instance :after ((self returnTrueStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(methodName)))
(defclass returnTrueStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "returnTrueStatement"))

(defclass returnFalseStatement (stack-dsl::%compound-type) () (:default-initargs :%type "returnFalseStatement"))
(defmethod initialize-instance :after ((self returnFalseStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(methodName)))
(defclass returnFalseStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "returnFalseStatement"))

(defclass returnValueStatement (stack-dsl::%compound-type) () (:default-initargs :%type "returnValueStatement"))
(defmethod initialize-instance :after ((self returnValueStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(methodNamename)))
(defclass returnValueStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "returnValueStatement"))

(defclass callInternalStatement (stack-dsl::%compound-type) () (:default-initargs :%type "callInternalStatement"))
(defmethod initialize-instance :after ((self callInternalStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(functionReference)))
(defclass callInternalStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "callInternalStatement"))

(defclass callExternalStatement (stack-dsl::%compound-type) () (:default-initargs :%type "callExternalStatement"))
(defmethod initialize-instance :after ((self callExternalStatement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(functionReference)))
(defclass callExternalStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "callExternalStatement"))

(defclass lval (stack-dsl::%compound-type) () (:default-initargs :%type "lval"))
(defmethod initialize-instance :after ((self lval) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(expression)))
(defclass lval-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "lval"))

(defclass varName (stack-dsl::%compound-type) () (:default-initargs :%type "varName"))
(defmethod initialize-instance :after ((self varName) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(name)))
(defclass varName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "varName"))

(defclass functionReference (stack-dsl::%compound-type) () (:default-initargs :%type "functionReference"))
(defmethod initialize-instance :after ((self functionReference) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(expression)))
(defclass functionReference-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "functionReference"))

(defclass thenPart (stack-dsl::%compound-type) () (:default-initargs :%type "thenPart"))
(defmethod initialize-instance :after ((self thenPart) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(implementation)))
(defclass thenPart-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "thenPart"))

(defclass elsePart (stack-dsl::%compound-type) () (:default-initargs :%type "elsePart"))
(defmethod initialize-instance :after ((self elsePart) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(implementation)))
(defclass elsePart-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "elsePart"))

(defclass indirectionKind (stack-dsl::%enum) () (:default-initargs :%type "indirectionKind"))
(defmethod initialize-instance :after ((self indirectionKind) &key &allow-other-keys)
  (setf (stack-dsl::%value-list self) '(indirectdirect)))
(defclass indirectionKind-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self indirectionKind-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "indirectionKind"))

(defclass methodName (stack-dsl::%compound-type) () (:default-initargs :%type "methodName"))
(defmethod initialize-instance :after ((self methodName) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(name)))
(defclass methodName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "methodName"))

(defclass filler (stack-dsl::%compound-type) () (:default-initargs :%type "filler"))
(defmethod initialize-instance :after ((self filler) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '(name)))
(defclass filler-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "filler"))


