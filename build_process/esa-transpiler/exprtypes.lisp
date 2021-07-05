(proclaim '(optimize (debug 3) (safety 3) (speed 0)))(in-package "CL-USER")

(defclass esaprogram (stack-dsl::%typed-value)
((%field-type-whenDeclarations :accessor %field-type-whenDeclarations :initform "whenDeclarations")
(whenDeclarations :accessor whenDeclarations)
(%field-type-classes :accessor %field-type-classes :initform "classes")
(classes :accessor classes)
(%field-type-situations :accessor %field-type-situations :initform "situations")
(situations :accessor situations)
(%field-type-typeDecls :accessor %field-type-typeDecls :initform "typeDecls")
(typeDecls :accessor typeDecls)
) (:default-initargs :%type "esaprogram"))

(defclass esaprogram-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self esaprogram-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "esaprogram"))

(defclass typeDecls (stack-dsl::%map) () (:default-initargs :%type "typeDecls"))
(defmethod initialize-instance :after ((self typeDecls) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "typeDecl"))
(defclass typeDecls-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self typeDecls-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "typeDecls"))
(defclass situations (stack-dsl::%map) () (:default-initargs :%type "situations"))
(defmethod initialize-instance :after ((self situations) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "situationDefinition"))
(defclass situations-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self situations-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "situations"))
(defclass classes (stack-dsl::%map) () (:default-initargs :%type "classes"))
(defmethod initialize-instance :after ((self classes) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "esaclass"))
(defclass classes-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self classes-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "classes"))
(defclass whenDeclarations (stack-dsl::%map) () (:default-initargs :%type "whenDeclarations"))
(defmethod initialize-instance :after ((self whenDeclarations) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "whenDeclaration"))
(defclass whenDeclarations-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self whenDeclarations-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "whenDeclarations"))
(defclass typeDecl (stack-dsl::%typed-value)
((%field-type-typeName :accessor %field-type-typeName :initform "typeName")
(typeName :accessor typeName)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
) (:default-initargs :%type "typeDecl"))

(defclass typeDecl-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self typeDecl-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "typeDecl"))


(defclass situationDefinition (stack-dsl::%compound-type) () (:default-initargs :%type "situationDefinition"))
(defmethod initialize-instance :after ((self situationDefinition) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("name")))
(defclass situationDefinition-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "situationDefinition"))

(defclass esaclass (stack-dsl::%typed-value)
((%field-type-methodsTable :accessor %field-type-methodsTable :initform "methodsTable")
(methodsTable :accessor methodsTable)
(%field-type-fieldMap :accessor %field-type-fieldMap :initform "fieldMap")
(fieldMap :accessor fieldMap)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
) (:default-initargs :%type "esaclass"))

(defclass esaclass-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self esaclass-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "esaclass"))

(defclass whenDeclaration (stack-dsl::%typed-value)
((%field-type-methodDeclarationsAndScriptDeclarations :accessor %field-type-methodDeclarationsAndScriptDeclarations :initform "methodDeclarationsAndScriptDeclarations")
(methodDeclarationsAndScriptDeclarations :accessor methodDeclarationsAndScriptDeclarations)
(%field-type-esaKind :accessor %field-type-esaKind :initform "esaKind")
(esaKind :accessor esaKind)
(%field-type-situationReferenceList :accessor %field-type-situationReferenceList :initform "situationReferenceList")
(situationReferenceList :accessor situationReferenceList)
) (:default-initargs :%type "whenDeclaration"))

(defclass whenDeclaration-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self whenDeclaration-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "whenDeclaration"))

(defclass situationReferenceList (stack-dsl::%map) () (:default-initargs :%type "situationReferenceList"))
(defmethod initialize-instance :after ((self situationReferenceList) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "situationReferenceName"))
(defclass situationReferenceList-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self situationReferenceList-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "situationReferenceList"))

(defclass situationReferenceName (stack-dsl::%compound-type) () (:default-initargs :%type "situationReferenceName"))
(defmethod initialize-instance :after ((self situationReferenceName) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("name")))
(defclass situationReferenceName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "situationReferenceName"))

(defclass methodDeclarationsAndScriptDeclarations (stack-dsl::%map) () (:default-initargs :%type "methodDeclarationsAndScriptDeclarations"))
(defmethod initialize-instance :after ((self methodDeclarationsAndScriptDeclarations) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "declarationMethodOrScript"))
(defclass methodDeclarationsAndScriptDeclarations-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self methodDeclarationsAndScriptDeclarations-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "methodDeclarationsAndScriptDeclarations"))

(defclass declarationMethodOrScript (stack-dsl::%compound-type) () (:default-initargs :%type "declarationMethodOrScript"))
(defmethod initialize-instance :after ((self declarationMethodOrScript) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("scriptDeclaration" "methodDeclaration")))
(defclass declarationMethodOrScript-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "declarationMethodOrScript"))

(defclass methodDeclaration (stack-dsl::%typed-value)
((%field-type-returnType :accessor %field-type-returnType :initform "returnType")
(returnType :accessor returnType)
(%field-type-formalList :accessor %field-type-formalList :initform "formalList")
(formalList :accessor formalList)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
(%field-type-esaKind :accessor %field-type-esaKind :initform "esaKind")
(esaKind :accessor esaKind)
) (:default-initargs :%type "methodDeclaration"))

(defclass methodDeclaration-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self methodDeclaration-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "methodDeclaration"))

(defclass scriptDeclaration (stack-dsl::%typed-value)
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
(implementation :accessor implementation)
(%field-type-returnType :accessor %field-type-returnType :initform "returnType")
(returnType :accessor returnType)
(%field-type-formalList :accessor %field-type-formalList :initform "formalList")
(formalList :accessor formalList)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
(%field-type-esaKind :accessor %field-type-esaKind :initform "esaKind")
(esaKind :accessor esaKind)
) (:default-initargs :%type "scriptDeclaration"))

(defclass scriptDeclaration-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self scriptDeclaration-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "scriptDeclaration"))

(defclass returnType (stack-dsl::%typed-value)
((%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
(%field-type-returnKind :accessor %field-type-returnKind :initform "returnKind")
(returnKind :accessor returnKind)
) (:default-initargs :%type "returnType"))

(defclass returnType-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self returnType-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "returnType"))


(defclass returnKind (stack-dsl::%enum) () (:default-initargs :%type "returnKind"))

(defmethod initialize-instance :after ((self returnKind) &key &allow-other-keys)
  (setf (stack-dsl::%value-list self) '("void" "simple" "map")))


(defclass returnKind-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self returnKind-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "returnKind"))
(defclass formalList (stack-dsl::%map) () (:default-initargs :%type "formalList"))
(defmethod initialize-instance :after ((self formalList) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "name"))
(defclass formalList-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self formalList-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "formalList"))

(defclass esaKind (stack-dsl::%compound-type) () (:default-initargs :%type "esaKind"))
(defmethod initialize-instance :after ((self esaKind) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("name")))
(defclass esaKind-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "esaKind"))


(defclass typeName (stack-dsl::%compound-type) () (:default-initargs :%type "typeName"))
(defmethod initialize-instance :after ((self typeName) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("name")))
(defclass typeName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "typeName"))

(defclass expression (stack-dsl::%typed-value)
((%field-type-object :accessor %field-type-object :initform "object")
(object :accessor object)
(%field-type-ekind :accessor %field-type-ekind :initform "ekind")
(ekind :accessor ekind)
) (:default-initargs :%type "expression"))

(defclass expression-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self expression-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "expression"))


(defclass ekind (stack-dsl::%enum) () (:default-initargs :%type "ekind"))

(defmethod initialize-instance :after ((self ekind) &key &allow-other-keys)
  (setf (stack-dsl::%value-list self) '("calledObject" "object" "false" "true")))


(defclass ekind-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self ekind-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "ekind"))
(defclass object (stack-dsl::%typed-value)
((%field-type-fieldMap :accessor %field-type-fieldMap :initform "fieldMap")
(fieldMap :accessor fieldMap)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
) (:default-initargs :%type "object"))

(defclass object-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self object-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "object"))

(defclass fieldMap (stack-dsl::%map) () (:default-initargs :%type "fieldMap"))
(defmethod initialize-instance :after ((self fieldMap) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "field"))
(defclass fieldMap-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self fieldMap-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "fieldMap"))
(defclass field (stack-dsl::%typed-value)
((%field-type-actualParameterList :accessor %field-type-actualParameterList :initform "actualParameterList")
(actualParameterList :accessor actualParameterList)
(%field-type-fkind :accessor %field-type-fkind :initform "fkind")
(fkind :accessor fkind)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
) (:default-initargs :%type "field"))

(defclass field-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self field-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "field"))


(defclass fkind (stack-dsl::%enum) () (:default-initargs :%type "fkind"))

(defmethod initialize-instance :after ((self fkind) &key &allow-other-keys)
  (setf (stack-dsl::%value-list self) '("simple" "map")))


(defclass fkind-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self fkind-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "fkind"))
(defclass actualParameterList (stack-dsl::%map) () (:default-initargs :%type "actualParameterList"))
(defmethod initialize-instance :after ((self actualParameterList) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "expression"))
(defclass actualParameterList-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self actualParameterList-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "actualParameterList"))

(defclass name (stack-dsl::%string) () (:default-initargs :%type "name"))
(defclass name-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self name-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "name"))

(defclass methodsTable (stack-dsl::%map) () (:default-initargs :%type "methodsTable"))
(defmethod initialize-instance :after ((self methodsTable) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "declarationMethodOrScript"))
(defclass methodsTable-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self methodsTable-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "methodsTable"))
(defclass externalMethod (stack-dsl::%typed-value)
((%field-type-returnType :accessor %field-type-returnType :initform "returnType")
(returnType :accessor returnType)
(%field-type-formalList :accessor %field-type-formalList :initform "formalList")
(formalList :accessor formalList)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
) (:default-initargs :%type "externalMethod"))

(defclass externalMethod-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self externalMethod-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "externalMethod"))

(defclass internalMethod (stack-dsl::%typed-value)
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
(implementation :accessor implementation)
(%field-type-returnType :accessor %field-type-returnType :initform "returnType")
(returnType :accessor returnType)
(%field-type-formalList :accessor %field-type-formalList :initform "formalList")
(formalList :accessor formalList)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
) (:default-initargs :%type "internalMethod"))

(defclass internalMethod-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self internalMethod-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "internalMethod"))

(defclass implementation (stack-dsl::%map) () (:default-initargs :%type "implementation"))
(defmethod initialize-instance :after ((self implementation) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "statement"))
(defclass implementation-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self implementation-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "implementation"))

(defclass statement (stack-dsl::%compound-type) () (:default-initargs :%type "statement"))
(defmethod initialize-instance :after ((self statement) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("returnValueStatement"
                                       "returnFalseStatement"
                                       "returnTrueStatement"
                                       "callExternalStatement"
                                       "callInternalStatement"
                                       "exitWhenStatement" "loopStatement"
                                       "ifStatement" "createStatement"
                                       "setStatement" "exitMapStatement"
                                       "mapStatement" "letStatement")))
(defclass statement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "statement"))

(defclass letStatement (stack-dsl::%typed-value)
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
(implementation :accessor implementation)
(%field-type-expression :accessor %field-type-expression :initform "expression")
(expression :accessor expression)
(%field-type-varName :accessor %field-type-varName :initform "varName")
(varName :accessor varName)
) (:default-initargs :%type "letStatement"))

(defclass letStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self letStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "letStatement"))

(defclass mapStatement (stack-dsl::%typed-value)
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
(implementation :accessor implementation)
(%field-type-expression :accessor %field-type-expression :initform "expression")
(expression :accessor expression)
(%field-type-varName :accessor %field-type-varName :initform "varName")
(varName :accessor varName)
) (:default-initargs :%type "mapStatement"))

(defclass mapStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self mapStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "mapStatement"))

(defclass exitMapStatement (stack-dsl::%typed-value)
((%field-type-filler :accessor %field-type-filler :initform "filler")
(filler :accessor filler)
) (:default-initargs :%type "exitMapStatement"))

(defclass exitMapStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self exitMapStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "exitMapStatement"))

(defclass setStatement (stack-dsl::%typed-value)
((%field-type-expression :accessor %field-type-expression :initform "expression")
(expression :accessor expression)
(%field-type-lval :accessor %field-type-lval :initform "lval")
(lval :accessor lval)
) (:default-initargs :%type "setStatement"))

(defclass setStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self setStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "setStatement"))

(defclass createStatement (stack-dsl::%typed-value)
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
(implementation :accessor implementation)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
(%field-type-indirectionKind :accessor %field-type-indirectionKind :initform "indirectionKind")
(indirectionKind :accessor indirectionKind)
(%field-type-varName :accessor %field-type-varName :initform "varName")
(varName :accessor varName)
) (:default-initargs :%type "createStatement"))

(defclass createStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self createStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "createStatement"))

(defclass ifStatement (stack-dsl::%typed-value)
((%field-type-elsePart :accessor %field-type-elsePart :initform "elsePart")
(elsePart :accessor elsePart)
(%field-type-thenPart :accessor %field-type-thenPart :initform "thenPart")
(thenPart :accessor thenPart)
(%field-type-expression :accessor %field-type-expression :initform "expression")
(expression :accessor expression)
) (:default-initargs :%type "ifStatement"))

(defclass ifStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self ifStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "ifStatement"))

(defclass loopStatement (stack-dsl::%typed-value)
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
(implementation :accessor implementation)
) (:default-initargs :%type "loopStatement"))

(defclass loopStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self loopStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "loopStatement"))

(defclass exitWhenStatement (stack-dsl::%typed-value)
((%field-type-expression :accessor %field-type-expression :initform "expression")
(expression :accessor expression)
) (:default-initargs :%type "exitWhenStatement"))

(defclass exitWhenStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self exitWhenStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "exitWhenStatement"))

(defclass returnTrueStatement (stack-dsl::%typed-value)
((%field-type-methodName :accessor %field-type-methodName :initform "methodName")
(methodName :accessor methodName)
) (:default-initargs :%type "returnTrueStatement"))

(defclass returnTrueStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self returnTrueStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "returnTrueStatement"))

(defclass returnFalseStatement (stack-dsl::%typed-value)
((%field-type-methodName :accessor %field-type-methodName :initform "methodName")
(methodName :accessor methodName)
) (:default-initargs :%type "returnFalseStatement"))

(defclass returnFalseStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self returnFalseStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "returnFalseStatement"))

(defclass returnValueStatement (stack-dsl::%typed-value)
((%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
(%field-type-methodName :accessor %field-type-methodName :initform "methodName")
(methodName :accessor methodName)
) (:default-initargs :%type "returnValueStatement"))

(defclass returnValueStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self returnValueStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "returnValueStatement"))

(defclass callInternalStatement (stack-dsl::%typed-value)
((%field-type-functionReference :accessor %field-type-functionReference :initform "functionReference")
(functionReference :accessor functionReference)
) (:default-initargs :%type "callInternalStatement"))

(defclass callInternalStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self callInternalStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "callInternalStatement"))

(defclass callExternalStatement (stack-dsl::%typed-value)
((%field-type-functionReference :accessor %field-type-functionReference :initform "functionReference")
(functionReference :accessor functionReference)
) (:default-initargs :%type "callExternalStatement"))

(defclass callExternalStatement-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self callExternalStatement-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "callExternalStatement"))


(defclass lval (stack-dsl::%compound-type) () (:default-initargs :%type "lval"))
(defmethod initialize-instance :after ((self lval) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("expression")))
(defclass lval-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "lval"))


(defclass varName (stack-dsl::%compound-type) () (:default-initargs :%type "varName"))
(defmethod initialize-instance :after ((self varName) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("name")))
(defclass varName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "varName"))


(defclass functionReference (stack-dsl::%compound-type) () (:default-initargs :%type "functionReference"))
(defmethod initialize-instance :after ((self functionReference) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("expression")))
(defclass functionReference-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "functionReference"))


(defclass thenPart (stack-dsl::%compound-type) () (:default-initargs :%type "thenPart"))
(defmethod initialize-instance :after ((self thenPart) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("implementation")))
(defclass thenPart-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "thenPart"))


(defclass elsePart (stack-dsl::%compound-type) () (:default-initargs :%type "elsePart"))
(defmethod initialize-instance :after ((self elsePart) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("implementation")))
(defclass elsePart-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "elsePart"))


(defclass indirectionKind (stack-dsl::%enum) () (:default-initargs :%type "indirectionKind"))

(defmethod initialize-instance :after ((self indirectionKind) &key &allow-other-keys)
  (setf (stack-dsl::%value-list self) '("direct" "indirect")))


(defclass indirectionKind-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self indirectionKind-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "indirectionKind"))

(defclass methodName (stack-dsl::%compound-type) () (:default-initargs :%type "methodName"))
(defmethod initialize-instance :after ((self methodName) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("name")))
(defclass methodName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "methodName"))


(defclass filler (stack-dsl::%compound-type) () (:default-initargs :%type "filler"))
(defmethod initialize-instance :after ((self filler) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("name")))
(defclass filler-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "filler"))



;; check forward types
(stack-dsl::%ensure-existence 'esaprogram)
(stack-dsl::%ensure-existence 'typeDecls)
(stack-dsl::%ensure-existence 'situations)
(stack-dsl::%ensure-existence 'classes)
(stack-dsl::%ensure-existence 'whenDeclarations)
(stack-dsl::%ensure-existence 'typeDecl)
(stack-dsl::%ensure-existence 'name)
(stack-dsl::%ensure-existence 'typeName)
(stack-dsl::%ensure-existence 'situationDefinition)
(stack-dsl::%ensure-existence 'esaclass)
(stack-dsl::%ensure-existence 'fieldMap)
(stack-dsl::%ensure-existence 'methodsTable)
(stack-dsl::%ensure-existence 'whenDeclaration)
(stack-dsl::%ensure-existence 'situationReferenceList)
(stack-dsl::%ensure-existence 'esaKind)
(stack-dsl::%ensure-existence 'methodDeclarationsAndScriptDeclarations)
(stack-dsl::%ensure-existence 'situationReferenceName)
(stack-dsl::%ensure-existence 'declarationMethodOrScript)
(stack-dsl::%ensure-existence 'methodDeclaration)
(stack-dsl::%ensure-existence 'scriptDeclaration)
(stack-dsl::%ensure-existence 'formalList)
(stack-dsl::%ensure-existence 'returnType)
(stack-dsl::%ensure-existence 'implementation)
(stack-dsl::%ensure-existence 'returnKind)
(stack-dsl::%ensure-existence 'expression)
(stack-dsl::%ensure-existence 'ekind)
(stack-dsl::%ensure-existence 'object)
(stack-dsl::%ensure-existence 'field)
(stack-dsl::%ensure-existence 'fkind)
(stack-dsl::%ensure-existence 'actualParameterList)
(stack-dsl::%ensure-existence 'externalMethod)
(stack-dsl::%ensure-existence 'internalMethod)
(stack-dsl::%ensure-existence 'statement)
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
(input-esaprogram :accessor input-esaprogram :initform (make-instance 'esaprogram-stack))
(output-esaprogram :accessor output-esaprogram :initform (make-instance 'esaprogram-stack))
(input-typeDecls :accessor input-typeDecls :initform (make-instance 'typeDecls-stack))
(output-typeDecls :accessor output-typeDecls :initform (make-instance 'typeDecls-stack))
(input-situations :accessor input-situations :initform (make-instance 'situations-stack))
(output-situations :accessor output-situations :initform (make-instance 'situations-stack))
(input-classes :accessor input-classes :initform (make-instance 'classes-stack))
(output-classes :accessor output-classes :initform (make-instance 'classes-stack))
(input-whenDeclarations :accessor input-whenDeclarations :initform (make-instance 'whenDeclarations-stack))
(output-whenDeclarations :accessor output-whenDeclarations :initform (make-instance 'whenDeclarations-stack))
(input-typeDecl :accessor input-typeDecl :initform (make-instance 'typeDecl-stack))
(output-typeDecl :accessor output-typeDecl :initform (make-instance 'typeDecl-stack))
(input-name :accessor input-name :initform (make-instance 'name-stack))
(output-name :accessor output-name :initform (make-instance 'name-stack))
(input-typeName :accessor input-typeName :initform (make-instance 'typeName-stack))
(output-typeName :accessor output-typeName :initform (make-instance 'typeName-stack))
(input-situationDefinition :accessor input-situationDefinition :initform (make-instance 'situationDefinition-stack))
(output-situationDefinition :accessor output-situationDefinition :initform (make-instance 'situationDefinition-stack))
(input-esaclass :accessor input-esaclass :initform (make-instance 'esaclass-stack))
(output-esaclass :accessor output-esaclass :initform (make-instance 'esaclass-stack))
(input-fieldMap :accessor input-fieldMap :initform (make-instance 'fieldMap-stack))
(output-fieldMap :accessor output-fieldMap :initform (make-instance 'fieldMap-stack))
(input-methodsTable :accessor input-methodsTable :initform (make-instance 'methodsTable-stack))
(output-methodsTable :accessor output-methodsTable :initform (make-instance 'methodsTable-stack))
(input-whenDeclaration :accessor input-whenDeclaration :initform (make-instance 'whenDeclaration-stack))
(output-whenDeclaration :accessor output-whenDeclaration :initform (make-instance 'whenDeclaration-stack))
(input-situationReferenceList :accessor input-situationReferenceList :initform (make-instance 'situationReferenceList-stack))
(output-situationReferenceList :accessor output-situationReferenceList :initform (make-instance 'situationReferenceList-stack))
(input-esaKind :accessor input-esaKind :initform (make-instance 'esaKind-stack))
(output-esaKind :accessor output-esaKind :initform (make-instance 'esaKind-stack))
(input-methodDeclarationsAndScriptDeclarations :accessor input-methodDeclarationsAndScriptDeclarations :initform (make-instance 'methodDeclarationsAndScriptDeclarations-stack))
(output-methodDeclarationsAndScriptDeclarations :accessor output-methodDeclarationsAndScriptDeclarations :initform (make-instance 'methodDeclarationsAndScriptDeclarations-stack))
(input-situationReferenceName :accessor input-situationReferenceName :initform (make-instance 'situationReferenceName-stack))
(output-situationReferenceName :accessor output-situationReferenceName :initform (make-instance 'situationReferenceName-stack))
(input-declarationMethodOrScript :accessor input-declarationMethodOrScript :initform (make-instance 'declarationMethodOrScript-stack))
(output-declarationMethodOrScript :accessor output-declarationMethodOrScript :initform (make-instance 'declarationMethodOrScript-stack))
(input-methodDeclaration :accessor input-methodDeclaration :initform (make-instance 'methodDeclaration-stack))
(output-methodDeclaration :accessor output-methodDeclaration :initform (make-instance 'methodDeclaration-stack))
(input-scriptDeclaration :accessor input-scriptDeclaration :initform (make-instance 'scriptDeclaration-stack))
(output-scriptDeclaration :accessor output-scriptDeclaration :initform (make-instance 'scriptDeclaration-stack))
(input-formalList :accessor input-formalList :initform (make-instance 'formalList-stack))
(output-formalList :accessor output-formalList :initform (make-instance 'formalList-stack))
(input-returnType :accessor input-returnType :initform (make-instance 'returnType-stack))
(output-returnType :accessor output-returnType :initform (make-instance 'returnType-stack))
(input-implementation :accessor input-implementation :initform (make-instance 'implementation-stack))
(output-implementation :accessor output-implementation :initform (make-instance 'implementation-stack))
(input-returnKind :accessor input-returnKind :initform (make-instance 'returnKind-stack))
(output-returnKind :accessor output-returnKind :initform (make-instance 'returnKind-stack))
(input-expression :accessor input-expression :initform (make-instance 'expression-stack))
(output-expression :accessor output-expression :initform (make-instance 'expression-stack))
(input-ekind :accessor input-ekind :initform (make-instance 'ekind-stack))
(output-ekind :accessor output-ekind :initform (make-instance 'ekind-stack))
(input-object :accessor input-object :initform (make-instance 'object-stack))
(output-object :accessor output-object :initform (make-instance 'object-stack))
(input-field :accessor input-field :initform (make-instance 'field-stack))
(output-field :accessor output-field :initform (make-instance 'field-stack))
(input-fkind :accessor input-fkind :initform (make-instance 'fkind-stack))
(output-fkind :accessor output-fkind :initform (make-instance 'fkind-stack))
(input-actualParameterList :accessor input-actualParameterList :initform (make-instance 'actualParameterList-stack))
(output-actualParameterList :accessor output-actualParameterList :initform (make-instance 'actualParameterList-stack))
(input-externalMethod :accessor input-externalMethod :initform (make-instance 'externalMethod-stack))
(output-externalMethod :accessor output-externalMethod :initform (make-instance 'externalMethod-stack))
(input-internalMethod :accessor input-internalMethod :initform (make-instance 'internalMethod-stack))
(output-internalMethod :accessor output-internalMethod :initform (make-instance 'internalMethod-stack))
(input-statement :accessor input-statement :initform (make-instance 'statement-stack))
(output-statement :accessor output-statement :initform (make-instance 'statement-stack))
(input-letStatement :accessor input-letStatement :initform (make-instance 'letStatement-stack))
(output-letStatement :accessor output-letStatement :initform (make-instance 'letStatement-stack))
(input-mapStatement :accessor input-mapStatement :initform (make-instance 'mapStatement-stack))
(output-mapStatement :accessor output-mapStatement :initform (make-instance 'mapStatement-stack))
(input-exitMapStatement :accessor input-exitMapStatement :initform (make-instance 'exitMapStatement-stack))
(output-exitMapStatement :accessor output-exitMapStatement :initform (make-instance 'exitMapStatement-stack))
(input-setStatement :accessor input-setStatement :initform (make-instance 'setStatement-stack))
(output-setStatement :accessor output-setStatement :initform (make-instance 'setStatement-stack))
(input-createStatement :accessor input-createStatement :initform (make-instance 'createStatement-stack))
(output-createStatement :accessor output-createStatement :initform (make-instance 'createStatement-stack))
(input-ifStatement :accessor input-ifStatement :initform (make-instance 'ifStatement-stack))
(output-ifStatement :accessor output-ifStatement :initform (make-instance 'ifStatement-stack))
(input-loopStatement :accessor input-loopStatement :initform (make-instance 'loopStatement-stack))
(output-loopStatement :accessor output-loopStatement :initform (make-instance 'loopStatement-stack))
(input-exitWhenStatement :accessor input-exitWhenStatement :initform (make-instance 'exitWhenStatement-stack))
(output-exitWhenStatement :accessor output-exitWhenStatement :initform (make-instance 'exitWhenStatement-stack))
(input-callInternalStatement :accessor input-callInternalStatement :initform (make-instance 'callInternalStatement-stack))
(output-callInternalStatement :accessor output-callInternalStatement :initform (make-instance 'callInternalStatement-stack))
(input-callExternalStatement :accessor input-callExternalStatement :initform (make-instance 'callExternalStatement-stack))
(output-callExternalStatement :accessor output-callExternalStatement :initform (make-instance 'callExternalStatement-stack))
(input-returnTrueStatement :accessor input-returnTrueStatement :initform (make-instance 'returnTrueStatement-stack))
(output-returnTrueStatement :accessor output-returnTrueStatement :initform (make-instance 'returnTrueStatement-stack))
(input-returnFalseStatement :accessor input-returnFalseStatement :initform (make-instance 'returnFalseStatement-stack))
(output-returnFalseStatement :accessor output-returnFalseStatement :initform (make-instance 'returnFalseStatement-stack))
(input-returnValueStatement :accessor input-returnValueStatement :initform (make-instance 'returnValueStatement-stack))
(output-returnValueStatement :accessor output-returnValueStatement :initform (make-instance 'returnValueStatement-stack))
(input-varName :accessor input-varName :initform (make-instance 'varName-stack))
(output-varName :accessor output-varName :initform (make-instance 'varName-stack))
(input-filler :accessor input-filler :initform (make-instance 'filler-stack))
(output-filler :accessor output-filler :initform (make-instance 'filler-stack))
(input-lval :accessor input-lval :initform (make-instance 'lval-stack))
(output-lval :accessor output-lval :initform (make-instance 'lval-stack))
(input-indirectionKind :accessor input-indirectionKind :initform (make-instance 'indirectionKind-stack))
(output-indirectionKind :accessor output-indirectionKind :initform (make-instance 'indirectionKind-stack))
(input-thenPart :accessor input-thenPart :initform (make-instance 'thenPart-stack))
(output-thenPart :accessor output-thenPart :initform (make-instance 'thenPart-stack))
(input-elsePart :accessor input-elsePart :initform (make-instance 'elsePart-stack))
(output-elsePart :accessor output-elsePart :initform (make-instance 'elsePart-stack))
(input-methodName :accessor input-methodName :initform (make-instance 'methodName-stack))
(output-methodName :accessor output-methodName :initform (make-instance 'methodName-stack))
(input-functionReference :accessor input-functionReference :initform (make-instance 'functionReference-stack))
(output-functionReference :accessor output-functionReference :initform (make-instance 'functionReference-stack))
))

(defmethod %memoStacks ((self environment))
(setf (%water-mark self)
(list
(stack-dsl::%stack (input-esaprogram self))
(stack-dsl::%stack (output-esaprogram self))
(stack-dsl::%stack (input-typeDecls self))
(stack-dsl::%stack (output-typeDecls self))
(stack-dsl::%stack (input-situations self))
(stack-dsl::%stack (output-situations self))
(stack-dsl::%stack (input-classes self))
(stack-dsl::%stack (output-classes self))
(stack-dsl::%stack (input-whenDeclarations self))
(stack-dsl::%stack (output-whenDeclarations self))
(stack-dsl::%stack (input-typeDecl self))
(stack-dsl::%stack (output-typeDecl self))
(stack-dsl::%stack (input-name self))
(stack-dsl::%stack (output-name self))
(stack-dsl::%stack (input-typeName self))
(stack-dsl::%stack (output-typeName self))
(stack-dsl::%stack (input-situationDefinition self))
(stack-dsl::%stack (output-situationDefinition self))
(stack-dsl::%stack (input-esaclass self))
(stack-dsl::%stack (output-esaclass self))
(stack-dsl::%stack (input-fieldMap self))
(stack-dsl::%stack (output-fieldMap self))
(stack-dsl::%stack (input-methodsTable self))
(stack-dsl::%stack (output-methodsTable self))
(stack-dsl::%stack (input-whenDeclaration self))
(stack-dsl::%stack (output-whenDeclaration self))
(stack-dsl::%stack (input-situationReferenceList self))
(stack-dsl::%stack (output-situationReferenceList self))
(stack-dsl::%stack (input-esaKind self))
(stack-dsl::%stack (output-esaKind self))
(stack-dsl::%stack (input-methodDeclarationsAndScriptDeclarations self))
(stack-dsl::%stack (output-methodDeclarationsAndScriptDeclarations self))
(stack-dsl::%stack (input-situationReferenceName self))
(stack-dsl::%stack (output-situationReferenceName self))
(stack-dsl::%stack (input-declarationMethodOrScript self))
(stack-dsl::%stack (output-declarationMethodOrScript self))
(stack-dsl::%stack (input-methodDeclaration self))
(stack-dsl::%stack (output-methodDeclaration self))
(stack-dsl::%stack (input-scriptDeclaration self))
(stack-dsl::%stack (output-scriptDeclaration self))
(stack-dsl::%stack (input-formalList self))
(stack-dsl::%stack (output-formalList self))
(stack-dsl::%stack (input-returnType self))
(stack-dsl::%stack (output-returnType self))
(stack-dsl::%stack (input-implementation self))
(stack-dsl::%stack (output-implementation self))
(stack-dsl::%stack (input-returnKind self))
(stack-dsl::%stack (output-returnKind self))
(stack-dsl::%stack (input-expression self))
(stack-dsl::%stack (output-expression self))
(stack-dsl::%stack (input-ekind self))
(stack-dsl::%stack (output-ekind self))
(stack-dsl::%stack (input-object self))
(stack-dsl::%stack (output-object self))
(stack-dsl::%stack (input-field self))
(stack-dsl::%stack (output-field self))
(stack-dsl::%stack (input-fkind self))
(stack-dsl::%stack (output-fkind self))
(stack-dsl::%stack (input-actualParameterList self))
(stack-dsl::%stack (output-actualParameterList self))
(stack-dsl::%stack (input-externalMethod self))
(stack-dsl::%stack (output-externalMethod self))
(stack-dsl::%stack (input-internalMethod self))
(stack-dsl::%stack (output-internalMethod self))
(stack-dsl::%stack (input-statement self))
(stack-dsl::%stack (output-statement self))
(stack-dsl::%stack (input-letStatement self))
(stack-dsl::%stack (output-letStatement self))
(stack-dsl::%stack (input-mapStatement self))
(stack-dsl::%stack (output-mapStatement self))
(stack-dsl::%stack (input-exitMapStatement self))
(stack-dsl::%stack (output-exitMapStatement self))
(stack-dsl::%stack (input-setStatement self))
(stack-dsl::%stack (output-setStatement self))
(stack-dsl::%stack (input-createStatement self))
(stack-dsl::%stack (output-createStatement self))
(stack-dsl::%stack (input-ifStatement self))
(stack-dsl::%stack (output-ifStatement self))
(stack-dsl::%stack (input-loopStatement self))
(stack-dsl::%stack (output-loopStatement self))
(stack-dsl::%stack (input-exitWhenStatement self))
(stack-dsl::%stack (output-exitWhenStatement self))
(stack-dsl::%stack (input-callInternalStatement self))
(stack-dsl::%stack (output-callInternalStatement self))
(stack-dsl::%stack (input-callExternalStatement self))
(stack-dsl::%stack (output-callExternalStatement self))
(stack-dsl::%stack (input-returnTrueStatement self))
(stack-dsl::%stack (output-returnTrueStatement self))
(stack-dsl::%stack (input-returnFalseStatement self))
(stack-dsl::%stack (output-returnFalseStatement self))
(stack-dsl::%stack (input-returnValueStatement self))
(stack-dsl::%stack (output-returnValueStatement self))
(stack-dsl::%stack (input-varName self))
(stack-dsl::%stack (output-varName self))
(stack-dsl::%stack (input-filler self))
(stack-dsl::%stack (output-filler self))
(stack-dsl::%stack (input-lval self))
(stack-dsl::%stack (output-lval self))
(stack-dsl::%stack (input-indirectionKind self))
(stack-dsl::%stack (output-indirectionKind self))
(stack-dsl::%stack (input-thenPart self))
(stack-dsl::%stack (output-thenPart self))
(stack-dsl::%stack (input-elsePart self))
(stack-dsl::%stack (output-elsePart self))
(stack-dsl::%stack (input-methodName self))
(stack-dsl::%stack (output-methodName self))
(stack-dsl::%stack (input-functionReference self))
(stack-dsl::%stack (output-functionReference self))
)))


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
(let ((in-eq (eq (nth 0 wm) (stack-dsl::%stack (input-esaprogram self))))
      (out-eq (eq (nth 1 wm) (stack-dsl::%stack (output-esaprogram self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 2 wm) (stack-dsl::%stack (input-typeDecls self))))
      (out-eq (eq (nth 3 wm) (stack-dsl::%stack (output-typeDecls self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 4 wm) (stack-dsl::%stack (input-situations self))))
      (out-eq (eq (nth 5 wm) (stack-dsl::%stack (output-situations self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 6 wm) (stack-dsl::%stack (input-classes self))))
      (out-eq (eq (nth 7 wm) (stack-dsl::%stack (output-classes self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 8 wm) (stack-dsl::%stack (input-whenDeclarations self))))
      (out-eq (eq (nth 9 wm) (stack-dsl::%stack (output-whenDeclarations self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 10 wm) (stack-dsl::%stack (input-typeDecl self))))
      (out-eq (eq (nth 11 wm) (stack-dsl::%stack (output-typeDecl self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 12 wm) (stack-dsl::%stack (input-name self))))
      (out-eq (eq (nth 13 wm) (stack-dsl::%stack (output-name self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 14 wm) (stack-dsl::%stack (input-typeName self))))
      (out-eq (eq (nth 15 wm) (stack-dsl::%stack (output-typeName self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 16 wm) (stack-dsl::%stack (input-situationDefinition self))))
      (out-eq (eq (nth 17 wm) (stack-dsl::%stack (output-situationDefinition self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 18 wm) (stack-dsl::%stack (input-esaclass self))))
      (out-eq (eq (nth 19 wm) (stack-dsl::%stack (output-esaclass self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 20 wm) (stack-dsl::%stack (input-fieldMap self))))
      (out-eq (eq (nth 21 wm) (stack-dsl::%stack (output-fieldMap self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 22 wm) (stack-dsl::%stack (input-methodsTable self))))
      (out-eq (eq (nth 23 wm) (stack-dsl::%stack (output-methodsTable self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 24 wm) (stack-dsl::%stack (input-whenDeclaration self))))
      (out-eq (eq (nth 25 wm) (stack-dsl::%stack (output-whenDeclaration self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 26 wm) (stack-dsl::%stack (input-situationReferenceList self))))
      (out-eq (eq (nth 27 wm) (stack-dsl::%stack (output-situationReferenceList self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 28 wm) (stack-dsl::%stack (input-esaKind self))))
      (out-eq (eq (nth 29 wm) (stack-dsl::%stack (output-esaKind self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 30 wm) (stack-dsl::%stack (input-methodDeclarationsAndScriptDeclarations self))))
      (out-eq (eq (nth 31 wm) (stack-dsl::%stack (output-methodDeclarationsAndScriptDeclarations self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 32 wm) (stack-dsl::%stack (input-situationReferenceName self))))
      (out-eq (eq (nth 33 wm) (stack-dsl::%stack (output-situationReferenceName self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 34 wm) (stack-dsl::%stack (input-declarationMethodOrScript self))))
      (out-eq (eq (nth 35 wm) (stack-dsl::%stack (output-declarationMethodOrScript self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 36 wm) (stack-dsl::%stack (input-methodDeclaration self))))
      (out-eq (eq (nth 37 wm) (stack-dsl::%stack (output-methodDeclaration self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 38 wm) (stack-dsl::%stack (input-scriptDeclaration self))))
      (out-eq (eq (nth 39 wm) (stack-dsl::%stack (output-scriptDeclaration self)))))
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
(let ((in-eq (eq (nth 48 wm) (stack-dsl::%stack (input-expression self))))
      (out-eq (eq (nth 49 wm) (stack-dsl::%stack (output-expression self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 50 wm) (stack-dsl::%stack (input-ekind self))))
      (out-eq (eq (nth 51 wm) (stack-dsl::%stack (output-ekind self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 52 wm) (stack-dsl::%stack (input-object self))))
      (out-eq (eq (nth 53 wm) (stack-dsl::%stack (output-object self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 54 wm) (stack-dsl::%stack (input-field self))))
      (out-eq (eq (nth 55 wm) (stack-dsl::%stack (output-field self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 56 wm) (stack-dsl::%stack (input-fkind self))))
      (out-eq (eq (nth 57 wm) (stack-dsl::%stack (output-fkind self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 58 wm) (stack-dsl::%stack (input-actualParameterList self))))
      (out-eq (eq (nth 59 wm) (stack-dsl::%stack (output-actualParameterList self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 60 wm) (stack-dsl::%stack (input-externalMethod self))))
      (out-eq (eq (nth 61 wm) (stack-dsl::%stack (output-externalMethod self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 62 wm) (stack-dsl::%stack (input-internalMethod self))))
      (out-eq (eq (nth 63 wm) (stack-dsl::%stack (output-internalMethod self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 64 wm) (stack-dsl::%stack (input-statement self))))
      (out-eq (eq (nth 65 wm) (stack-dsl::%stack (output-statement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 66 wm) (stack-dsl::%stack (input-letStatement self))))
      (out-eq (eq (nth 67 wm) (stack-dsl::%stack (output-letStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 68 wm) (stack-dsl::%stack (input-mapStatement self))))
      (out-eq (eq (nth 69 wm) (stack-dsl::%stack (output-mapStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 70 wm) (stack-dsl::%stack (input-exitMapStatement self))))
      (out-eq (eq (nth 71 wm) (stack-dsl::%stack (output-exitMapStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 72 wm) (stack-dsl::%stack (input-setStatement self))))
      (out-eq (eq (nth 73 wm) (stack-dsl::%stack (output-setStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 74 wm) (stack-dsl::%stack (input-createStatement self))))
      (out-eq (eq (nth 75 wm) (stack-dsl::%stack (output-createStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 76 wm) (stack-dsl::%stack (input-ifStatement self))))
      (out-eq (eq (nth 77 wm) (stack-dsl::%stack (output-ifStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 78 wm) (stack-dsl::%stack (input-loopStatement self))))
      (out-eq (eq (nth 79 wm) (stack-dsl::%stack (output-loopStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 80 wm) (stack-dsl::%stack (input-exitWhenStatement self))))
      (out-eq (eq (nth 81 wm) (stack-dsl::%stack (output-exitWhenStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 82 wm) (stack-dsl::%stack (input-callInternalStatement self))))
      (out-eq (eq (nth 83 wm) (stack-dsl::%stack (output-callInternalStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 84 wm) (stack-dsl::%stack (input-callExternalStatement self))))
      (out-eq (eq (nth 85 wm) (stack-dsl::%stack (output-callExternalStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 86 wm) (stack-dsl::%stack (input-returnTrueStatement self))))
      (out-eq (eq (nth 87 wm) (stack-dsl::%stack (output-returnTrueStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 88 wm) (stack-dsl::%stack (input-returnFalseStatement self))))
      (out-eq (eq (nth 89 wm) (stack-dsl::%stack (output-returnFalseStatement self)))))
  (and in-eq out-eq))
(let ((in-eq (eq (nth 90 wm) (stack-dsl::%stack (input-returnValueStatement self))))
      (out-eq (eq (nth 91 wm) (stack-dsl::%stack (output-returnValueStatement self)))))
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
  (and in-eq out-eq))
)))

(unless r (error "stack depth incorrect")))))
