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


(stack-dsl::%ensure-existence 'typeDecls)
(stack-dsl::%ensure-existence 'situations)
(stack-dsl::%ensure-existence 'classes)
(stack-dsl::%ensure-existence 'whenDeclarations)
(stack-dsl::%ensure-existence 'esaprogram)
(stack-dsl::%ensure-existence 'name)
(stack-dsl::%ensure-existence 'typeName)
(stack-dsl::%ensure-existence 'typeDecl)
(stack-dsl::%ensure-existence 'situationDefinition)
(stack-dsl::%ensure-existence 'fieldMap)
(stack-dsl::%ensure-existence 'methodsTable)
(stack-dsl::%ensure-existence 'esaclass)
(stack-dsl::%ensure-existence 'situationReferenceList)
(stack-dsl::%ensure-existence 'esaKind)
(stack-dsl::%ensure-existence 'methodDeclarationsAndScriptDeclarations)
(stack-dsl::%ensure-existence 'whenDeclaration)
(stack-dsl::%ensure-existence 'situationReferenceName)
(stack-dsl::%ensure-existence 'methodDeclaration)
(stack-dsl::%ensure-existence 'scriptDeclaration)
(stack-dsl::%ensure-existence 'declarationMethodOrScript)
(stack-dsl::%ensure-existence 'formalList)
(stack-dsl::%ensure-existence 'returnType)
(stack-dsl::%ensure-existence 'implementation)
(stack-dsl::%ensure-existence 'returnKind)
(stack-dsl::%ensure-existence 'ekind)
(stack-dsl::%ensure-existence 'object)
(stack-dsl::%ensure-existence 'expression)
(stack-dsl::%ensure-existence 'fkind)
(stack-dsl::%ensure-existence 'actualParameterList)
(stack-dsl::%ensure-existence 'field)
(stack-dsl::%ensure-existence 'externalMethod)
(stack-dsl::%ensure-existence 'internalMethod)
(stack-dsl::%ensure-existence 'letStatement)
(stack-dsl::%ensure-existence 'mapStatement)
(stack-dsl::%ensure-existence 'exitMapStatement)
(stack-dsl::%ensure-existence 'setStatement)
(stack-dsl::%ensure-existence 'createStatement)
(stack-dsl::%ensure-existence 'ifStatement)
(stack-dsl::%ensure-existence 'loopStatement)
(stack-dsl::%ensure-existence 'exitWhenStatement)
(stack-dsl::%ensure-existence 'callInternalStatement)
(stack-dsl::%ensure-existence 'callExternalStatement)
(stack-dsl::%ensure-existence 'returnTrueStatement)
(stack-dsl::%ensure-existence 'returnFalseStatement)
(stack-dsl::%ensure-existence 'returnValueStatement)
(stack-dsl::%ensure-existence 'statement)
(stack-dsl::%ensure-existence 'varName)
(stack-dsl::%ensure-existence 'filler)
(stack-dsl::%ensure-existence 'lval)
(stack-dsl::%ensure-existence 'indirectionKind)
(stack-dsl::%ensure-existence 'thenPart)
(stack-dsl::%ensure-existence 'elsePart)
(stack-dsl::%ensure-existence 'methodName)
(stack-dsl::%ensure-existence 'functionReference)

(defclass %map-stack (stack-dsl::%typed-stack) ())
(defclass %bag-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self %map-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "%map"))(defmethod initialize-instance :after ((self %bag-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "%bag"))

(defclass environment ()
((%water-mark :accessor %water-mark :initform nil)
(input-typeDecls :accessor input-typeDecls :initform (make-instance 'typeDecls))
(output-typeDecls :accessor output-typeDecls :initform (make-instance 'typeDecls))
(input-situations :accessor input-situations :initform (make-instance 'situations))
(output-situations :accessor output-situations :initform (make-instance 'situations))
(input-classes :accessor input-classes :initform (make-instance 'classes))
(output-classes :accessor output-classes :initform (make-instance 'classes))
(input-whenDeclarations :accessor input-whenDeclarations :initform (make-instance 'whenDeclarations))
(output-whenDeclarations :accessor output-whenDeclarations :initform (make-instance 'whenDeclarations))
(input-esaprogram :accessor input-esaprogram :initform (make-instance 'esaprogram))
(output-esaprogram :accessor output-esaprogram :initform (make-instance 'esaprogram))
(input-name :accessor input-name :initform (make-instance 'name))
(output-name :accessor output-name :initform (make-instance 'name))
(input-typeName :accessor input-typeName :initform (make-instance 'typeName))
(output-typeName :accessor output-typeName :initform (make-instance 'typeName))
(input-typeDecl :accessor input-typeDecl :initform (make-instance 'typeDecl))
(output-typeDecl :accessor output-typeDecl :initform (make-instance 'typeDecl))
(input-situationDefinition :accessor input-situationDefinition :initform (make-instance 'situationDefinition))
(output-situationDefinition :accessor output-situationDefinition :initform (make-instance 'situationDefinition))
(input-fieldMap :accessor input-fieldMap :initform (make-instance 'fieldMap))
(output-fieldMap :accessor output-fieldMap :initform (make-instance 'fieldMap))
(input-methodsTable :accessor input-methodsTable :initform (make-instance 'methodsTable))
(output-methodsTable :accessor output-methodsTable :initform (make-instance 'methodsTable))
(input-esaclass :accessor input-esaclass :initform (make-instance 'esaclass))
(output-esaclass :accessor output-esaclass :initform (make-instance 'esaclass))
(input-situationReferenceList :accessor input-situationReferenceList :initform (make-instance 'situationReferenceList))
(output-situationReferenceList :accessor output-situationReferenceList :initform (make-instance 'situationReferenceList))
(input-esaKind :accessor input-esaKind :initform (make-instance 'esaKind))
(output-esaKind :accessor output-esaKind :initform (make-instance 'esaKind))
(input-methodDeclarationsAndScriptDeclarations :accessor input-methodDeclarationsAndScriptDeclarations :initform (make-instance 'methodDeclarationsAndScriptDeclarations))
(output-methodDeclarationsAndScriptDeclarations :accessor output-methodDeclarationsAndScriptDeclarations :initform (make-instance 'methodDeclarationsAndScriptDeclarations))
(input-whenDeclaration :accessor input-whenDeclaration :initform (make-instance 'whenDeclaration))
(output-whenDeclaration :accessor output-whenDeclaration :initform (make-instance 'whenDeclaration))
(input-situationReferenceName :accessor input-situationReferenceName :initform (make-instance 'situationReferenceName))
(output-situationReferenceName :accessor output-situationReferenceName :initform (make-instance 'situationReferenceName))
(input-methodDeclaration :accessor input-methodDeclaration :initform (make-instance 'methodDeclaration))
(output-methodDeclaration :accessor output-methodDeclaration :initform (make-instance 'methodDeclaration))
(input-scriptDeclaration :accessor input-scriptDeclaration :initform (make-instance 'scriptDeclaration))
(output-scriptDeclaration :accessor output-scriptDeclaration :initform (make-instance 'scriptDeclaration))
(input-declarationMethodOrScript :accessor input-declarationMethodOrScript :initform (make-instance 'declarationMethodOrScript))
(output-declarationMethodOrScript :accessor output-declarationMethodOrScript :initform (make-instance 'declarationMethodOrScript))
(input-formalList :accessor input-formalList :initform (make-instance 'formalList))
(output-formalList :accessor output-formalList :initform (make-instance 'formalList))
(input-returnType :accessor input-returnType :initform (make-instance 'returnType))
(output-returnType :accessor output-returnType :initform (make-instance 'returnType))
(input-implementation :accessor input-implementation :initform (make-instance 'implementation))
(output-implementation :accessor output-implementation :initform (make-instance 'implementation))
(input-returnKind :accessor input-returnKind :initform (make-instance 'returnKind))
(output-returnKind :accessor output-returnKind :initform (make-instance 'returnKind))
(input-ekind :accessor input-ekind :initform (make-instance 'ekind))
(output-ekind :accessor output-ekind :initform (make-instance 'ekind))
(input-object :accessor input-object :initform (make-instance 'object))
(output-object :accessor output-object :initform (make-instance 'object))
(input-expression :accessor input-expression :initform (make-instance 'expression))
(output-expression :accessor output-expression :initform (make-instance 'expression))
(input-fkind :accessor input-fkind :initform (make-instance 'fkind))
(output-fkind :accessor output-fkind :initform (make-instance 'fkind))
(input-actualParameterList :accessor input-actualParameterList :initform (make-instance 'actualParameterList))
(output-actualParameterList :accessor output-actualParameterList :initform (make-instance 'actualParameterList))
(input-field :accessor input-field :initform (make-instance 'field))
(output-field :accessor output-field :initform (make-instance 'field))
(input-externalMethod :accessor input-externalMethod :initform (make-instance 'externalMethod))
(output-externalMethod :accessor output-externalMethod :initform (make-instance 'externalMethod))
(input-internalMethod :accessor input-internalMethod :initform (make-instance 'internalMethod))
(output-internalMethod :accessor output-internalMethod :initform (make-instance 'internalMethod))
(input-letStatement :accessor input-letStatement :initform (make-instance 'letStatement))
(output-letStatement :accessor output-letStatement :initform (make-instance 'letStatement))
(input-mapStatement :accessor input-mapStatement :initform (make-instance 'mapStatement))
(output-mapStatement :accessor output-mapStatement :initform (make-instance 'mapStatement))
(input-exitMapStatement :accessor input-exitMapStatement :initform (make-instance 'exitMapStatement))
(output-exitMapStatement :accessor output-exitMapStatement :initform (make-instance 'exitMapStatement))
(input-setStatement :accessor input-setStatement :initform (make-instance 'setStatement))
(output-setStatement :accessor output-setStatement :initform (make-instance 'setStatement))
(input-createStatement :accessor input-createStatement :initform (make-instance 'createStatement))
(output-createStatement :accessor output-createStatement :initform (make-instance 'createStatement))
(input-ifStatement :accessor input-ifStatement :initform (make-instance 'ifStatement))
(output-ifStatement :accessor output-ifStatement :initform (make-instance 'ifStatement))
(input-loopStatement :accessor input-loopStatement :initform (make-instance 'loopStatement))
(output-loopStatement :accessor output-loopStatement :initform (make-instance 'loopStatement))
(input-exitWhenStatement :accessor input-exitWhenStatement :initform (make-instance 'exitWhenStatement))
(output-exitWhenStatement :accessor output-exitWhenStatement :initform (make-instance 'exitWhenStatement))
(input-callInternalStatement :accessor input-callInternalStatement :initform (make-instance 'callInternalStatement))
(output-callInternalStatement :accessor output-callInternalStatement :initform (make-instance 'callInternalStatement))
(input-callExternalStatement :accessor input-callExternalStatement :initform (make-instance 'callExternalStatement))
(output-callExternalStatement :accessor output-callExternalStatement :initform (make-instance 'callExternalStatement))
(input-returnTrueStatement :accessor input-returnTrueStatement :initform (make-instance 'returnTrueStatement))
(output-returnTrueStatement :accessor output-returnTrueStatement :initform (make-instance 'returnTrueStatement))
(input-returnFalseStatement :accessor input-returnFalseStatement :initform (make-instance 'returnFalseStatement))
(output-returnFalseStatement :accessor output-returnFalseStatement :initform (make-instance 'returnFalseStatement))
(input-returnValueStatement :accessor input-returnValueStatement :initform (make-instance 'returnValueStatement))
(output-returnValueStatement :accessor output-returnValueStatement :initform (make-instance 'returnValueStatement))
(input-statement :accessor input-statement :initform (make-instance 'statement))
(output-statement :accessor output-statement :initform (make-instance 'statement))
(input-varName :accessor input-varName :initform (make-instance 'varName))
(output-varName :accessor output-varName :initform (make-instance 'varName))
(input-filler :accessor input-filler :initform (make-instance 'filler))
(output-filler :accessor output-filler :initform (make-instance 'filler))
(input-lval :accessor input-lval :initform (make-instance 'lval))
(output-lval :accessor output-lval :initform (make-instance 'lval))
(input-indirectionKind :accessor input-indirectionKind :initform (make-instance 'indirectionKind))
(output-indirectionKind :accessor output-indirectionKind :initform (make-instance 'indirectionKind))
(input-thenPart :accessor input-thenPart :initform (make-instance 'thenPart))
(output-thenPart :accessor output-thenPart :initform (make-instance 'thenPart))
(input-elsePart :accessor input-elsePart :initform (make-instance 'elsePart))
(output-elsePart :accessor output-elsePart :initform (make-instance 'elsePart))
(input-methodName :accessor input-methodName :initform (make-instance 'methodName))
(output-methodName :accessor output-methodName :initform (make-instance 'methodName))
(input-functionReference :accessor input-functionReference :initform (make-instance 'functionReference))
(output-functionReference :accessor output-functionReference :initform (make-instance 'functionReference))
))

(defparameter *stacks* '(
input-typeDecls
output-typeDecls
input-situations
output-situations
input-classes
output-classes
input-whenDeclarations
output-whenDeclarations
input-esaprogram
output-esaprogram
input-name
output-name
input-typeName
output-typeName
input-typeDecl
output-typeDecl
input-situationDefinition
output-situationDefinition
input-fieldMap
output-fieldMap
input-methodsTable
output-methodsTable
input-esaclass
output-esaclass
input-situationReferenceList
output-situationReferenceList
input-esaKind
output-esaKind
input-methodDeclarationsAndScriptDeclarations
output-methodDeclarationsAndScriptDeclarations
input-whenDeclaration
output-whenDeclaration
input-situationReferenceName
output-situationReferenceName
input-methodDeclaration
output-methodDeclaration
input-scriptDeclaration
output-scriptDeclaration
input-declarationMethodOrScript
output-declarationMethodOrScript
input-formalList
output-formalList
input-returnType
output-returnType
input-implementation
output-implementation
input-returnKind
output-returnKind
input-ekind
output-ekind
input-object
output-object
input-expression
output-expression
input-fkind
output-fkind
input-actualParameterList
output-actualParameterList
input-field
output-field
input-externalMethod
output-externalMethod
input-internalMethod
output-internalMethod
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
input-callInternalStatement
output-callInternalStatement
input-callExternalStatement
output-callExternalStatement
input-returnTrueStatement
output-returnTrueStatement
input-returnFalseStatement
output-returnFalseStatement
input-returnValueStatement
output-returnValueStatement
input-statement
output-statement
input-varName
output-varName
input-filler
output-filler
input-lval
output-lval
input-indirectionKind
output-indirectionKind
input-thenPart
output-thenPart
input-elsePart
output-elsePart
input-methodName
output-methodName
input-functionReference
output-functionReference

))  

(defmethod %memoCheck ((self environment))
 (let ((wm (%water-mark self)))
  (let ((r (and
	   
(let ((in-eq (eq (nth 0 wm) (stack-dsl::%stack (input-typeDecls self))))
      (out-eq (eq (nth 1 wm) (stack-dsl::%stack (output-typeDecls self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 2 wm) (stack-dsl::%stack (input-situations self))))
      (out-eq (eq (nth 3 wm) (stack-dsl::%stack (output-situations self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 4 wm) (stack-dsl::%stack (input-classes self))))
      (out-eq (eq (nth 5 wm) (stack-dsl::%stack (output-classes self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 6 wm) (stack-dsl::%stack (input-whenDeclarations self))))
      (out-eq (eq (nth 7 wm) (stack-dsl::%stack (output-whenDeclarations self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 8 wm) (stack-dsl::%stack (input-esaprogram self))))
      (out-eq (eq (nth 9 wm) (stack-dsl::%stack (output-esaprogram self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 10 wm) (stack-dsl::%stack (input-name self))))
      (out-eq (eq (nth 11 wm) (stack-dsl::%stack (output-name self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 12 wm) (stack-dsl::%stack (input-typeName self))))
      (out-eq (eq (nth 13 wm) (stack-dsl::%stack (output-typeName self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 14 wm) (stack-dsl::%stack (input-typeDecl self))))
      (out-eq (eq (nth 15 wm) (stack-dsl::%stack (output-typeDecl self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 16 wm) (stack-dsl::%stack (input-situationDefinition self))))
      (out-eq (eq (nth 17 wm) (stack-dsl::%stack (output-situationDefinition self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 18 wm) (stack-dsl::%stack (input-fieldMap self))))
      (out-eq (eq (nth 19 wm) (stack-dsl::%stack (output-fieldMap self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 20 wm) (stack-dsl::%stack (input-methodsTable self))))
      (out-eq (eq (nth 21 wm) (stack-dsl::%stack (output-methodsTable self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 22 wm) (stack-dsl::%stack (input-esaclass self))))
      (out-eq (eq (nth 23 wm) (stack-dsl::%stack (output-esaclass self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 24 wm) (stack-dsl::%stack (input-situationReferenceList self))))
      (out-eq (eq (nth 25 wm) (stack-dsl::%stack (output-situationReferenceList self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 26 wm) (stack-dsl::%stack (input-esaKind self))))
      (out-eq (eq (nth 27 wm) (stack-dsl::%stack (output-esaKind self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 28 wm) (stack-dsl::%stack (input-methodDeclarationsAndScriptDeclarations self))))
      (out-eq (eq (nth 29 wm) (stack-dsl::%stack (output-methodDeclarationsAndScriptDeclarations self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 30 wm) (stack-dsl::%stack (input-whenDeclaration self))))
      (out-eq (eq (nth 31 wm) (stack-dsl::%stack (output-whenDeclaration self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 32 wm) (stack-dsl::%stack (input-situationReferenceName self))))
      (out-eq (eq (nth 33 wm) (stack-dsl::%stack (output-situationReferenceName self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 34 wm) (stack-dsl::%stack (input-methodDeclaration self))))
      (out-eq (eq (nth 35 wm) (stack-dsl::%stack (output-methodDeclaration self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 36 wm) (stack-dsl::%stack (input-scriptDeclaration self))))
      (out-eq (eq (nth 37 wm) (stack-dsl::%stack (output-scriptDeclaration self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 38 wm) (stack-dsl::%stack (input-declarationMethodOrScript self))))
      (out-eq (eq (nth 39 wm) (stack-dsl::%stack (output-declarationMethodOrScript self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 40 wm) (stack-dsl::%stack (input-formalList self))))
      (out-eq (eq (nth 41 wm) (stack-dsl::%stack (output-formalList self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 42 wm) (stack-dsl::%stack (input-returnType self))))
      (out-eq (eq (nth 43 wm) (stack-dsl::%stack (output-returnType self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 44 wm) (stack-dsl::%stack (input-implementation self))))
      (out-eq (eq (nth 45 wm) (stack-dsl::%stack (output-implementation self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 46 wm) (stack-dsl::%stack (input-returnKind self))))
      (out-eq (eq (nth 47 wm) (stack-dsl::%stack (output-returnKind self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 48 wm) (stack-dsl::%stack (input-ekind self))))
      (out-eq (eq (nth 49 wm) (stack-dsl::%stack (output-ekind self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 50 wm) (stack-dsl::%stack (input-object self))))
      (out-eq (eq (nth 51 wm) (stack-dsl::%stack (output-object self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 52 wm) (stack-dsl::%stack (input-expression self))))
      (out-eq (eq (nth 53 wm) (stack-dsl::%stack (output-expression self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 54 wm) (stack-dsl::%stack (input-fkind self))))
      (out-eq (eq (nth 55 wm) (stack-dsl::%stack (output-fkind self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 56 wm) (stack-dsl::%stack (input-actualParameterList self))))
      (out-eq (eq (nth 57 wm) (stack-dsl::%stack (output-actualParameterList self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 58 wm) (stack-dsl::%stack (input-field self))))
      (out-eq (eq (nth 59 wm) (stack-dsl::%stack (output-field self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 60 wm) (stack-dsl::%stack (input-externalMethod self))))
      (out-eq (eq (nth 61 wm) (stack-dsl::%stack (output-externalMethod self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 62 wm) (stack-dsl::%stack (input-internalMethod self))))
      (out-eq (eq (nth 63 wm) (stack-dsl::%stack (output-internalMethod self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 64 wm) (stack-dsl::%stack (input-letStatement self))))
      (out-eq (eq (nth 65 wm) (stack-dsl::%stack (output-letStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 66 wm) (stack-dsl::%stack (input-mapStatement self))))
      (out-eq (eq (nth 67 wm) (stack-dsl::%stack (output-mapStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 68 wm) (stack-dsl::%stack (input-exitMapStatement self))))
      (out-eq (eq (nth 69 wm) (stack-dsl::%stack (output-exitMapStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 70 wm) (stack-dsl::%stack (input-setStatement self))))
      (out-eq (eq (nth 71 wm) (stack-dsl::%stack (output-setStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 72 wm) (stack-dsl::%stack (input-createStatement self))))
      (out-eq (eq (nth 73 wm) (stack-dsl::%stack (output-createStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 74 wm) (stack-dsl::%stack (input-ifStatement self))))
      (out-eq (eq (nth 75 wm) (stack-dsl::%stack (output-ifStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 76 wm) (stack-dsl::%stack (input-loopStatement self))))
      (out-eq (eq (nth 77 wm) (stack-dsl::%stack (output-loopStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 78 wm) (stack-dsl::%stack (input-exitWhenStatement self))))
      (out-eq (eq (nth 79 wm) (stack-dsl::%stack (output-exitWhenStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 80 wm) (stack-dsl::%stack (input-callInternalStatement self))))
      (out-eq (eq (nth 81 wm) (stack-dsl::%stack (output-callInternalStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 82 wm) (stack-dsl::%stack (input-callExternalStatement self))))
      (out-eq (eq (nth 83 wm) (stack-dsl::%stack (output-callExternalStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 84 wm) (stack-dsl::%stack (input-returnTrueStatement self))))
      (out-eq (eq (nth 85 wm) (stack-dsl::%stack (output-returnTrueStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 86 wm) (stack-dsl::%stack (input-returnFalseStatement self))))
      (out-eq (eq (nth 87 wm) (stack-dsl::%stack (output-returnFalseStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 88 wm) (stack-dsl::%stack (input-returnValueStatement self))))
      (out-eq (eq (nth 89 wm) (stack-dsl::%stack (output-returnValueStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 90 wm) (stack-dsl::%stack (input-statement self))))
      (out-eq (eq (nth 91 wm) (stack-dsl::%stack (output-statement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 92 wm) (stack-dsl::%stack (input-varName self))))
      (out-eq (eq (nth 93 wm) (stack-dsl::%stack (output-varName self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 94 wm) (stack-dsl::%stack (input-filler self))))
      (out-eq (eq (nth 95 wm) (stack-dsl::%stack (output-filler self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 96 wm) (stack-dsl::%stack (input-lval self))))
      (out-eq (eq (nth 97 wm) (stack-dsl::%stack (output-lval self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 98 wm) (stack-dsl::%stack (input-indirectionKind self))))
      (out-eq (eq (nth 99 wm) (stack-dsl::%stack (output-indirectionKind self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 100 wm) (stack-dsl::%stack (input-thenPart self))))
      (out-eq (eq (nth 101 wm) (stack-dsl::%stack (output-thenPart self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 102 wm) (stack-dsl::%stack (input-elsePart self))))
      (out-eq (eq (nth 103 wm) (stack-dsl::%stack (output-elsePart self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 104 wm) (stack-dsl::%stack (input-methodName self))))
      (out-eq (eq (nth 105 wm) (stack-dsl::%stack (output-methodName self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 106 wm) (stack-dsl::%stack (input-functionReference self))))
      (out-eq (eq (nth 107 wm) (stack-dsl::%stack (output-functionReference self)))))
  (and in-eq out-eq)))))
   (unless r (error "stack depth incorrect")))))
