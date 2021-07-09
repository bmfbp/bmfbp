





































































































                                       "callExternalStatement"
                                       "callInternalStatement"
                                       "exitWhenStatement" "loopStatement"
                                       "ifStatement" "createStatement"
                                       "mapStatement" "letStatement")))
                                       "returnFalseStatement"
                                       "returnTrueStatement"
                                       "setStatement" "exitMapStatement"
      (out-eq (eq (nth 1 wm) (stack-dsl::%stack (output-esaprogram self)))))
      (out-eq (eq (nth 101 wm) (stack-dsl::%stack (output-thenPart self)))))
      (out-eq (eq (nth 103 wm) (stack-dsl::%stack (output-elsePart self)))))
      (out-eq (eq (nth 105 wm) (stack-dsl::%stack (output-methodName self)))))
      (out-eq (eq (nth 107 wm) (stack-dsl::%stack (output-functionReference self)))))
      (out-eq (eq (nth 11 wm) (stack-dsl::%stack (output-typeDecl self)))))
      (out-eq (eq (nth 13 wm) (stack-dsl::%stack (output-name self)))))
      (out-eq (eq (nth 15 wm) (stack-dsl::%stack (output-typeName self)))))
      (out-eq (eq (nth 17 wm) (stack-dsl::%stack (output-situationDefinition self)))))
      (out-eq (eq (nth 19 wm) (stack-dsl::%stack (output-esaclass self)))))
      (out-eq (eq (nth 21 wm) (stack-dsl::%stack (output-fieldMap self)))))
      (out-eq (eq (nth 23 wm) (stack-dsl::%stack (output-methodsTable self)))))
      (out-eq (eq (nth 25 wm) (stack-dsl::%stack (output-whenDeclaration self)))))
      (out-eq (eq (nth 27 wm) (stack-dsl::%stack (output-situationReferenceList self)))))
      (out-eq (eq (nth 29 wm) (stack-dsl::%stack (output-esaKind self)))))
      (out-eq (eq (nth 3 wm) (stack-dsl::%stack (output-typeDecls self)))))
      (out-eq (eq (nth 31 wm) (stack-dsl::%stack (output-methodDeclarationsAndScriptDeclarations self)))))
      (out-eq (eq (nth 33 wm) (stack-dsl::%stack (output-situationReferenceName self)))))
      (out-eq (eq (nth 35 wm) (stack-dsl::%stack (output-declarationMethodOrScript self)))))
      (out-eq (eq (nth 37 wm) (stack-dsl::%stack (output-methodDeclaration self)))))
      (out-eq (eq (nth 39 wm) (stack-dsl::%stack (output-scriptDeclaration self)))))
      (out-eq (eq (nth 41 wm) (stack-dsl::%stack (output-formalList self)))))
      (out-eq (eq (nth 43 wm) (stack-dsl::%stack (output-returnType self)))))
      (out-eq (eq (nth 45 wm) (stack-dsl::%stack (output-implementation self)))))
      (out-eq (eq (nth 47 wm) (stack-dsl::%stack (output-returnKind self)))))
      (out-eq (eq (nth 49 wm) (stack-dsl::%stack (output-expression self)))))
      (out-eq (eq (nth 5 wm) (stack-dsl::%stack (output-situations self)))))
      (out-eq (eq (nth 51 wm) (stack-dsl::%stack (output-ekind self)))))
      (out-eq (eq (nth 53 wm) (stack-dsl::%stack (output-object self)))))
      (out-eq (eq (nth 55 wm) (stack-dsl::%stack (output-field self)))))
      (out-eq (eq (nth 57 wm) (stack-dsl::%stack (output-fkind self)))))
      (out-eq (eq (nth 59 wm) (stack-dsl::%stack (output-actualParameterList self)))))
      (out-eq (eq (nth 61 wm) (stack-dsl::%stack (output-externalMethod self)))))
      (out-eq (eq (nth 63 wm) (stack-dsl::%stack (output-internalMethod self)))))
      (out-eq (eq (nth 65 wm) (stack-dsl::%stack (output-statement self)))))
      (out-eq (eq (nth 67 wm) (stack-dsl::%stack (output-letStatement self)))))
      (out-eq (eq (nth 69 wm) (stack-dsl::%stack (output-mapStatement self)))))
      (out-eq (eq (nth 7 wm) (stack-dsl::%stack (output-classes self)))))
      (out-eq (eq (nth 71 wm) (stack-dsl::%stack (output-exitMapStatement self)))))
      (out-eq (eq (nth 73 wm) (stack-dsl::%stack (output-setStatement self)))))
      (out-eq (eq (nth 75 wm) (stack-dsl::%stack (output-createStatement self)))))
      (out-eq (eq (nth 77 wm) (stack-dsl::%stack (output-ifStatement self)))))
      (out-eq (eq (nth 79 wm) (stack-dsl::%stack (output-loopStatement self)))))
      (out-eq (eq (nth 81 wm) (stack-dsl::%stack (output-exitWhenStatement self)))))
      (out-eq (eq (nth 83 wm) (stack-dsl::%stack (output-callInternalStatement self)))))
      (out-eq (eq (nth 85 wm) (stack-dsl::%stack (output-callExternalStatement self)))))
      (out-eq (eq (nth 87 wm) (stack-dsl::%stack (output-returnTrueStatement self)))))
      (out-eq (eq (nth 89 wm) (stack-dsl::%stack (output-returnFalseStatement self)))))
      (out-eq (eq (nth 9 wm) (stack-dsl::%stack (output-whenDeclarations self)))))
      (out-eq (eq (nth 91 wm) (stack-dsl::%stack (output-returnValueStatement self)))))
      (out-eq (eq (nth 93 wm) (stack-dsl::%stack (output-varName self)))))
      (out-eq (eq (nth 95 wm) (stack-dsl::%stack (output-filler self)))))
      (out-eq (eq (nth 97 wm) (stack-dsl::%stack (output-lval self)))))
      (out-eq (eq (nth 99 wm) (stack-dsl::%stack (output-indirectionKind self)))))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (and in-eq out-eq))
  (setf (stack-dsl::%element-type self) "%bag"))
  (setf (stack-dsl::%element-type self) "%map"))(defmethod initialize-instance :after ((self %bag-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "callExternalStatement"))
  (setf (stack-dsl::%element-type self) "callInternalStatement"))
  (setf (stack-dsl::%element-type self) "createStatement"))
  (setf (stack-dsl::%element-type self) "ekind"))
  (setf (stack-dsl::%element-type self) "esaclass"))
  (setf (stack-dsl::%element-type self) "esaprogram"))
  (setf (stack-dsl::%element-type self) "exitMapStatement"))
  (setf (stack-dsl::%element-type self) "exitWhenStatement"))
  (setf (stack-dsl::%element-type self) "expression"))
  (setf (stack-dsl::%element-type self) "externalMethod"))
  (setf (stack-dsl::%element-type self) "field"))
  (setf (stack-dsl::%element-type self) "fkind"))
  (setf (stack-dsl::%element-type self) "ifStatement"))
  (setf (stack-dsl::%element-type self) "indirectionKind"))
  (setf (stack-dsl::%element-type self) "internalMethod"))
  (setf (stack-dsl::%element-type self) "letStatement"))
  (setf (stack-dsl::%element-type self) "loopStatement"))
  (setf (stack-dsl::%element-type self) "mapStatement"))
  (setf (stack-dsl::%element-type self) "methodDeclaration"))
  (setf (stack-dsl::%element-type self) "name"))
  (setf (stack-dsl::%element-type self) "object"))
  (setf (stack-dsl::%element-type self) "returnFalseStatement"))
  (setf (stack-dsl::%element-type self) "returnKind"))
  (setf (stack-dsl::%element-type self) "returnTrueStatement"))
  (setf (stack-dsl::%element-type self) "returnType"))
  (setf (stack-dsl::%element-type self) "returnValueStatement"))
  (setf (stack-dsl::%element-type self) "scriptDeclaration"))
  (setf (stack-dsl::%element-type self) "setStatement"))
  (setf (stack-dsl::%element-type self) "typeDecl"))
  (setf (stack-dsl::%element-type self) "whenDeclaration"))
  (setf (stack-dsl::%type-list self) '("expression")))
  (setf (stack-dsl::%type-list self) '("expression")))
  (setf (stack-dsl::%type-list self) '("implementation")))
  (setf (stack-dsl::%type-list self) '("implementation")))
  (setf (stack-dsl::%type-list self) '("name")))
  (setf (stack-dsl::%type-list self) '("name")))
  (setf (stack-dsl::%type-list self) '("name")))
  (setf (stack-dsl::%type-list self) '("name")))
  (setf (stack-dsl::%type-list self) '("name")))
  (setf (stack-dsl::%type-list self) '("name")))
  (setf (stack-dsl::%type-list self) '("name")))
  (setf (stack-dsl::%type-list self) '("returnValueStatement"
  (setf (stack-dsl::%type-list self) '("scriptDeclaration" "methodDeclaration")))
  (setf (stack-dsl::%value-list self) '("calledObject" "object" "false" "true")))
  (setf (stack-dsl::%value-list self) '("direct" "indirect")))
  (setf (stack-dsl::%value-list self) '("simple" "map")))
  (setf (stack-dsl::%value-list self) '("void" "simple" "map")))
 (defmethod initialize-instance :after ((self actualParameterList-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self classes-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self fieldMap-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self formalList-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self implementation-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self methodDeclarationsAndScriptDeclarations-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self methodsTable-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self situationReferenceList-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self situations-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self typeDecls-stack) &key &allow-other-keys)
 (defmethod initialize-instance :after ((self whenDeclarations-stack) &key &allow-other-keys)
(%field-type-classes :accessor %field-type-classes :initform "classes")
(%field-type-ekind :accessor %field-type-ekind :initform "ekind")
(%field-type-esaKind :accessor %field-type-esaKind :initform "esaKind")
(%field-type-esaKind :accessor %field-type-esaKind :initform "esaKind")
(%field-type-esaKind :accessor %field-type-esaKind :initform "esaKind")
(%field-type-expression :accessor %field-type-expression :initform "expression")
(%field-type-expression :accessor %field-type-expression :initform "expression")
(%field-type-expression :accessor %field-type-expression :initform "expression")
(%field-type-fieldMap :accessor %field-type-fieldMap :initform "fieldMap")
(%field-type-fkind :accessor %field-type-fkind :initform "fkind")
(%field-type-formalList :accessor %field-type-formalList :initform "formalList")
(%field-type-formalList :accessor %field-type-formalList :initform "formalList")
(%field-type-formalList :accessor %field-type-formalList :initform "formalList")
(%field-type-formalList :accessor %field-type-formalList :initform "formalList")
(%field-type-indirectionKind :accessor %field-type-indirectionKind :initform "indirectionKind")
(%field-type-lval :accessor %field-type-lval :initform "lval")
(%field-type-methodName :accessor %field-type-methodName :initform "methodName")
(%field-type-name :accessor %field-type-name :initform "name")
(%field-type-name :accessor %field-type-name :initform "name")
(%field-type-name :accessor %field-type-name :initform "name")
(%field-type-name :accessor %field-type-name :initform "name")
(%field-type-name :accessor %field-type-name :initform "name")
(%field-type-name :accessor %field-type-name :initform "name")
(%field-type-name :accessor %field-type-name :initform "name")
(%field-type-name :accessor %field-type-name :initform "name")
(%field-type-name :accessor %field-type-name :initform "name")
(%field-type-returnKind :accessor %field-type-returnKind :initform "returnKind")
(%field-type-returnType :accessor %field-type-returnType :initform "returnType")
(%field-type-returnType :accessor %field-type-returnType :initform "returnType")
(%field-type-situationReferenceList :accessor %field-type-situationReferenceList :initform "situationReferenceList")
(%field-type-situations :accessor %field-type-situations :initform "situations")
(%field-type-thenPart :accessor %field-type-thenPart :initform "thenPart")
(%field-type-typeDecls :accessor %field-type-typeDecls :initform "typeDecls")
(%field-type-varName :accessor %field-type-varName :initform "varName")
(%field-type-varName :accessor %field-type-varName :initform "varName")
(%field-type-varName :accessor %field-type-varName :initform "varName")
((%field-type-actualParameterList :accessor %field-type-actualParameterList :initform "actualParameterList")
((%field-type-elsePart :accessor %field-type-elsePart :initform "elsePart")
((%field-type-expression :accessor %field-type-expression :initform "expression")
((%field-type-expression :accessor %field-type-expression :initform "expression")
((%field-type-fieldMap :accessor %field-type-fieldMap :initform "fieldMap")
((%field-type-filler :accessor %field-type-filler :initform "filler")
((%field-type-functionReference :accessor %field-type-functionReference :initform "functionReference")
((%field-type-functionReference :accessor %field-type-functionReference :initform "functionReference")
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
((%field-type-implementation :accessor %field-type-implementation :initform "implementation")
((%field-type-methodDeclarationsAndScriptDeclarations :accessor %field-type-methodDeclarationsAndScriptDeclarations :initform "methodDeclarationsAndScriptDeclarations")
((%field-type-methodName :accessor %field-type-methodName :initform "methodName")
((%field-type-methodName :accessor %field-type-methodName :initform "methodName")
((%field-type-methodsTable :accessor %field-type-methodsTable :initform "methodsTable")
((%field-type-name :accessor %field-type-name :initform "name")
((%field-type-name :accessor %field-type-name :initform "name")
((%field-type-object :accessor %field-type-object :initform "object")
((%field-type-returnType :accessor %field-type-returnType :initform "returnType")
((%field-type-returnType :accessor %field-type-returnType :initform "returnType")
((%field-type-typeName :accessor %field-type-typeName :initform "typeName")
((%field-type-whenDeclarations :accessor %field-type-whenDeclarations :initform "whenDeclarations")
((%water-mark :accessor %water-mark :initform nil)
(actualParameterList :accessor actualParameterList)
(classes :accessor classes)
(defclass %bag-stack (stack-dsl::%typed-stack) ())
(defclass %map-stack (stack-dsl::%typed-stack) ())
(defclass actualParameterList (stack-dsl::%map) () (:default-initargs :%type "actualParameterList"))
(defclass actualParameterList-stack(stack-dsl::%typed-stack) ())
(defclass callExternalStatement (stack-dsl::%typed-value)
(defclass callExternalStatement-stack (stack-dsl::%typed-stack) ())
(defclass callInternalStatement (stack-dsl::%typed-value)
(defclass callInternalStatement-stack (stack-dsl::%typed-stack) ())
(defclass classes (stack-dsl::%map) () (:default-initargs :%type "classes"))
(defclass classes-stack(stack-dsl::%typed-stack) ())
(defclass createStatement (stack-dsl::%typed-value)
(defclass createStatement-stack (stack-dsl::%typed-stack) ())
(defclass declarationMethodOrScript (stack-dsl::%compound-type) () (:default-initargs :%type "declarationMethodOrScript"))
(defclass declarationMethodOrScript-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "declarationMethodOrScript"))
(defclass ekind (stack-dsl::%enum) () (:default-initargs :%type "ekind"))
(defclass ekind-stack (stack-dsl::%typed-stack) ())
(defclass elsePart (stack-dsl::%compound-type) () (:default-initargs :%type "elsePart"))
(defclass elsePart-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "elsePart"))
(defclass environment ()
(defclass esaKind (stack-dsl::%compound-type) () (:default-initargs :%type "esaKind"))
(defclass esaKind-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "esaKind"))
(defclass esaclass (stack-dsl::%typed-value)
(defclass esaclass-stack (stack-dsl::%typed-stack) ())
(defclass esaprogram (stack-dsl::%typed-value)
(defclass esaprogram-stack (stack-dsl::%typed-stack) ())
(defclass exitMapStatement (stack-dsl::%typed-value)
(defclass exitMapStatement-stack (stack-dsl::%typed-stack) ())
(defclass exitWhenStatement (stack-dsl::%typed-value)
(defclass exitWhenStatement-stack (stack-dsl::%typed-stack) ())
(defclass expression (stack-dsl::%typed-value)
(defclass expression-stack (stack-dsl::%typed-stack) ())
(defclass externalMethod (stack-dsl::%typed-value)
(defclass externalMethod-stack (stack-dsl::%typed-stack) ())
(defclass field (stack-dsl::%typed-value)
(defclass field-stack (stack-dsl::%typed-stack) ())
(defclass fieldMap (stack-dsl::%map) () (:default-initargs :%type "fieldMap"))
(defclass fieldMap-stack(stack-dsl::%typed-stack) ())
(defclass filler (stack-dsl::%compound-type) () (:default-initargs :%type "filler"))
(defclass filler-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "filler"))
(defclass fkind (stack-dsl::%enum) () (:default-initargs :%type "fkind"))
(defclass fkind-stack (stack-dsl::%typed-stack) ())
(defclass formalList (stack-dsl::%map) () (:default-initargs :%type "formalList"))
(defclass formalList-stack(stack-dsl::%typed-stack) ())
(defclass functionReference (stack-dsl::%compound-type) () (:default-initargs :%type "functionReference"))
(defclass functionReference-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "functionReference"))
(defclass ifStatement (stack-dsl::%typed-value)
(defclass ifStatement-stack (stack-dsl::%typed-stack) ())
(defclass implementation (stack-dsl::%map) () (:default-initargs :%type "implementation"))
(defclass implementation-stack(stack-dsl::%typed-stack) ())
(defclass indirectionKind (stack-dsl::%enum) () (:default-initargs :%type "indirectionKind"))
(defclass indirectionKind-stack (stack-dsl::%typed-stack) ())
(defclass internalMethod (stack-dsl::%typed-value)
(defclass internalMethod-stack (stack-dsl::%typed-stack) ())
(defclass letStatement (stack-dsl::%typed-value)
(defclass letStatement-stack (stack-dsl::%typed-stack) ())
(defclass loopStatement (stack-dsl::%typed-value)
(defclass loopStatement-stack (stack-dsl::%typed-stack) ())
(defclass lval (stack-dsl::%compound-type) () (:default-initargs :%type "lval"))
(defclass lval-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "lval"))
(defclass mapStatement (stack-dsl::%typed-value)
(defclass mapStatement-stack (stack-dsl::%typed-stack) ())
(defclass methodDeclaration (stack-dsl::%typed-value)
(defclass methodDeclaration-stack (stack-dsl::%typed-stack) ())
(defclass methodDeclarationsAndScriptDeclarations (stack-dsl::%map) () (:default-initargs :%type "methodDeclarationsAndScriptDeclarations"))
(defclass methodDeclarationsAndScriptDeclarations-stack(stack-dsl::%typed-stack) ())
(defclass methodName (stack-dsl::%compound-type) () (:default-initargs :%type "methodName"))
(defclass methodName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "methodName"))
(defclass methodsTable (stack-dsl::%map) () (:default-initargs :%type "methodsTable"))
(defclass methodsTable-stack(stack-dsl::%typed-stack) ())
(defclass name (stack-dsl::%string) () (:default-initargs :%type "name"))
(defclass name-stack (stack-dsl::%typed-stack) ())
(defclass object (stack-dsl::%typed-value)
(defclass object-stack (stack-dsl::%typed-stack) ())
(defclass returnFalseStatement (stack-dsl::%typed-value)
(defclass returnFalseStatement-stack (stack-dsl::%typed-stack) ())
(defclass returnKind (stack-dsl::%enum) () (:default-initargs :%type "returnKind"))
(defclass returnKind-stack (stack-dsl::%typed-stack) ())
(defclass returnTrueStatement (stack-dsl::%typed-value)
(defclass returnTrueStatement-stack (stack-dsl::%typed-stack) ())
(defclass returnType (stack-dsl::%typed-value)
(defclass returnType-stack (stack-dsl::%typed-stack) ())
(defclass returnValueStatement (stack-dsl::%typed-value)
(defclass returnValueStatement-stack (stack-dsl::%typed-stack) ())
(defclass scriptDeclaration (stack-dsl::%typed-value)
(defclass scriptDeclaration-stack (stack-dsl::%typed-stack) ())
(defclass setStatement (stack-dsl::%typed-value)
(defclass setStatement-stack (stack-dsl::%typed-stack) ())
(defclass situationDefinition (stack-dsl::%compound-type) () (:default-initargs :%type "situationDefinition"))
(defclass situationDefinition-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "situationDefinition"))
(defclass situationReferenceList (stack-dsl::%map) () (:default-initargs :%type "situationReferenceList"))
(defclass situationReferenceList-stack(stack-dsl::%typed-stack) ())
(defclass situationReferenceName (stack-dsl::%compound-type) () (:default-initargs :%type "situationReferenceName"))
(defclass situationReferenceName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "situationReferenceName"))
(defclass situations (stack-dsl::%map) () (:default-initargs :%type "situations"))
(defclass situations-stack(stack-dsl::%typed-stack) ())
(defclass statement (stack-dsl::%compound-type) () (:default-initargs :%type "statement"))
(defclass statement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "statement"))
(defclass thenPart (stack-dsl::%compound-type) () (:default-initargs :%type "thenPart"))
(defclass thenPart-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "thenPart"))
(defclass typeDecl (stack-dsl::%typed-value)
(defclass typeDecl-stack (stack-dsl::%typed-stack) ())
(defclass typeDecls (stack-dsl::%map) () (:default-initargs :%type "typeDecls"))
(defclass typeDecls-stack(stack-dsl::%typed-stack) ())
(defclass typeName (stack-dsl::%compound-type) () (:default-initargs :%type "typeName"))
(defclass typeName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "typeName"))
(defclass varName (stack-dsl::%compound-type) () (:default-initargs :%type "varName"))
(defclass varName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "varName"))
(defclass whenDeclaration (stack-dsl::%typed-value)
(defclass whenDeclaration-stack (stack-dsl::%typed-stack) ())
(defclass whenDeclarations (stack-dsl::%map) () (:default-initargs :%type "whenDeclarations"))
(defclass whenDeclarations-stack(stack-dsl::%typed-stack) ())
(defmethod %memoCheck ((self environment))
(defmethod %memoStacks ((self environment))
(defmethod initialize-instance :after ((self %map-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self actualParameterList) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self callExternalStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self callInternalStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self classes) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self createStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self declarationMethodOrScript) &key &allow-other-keys)
(defmethod initialize-instance :after ((self ekind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self ekind-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self elsePart) &key &allow-other-keys)
(defmethod initialize-instance :after ((self esaKind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self esaclass-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self esaprogram-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self exitMapStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self exitWhenStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self expression-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self externalMethod-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self field-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self fieldMap) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self filler) &key &allow-other-keys)
(defmethod initialize-instance :after ((self fkind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self fkind-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self formalList) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self functionReference) &key &allow-other-keys)
(defmethod initialize-instance :after ((self ifStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self implementation) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self indirectionKind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self indirectionKind-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self internalMethod-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self letStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self loopStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self lval) &key &allow-other-keys)
(defmethod initialize-instance :after ((self mapStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self methodDeclaration-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self methodDeclarationsAndScriptDeclarations) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self methodName) &key &allow-other-keys)
(defmethod initialize-instance :after ((self methodsTable) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self name-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self object-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnFalseStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnKind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnKind-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnTrueStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnType-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnValueStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self scriptDeclaration-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self setStatement-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self situationDefinition) &key &allow-other-keys)
(defmethod initialize-instance :after ((self situationReferenceList) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self situationReferenceName) &key &allow-other-keys)
(defmethod initialize-instance :after ((self situations) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self statement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self thenPart) &key &allow-other-keys)
(defmethod initialize-instance :after ((self typeDecl-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self typeDecls) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self typeName) &key &allow-other-keys)
(defmethod initialize-instance :after ((self varName) &key &allow-other-keys)
(defmethod initialize-instance :after ((self whenDeclaration-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self whenDeclarations) &key &allow-other-keys)  ;; type for items in map
(defparameter *stacks* '(
(ekind :accessor ekind)
(elsePart :accessor elsePart)
(esaKind :accessor esaKind)
(esaKind :accessor esaKind)
(esaKind :accessor esaKind)
(expression :accessor expression)
(expression :accessor expression)
(expression :accessor expression)
(expression :accessor expression)
(expression :accessor expression)
(fieldMap :accessor fieldMap)
(fieldMap :accessor fieldMap)
(filler :accessor filler)
(fkind :accessor fkind)
(formalList :accessor formalList)
(formalList :accessor formalList)
(formalList :accessor formalList)
(formalList :accessor formalList)
(functionReference :accessor functionReference)
(functionReference :accessor functionReference)
(implementation :accessor implementation)
(implementation :accessor implementation)
(implementation :accessor implementation)
(implementation :accessor implementation)
(implementation :accessor implementation)
(implementation :accessor implementation)
(indirectionKind :accessor indirectionKind)
(input-actualParameterList :accessor input-actualParameterList :initform (make-instance 'actualParameterList-stack))
(input-callExternalStatement :accessor input-callExternalStatement :initform (make-instance 'callExternalStatement-stack))
(input-callInternalStatement :accessor input-callInternalStatement :initform (make-instance 'callInternalStatement-stack))
(input-classes :accessor input-classes :initform (make-instance 'classes-stack))
(input-createStatement :accessor input-createStatement :initform (make-instance 'createStatement-stack))
(input-declarationMethodOrScript :accessor input-declarationMethodOrScript :initform (make-instance 'declarationMethodOrScript-stack))
(input-ekind :accessor input-ekind :initform (make-instance 'ekind-stack))
(input-elsePart :accessor input-elsePart :initform (make-instance 'elsePart-stack))
(input-esaKind :accessor input-esaKind :initform (make-instance 'esaKind-stack))
(input-esaclass :accessor input-esaclass :initform (make-instance 'esaclass-stack))
(input-esaprogram :accessor input-esaprogram :initform (make-instance 'esaprogram-stack))
(input-exitMapStatement :accessor input-exitMapStatement :initform (make-instance 'exitMapStatement-stack))
(input-exitWhenStatement :accessor input-exitWhenStatement :initform (make-instance 'exitWhenStatement-stack))
(input-expression :accessor input-expression :initform (make-instance 'expression-stack))
(input-externalMethod :accessor input-externalMethod :initform (make-instance 'externalMethod-stack))
(input-field :accessor input-field :initform (make-instance 'field-stack))
(input-fieldMap :accessor input-fieldMap :initform (make-instance 'fieldMap-stack))
(input-filler :accessor input-filler :initform (make-instance 'filler-stack))
(input-fkind :accessor input-fkind :initform (make-instance 'fkind-stack))
(input-formalList :accessor input-formalList :initform (make-instance 'formalList-stack))
(input-functionReference :accessor input-functionReference :initform (make-instance 'functionReference-stack))
(input-ifStatement :accessor input-ifStatement :initform (make-instance 'ifStatement-stack))
(input-implementation :accessor input-implementation :initform (make-instance 'implementation-stack))
(input-indirectionKind :accessor input-indirectionKind :initform (make-instance 'indirectionKind-stack))
(input-internalMethod :accessor input-internalMethod :initform (make-instance 'internalMethod-stack))
(input-letStatement :accessor input-letStatement :initform (make-instance 'letStatement-stack))
(input-loopStatement :accessor input-loopStatement :initform (make-instance 'loopStatement-stack))
(input-lval :accessor input-lval :initform (make-instance 'lval-stack))
(input-mapStatement :accessor input-mapStatement :initform (make-instance 'mapStatement-stack))
(input-methodDeclaration :accessor input-methodDeclaration :initform (make-instance 'methodDeclaration-stack))
(input-methodDeclarationsAndScriptDeclarations :accessor input-methodDeclarationsAndScriptDeclarations :initform (make-instance 'methodDeclarationsAndScriptDeclarations-stack))
(input-methodName :accessor input-methodName :initform (make-instance 'methodName-stack))
(input-methodsTable :accessor input-methodsTable :initform (make-instance 'methodsTable-stack))
(input-name :accessor input-name :initform (make-instance 'name-stack))
(input-object :accessor input-object :initform (make-instance 'object-stack))
(input-returnFalseStatement :accessor input-returnFalseStatement :initform (make-instance 'returnFalseStatement-stack))
(input-returnKind :accessor input-returnKind :initform (make-instance 'returnKind-stack))
(input-returnTrueStatement :accessor input-returnTrueStatement :initform (make-instance 'returnTrueStatement-stack))
(input-returnType :accessor input-returnType :initform (make-instance 'returnType-stack))
(input-returnValueStatement :accessor input-returnValueStatement :initform (make-instance 'returnValueStatement-stack))
(input-scriptDeclaration :accessor input-scriptDeclaration :initform (make-instance 'scriptDeclaration-stack))
(input-setStatement :accessor input-setStatement :initform (make-instance 'setStatement-stack))
(input-situationDefinition :accessor input-situationDefinition :initform (make-instance 'situationDefinition-stack))
(input-situationReferenceList :accessor input-situationReferenceList :initform (make-instance 'situationReferenceList-stack))
(input-situationReferenceName :accessor input-situationReferenceName :initform (make-instance 'situationReferenceName-stack))
(input-situations :accessor input-situations :initform (make-instance 'situations-stack))
(input-statement :accessor input-statement :initform (make-instance 'statement-stack))
(input-thenPart :accessor input-thenPart :initform (make-instance 'thenPart-stack))
(input-typeDecl :accessor input-typeDecl :initform (make-instance 'typeDecl-stack))
(input-typeDecls :accessor input-typeDecls :initform (make-instance 'typeDecls-stack))
(input-typeName :accessor input-typeName :initform (make-instance 'typeName-stack))
(input-varName :accessor input-varName :initform (make-instance 'varName-stack))
(input-whenDeclaration :accessor input-whenDeclaration :initform (make-instance 'whenDeclaration-stack))
(input-whenDeclarations :accessor input-whenDeclarations :initform (make-instance 'whenDeclarations-stack))
(let ((in-eq (eq (nth 0 wm) (stack-dsl::%stack (input-esaprogram self))))
(let ((in-eq (eq (nth 10 wm) (stack-dsl::%stack (input-typeDecl self))))
(let ((in-eq (eq (nth 100 wm) (stack-dsl::%stack (input-thenPart self))))
(let ((in-eq (eq (nth 102 wm) (stack-dsl::%stack (input-elsePart self))))
(let ((in-eq (eq (nth 104 wm) (stack-dsl::%stack (input-methodName self))))
(let ((in-eq (eq (nth 106 wm) (stack-dsl::%stack (input-functionReference self))))
(let ((in-eq (eq (nth 12 wm) (stack-dsl::%stack (input-name self))))
(let ((in-eq (eq (nth 14 wm) (stack-dsl::%stack (input-typeName self))))
(let ((in-eq (eq (nth 16 wm) (stack-dsl::%stack (input-situationDefinition self))))
(let ((in-eq (eq (nth 18 wm) (stack-dsl::%stack (input-esaclass self))))
(let ((in-eq (eq (nth 2 wm) (stack-dsl::%stack (input-typeDecls self))))
(let ((in-eq (eq (nth 20 wm) (stack-dsl::%stack (input-fieldMap self))))
(let ((in-eq (eq (nth 22 wm) (stack-dsl::%stack (input-methodsTable self))))
(let ((in-eq (eq (nth 24 wm) (stack-dsl::%stack (input-whenDeclaration self))))
(let ((in-eq (eq (nth 26 wm) (stack-dsl::%stack (input-situationReferenceList self))))
(let ((in-eq (eq (nth 28 wm) (stack-dsl::%stack (input-esaKind self))))
(let ((in-eq (eq (nth 30 wm) (stack-dsl::%stack (input-methodDeclarationsAndScriptDeclarations self))))
(let ((in-eq (eq (nth 32 wm) (stack-dsl::%stack (input-situationReferenceName self))))
(let ((in-eq (eq (nth 34 wm) (stack-dsl::%stack (input-declarationMethodOrScript self))))
(let ((in-eq (eq (nth 36 wm) (stack-dsl::%stack (input-methodDeclaration self))))
(let ((in-eq (eq (nth 38 wm) (stack-dsl::%stack (input-scriptDeclaration self))))
(let ((in-eq (eq (nth 4 wm) (stack-dsl::%stack (input-situations self))))
(let ((in-eq (eq (nth 40 wm) (stack-dsl::%stack (input-formalList self))))
(let ((in-eq (eq (nth 42 wm) (stack-dsl::%stack (input-returnType self))))
(let ((in-eq (eq (nth 44 wm) (stack-dsl::%stack (input-implementation self))))
(let ((in-eq (eq (nth 46 wm) (stack-dsl::%stack (input-returnKind self))))
(let ((in-eq (eq (nth 48 wm) (stack-dsl::%stack (input-expression self))))
(let ((in-eq (eq (nth 50 wm) (stack-dsl::%stack (input-ekind self))))
(let ((in-eq (eq (nth 52 wm) (stack-dsl::%stack (input-object self))))
(let ((in-eq (eq (nth 54 wm) (stack-dsl::%stack (input-field self))))
(let ((in-eq (eq (nth 56 wm) (stack-dsl::%stack (input-fkind self))))
(let ((in-eq (eq (nth 58 wm) (stack-dsl::%stack (input-actualParameterList self))))
(let ((in-eq (eq (nth 6 wm) (stack-dsl::%stack (input-classes self))))
(let ((in-eq (eq (nth 60 wm) (stack-dsl::%stack (input-externalMethod self))))
(let ((in-eq (eq (nth 62 wm) (stack-dsl::%stack (input-internalMethod self))))
(let ((in-eq (eq (nth 64 wm) (stack-dsl::%stack (input-statement self))))
(let ((in-eq (eq (nth 66 wm) (stack-dsl::%stack (input-letStatement self))))
(let ((in-eq (eq (nth 68 wm) (stack-dsl::%stack (input-mapStatement self))))
(let ((in-eq (eq (nth 70 wm) (stack-dsl::%stack (input-exitMapStatement self))))
(let ((in-eq (eq (nth 72 wm) (stack-dsl::%stack (input-setStatement self))))
(let ((in-eq (eq (nth 74 wm) (stack-dsl::%stack (input-createStatement self))))
(let ((in-eq (eq (nth 76 wm) (stack-dsl::%stack (input-ifStatement self))))
(let ((in-eq (eq (nth 78 wm) (stack-dsl::%stack (input-loopStatement self))))
(let ((in-eq (eq (nth 8 wm) (stack-dsl::%stack (input-whenDeclarations self))))
(let ((in-eq (eq (nth 80 wm) (stack-dsl::%stack (input-exitWhenStatement self))))
(let ((in-eq (eq (nth 82 wm) (stack-dsl::%stack (input-callInternalStatement self))))
(let ((in-eq (eq (nth 84 wm) (stack-dsl::%stack (input-callExternalStatement self))))
(let ((in-eq (eq (nth 86 wm) (stack-dsl::%stack (input-returnTrueStatement self))))
(let ((in-eq (eq (nth 88 wm) (stack-dsl::%stack (input-returnFalseStatement self))))
(let ((in-eq (eq (nth 90 wm) (stack-dsl::%stack (input-returnValueStatement self))))
(let ((in-eq (eq (nth 92 wm) (stack-dsl::%stack (input-varName self))))
(let ((in-eq (eq (nth 94 wm) (stack-dsl::%stack (input-filler self))))
(let ((in-eq (eq (nth 96 wm) (stack-dsl::%stack (input-lval self))))
(let ((in-eq (eq (nth 98 wm) (stack-dsl::%stack (input-indirectionKind self))))
(let ((r (and
(let ((wm (%water-mark self)))
(list
(lval :accessor lval)
(methodDeclarationsAndScriptDeclarations :accessor methodDeclarationsAndScriptDeclarations)
(methodName :accessor methodName)
(methodName :accessor methodName)
(methodName :accessor methodName)
(methodsTable :accessor methodsTable)
(name :accessor name)
(name :accessor name)
(name :accessor name)
(name :accessor name)
(name :accessor name)
(name :accessor name)
(name :accessor name)
(name :accessor name)
(name :accessor name)
(name :accessor name)
(name :accessor name)
(object :accessor object)
(output-actualParameterList :accessor output-actualParameterList :initform (make-instance 'actualParameterList-stack))
(output-callExternalStatement :accessor output-callExternalStatement :initform (make-instance 'callExternalStatement-stack))
(output-callInternalStatement :accessor output-callInternalStatement :initform (make-instance 'callInternalStatement-stack))
(output-classes :accessor output-classes :initform (make-instance 'classes-stack))
(output-createStatement :accessor output-createStatement :initform (make-instance 'createStatement-stack))
(output-declarationMethodOrScript :accessor output-declarationMethodOrScript :initform (make-instance 'declarationMethodOrScript-stack))
(output-ekind :accessor output-ekind :initform (make-instance 'ekind-stack))
(output-elsePart :accessor output-elsePart :initform (make-instance 'elsePart-stack))
(output-esaKind :accessor output-esaKind :initform (make-instance 'esaKind-stack))
(output-esaclass :accessor output-esaclass :initform (make-instance 'esaclass-stack))
(output-esaprogram :accessor output-esaprogram :initform (make-instance 'esaprogram-stack))
(output-exitMapStatement :accessor output-exitMapStatement :initform (make-instance 'exitMapStatement-stack))
(output-exitWhenStatement :accessor output-exitWhenStatement :initform (make-instance 'exitWhenStatement-stack))
(output-expression :accessor output-expression :initform (make-instance 'expression-stack))
(output-externalMethod :accessor output-externalMethod :initform (make-instance 'externalMethod-stack))
(output-field :accessor output-field :initform (make-instance 'field-stack))
(output-fieldMap :accessor output-fieldMap :initform (make-instance 'fieldMap-stack))
(output-filler :accessor output-filler :initform (make-instance 'filler-stack))
(output-fkind :accessor output-fkind :initform (make-instance 'fkind-stack))
(output-formalList :accessor output-formalList :initform (make-instance 'formalList-stack))
(output-functionReference :accessor output-functionReference :initform (make-instance 'functionReference-stack))
(output-ifStatement :accessor output-ifStatement :initform (make-instance 'ifStatement-stack))
(output-implementation :accessor output-implementation :initform (make-instance 'implementation-stack))
(output-indirectionKind :accessor output-indirectionKind :initform (make-instance 'indirectionKind-stack))
(output-internalMethod :accessor output-internalMethod :initform (make-instance 'internalMethod-stack))
(output-letStatement :accessor output-letStatement :initform (make-instance 'letStatement-stack))
(output-loopStatement :accessor output-loopStatement :initform (make-instance 'loopStatement-stack))
(output-lval :accessor output-lval :initform (make-instance 'lval-stack))
(output-mapStatement :accessor output-mapStatement :initform (make-instance 'mapStatement-stack))
(output-methodDeclaration :accessor output-methodDeclaration :initform (make-instance 'methodDeclaration-stack))
(output-methodDeclarationsAndScriptDeclarations :accessor output-methodDeclarationsAndScriptDeclarations :initform (make-instance 'methodDeclarationsAndScriptDeclarations-stack))
(output-methodName :accessor output-methodName :initform (make-instance 'methodName-stack))
(output-methodsTable :accessor output-methodsTable :initform (make-instance 'methodsTable-stack))
(output-name :accessor output-name :initform (make-instance 'name-stack))
(output-object :accessor output-object :initform (make-instance 'object-stack))
(output-returnFalseStatement :accessor output-returnFalseStatement :initform (make-instance 'returnFalseStatement-stack))
(output-returnKind :accessor output-returnKind :initform (make-instance 'returnKind-stack))
(output-returnTrueStatement :accessor output-returnTrueStatement :initform (make-instance 'returnTrueStatement-stack))
(output-returnType :accessor output-returnType :initform (make-instance 'returnType-stack))
(output-returnValueStatement :accessor output-returnValueStatement :initform (make-instance 'returnValueStatement-stack))
(output-scriptDeclaration :accessor output-scriptDeclaration :initform (make-instance 'scriptDeclaration-stack))
(output-setStatement :accessor output-setStatement :initform (make-instance 'setStatement-stack))
(output-situationDefinition :accessor output-situationDefinition :initform (make-instance 'situationDefinition-stack))
(output-situationReferenceList :accessor output-situationReferenceList :initform (make-instance 'situationReferenceList-stack))
(output-situationReferenceName :accessor output-situationReferenceName :initform (make-instance 'situationReferenceName-stack))
(output-situations :accessor output-situations :initform (make-instance 'situations-stack))
(output-statement :accessor output-statement :initform (make-instance 'statement-stack))
(output-thenPart :accessor output-thenPart :initform (make-instance 'thenPart-stack))
(output-typeDecl :accessor output-typeDecl :initform (make-instance 'typeDecl-stack))
(output-typeDecls :accessor output-typeDecls :initform (make-instance 'typeDecls-stack))
(output-typeName :accessor output-typeName :initform (make-instance 'typeName-stack))
(output-varName :accessor output-varName :initform (make-instance 'varName-stack))
(output-whenDeclaration :accessor output-whenDeclaration :initform (make-instance 'whenDeclaration-stack))
(output-whenDeclarations :accessor output-whenDeclarations :initform (make-instance 'whenDeclarations-stack))
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))(in-package "CL-USER")
(returnKind :accessor returnKind)
(returnType :accessor returnType)
(returnType :accessor returnType)
(returnType :accessor returnType)
(returnType :accessor returnType)
(setf (%water-mark self)
(setf (stack-dsl::%element-type self) "actualParameterList"))
(setf (stack-dsl::%element-type self) "classes"))
(setf (stack-dsl::%element-type self) "declarationMethodOrScript"))
(setf (stack-dsl::%element-type self) "declarationMethodOrScript"))
(setf (stack-dsl::%element-type self) "esaclass"))
(setf (stack-dsl::%element-type self) "expression"))
(setf (stack-dsl::%element-type self) "field"))
(setf (stack-dsl::%element-type self) "fieldMap"))
(setf (stack-dsl::%element-type self) "formalList"))
(setf (stack-dsl::%element-type self) "implementation"))
(setf (stack-dsl::%element-type self) "methodDeclarationsAndScriptDeclarations"))
(setf (stack-dsl::%element-type self) "methodsTable"))
(setf (stack-dsl::%element-type self) "name"))
(setf (stack-dsl::%element-type self) "situationDefinition"))
(setf (stack-dsl::%element-type self) "situationReferenceList"))
(setf (stack-dsl::%element-type self) "situationReferenceName"))
(setf (stack-dsl::%element-type self) "situations"))
(setf (stack-dsl::%element-type self) "statement"))
(setf (stack-dsl::%element-type self) "typeDecl"))
(setf (stack-dsl::%element-type self) "typeDecls"))
(setf (stack-dsl::%element-type self) "whenDeclaration"))
(setf (stack-dsl::%element-type self) "whenDeclarations"))
(situationReferenceList :accessor situationReferenceList)
(situations :accessor situations)
(stack-dsl::%ensure-existence 'actualParameterList)
(stack-dsl::%ensure-existence 'callExternalStatement)
(stack-dsl::%ensure-existence 'callInternalStatement)
(stack-dsl::%ensure-existence 'classes)
(stack-dsl::%ensure-existence 'createStatement)
(stack-dsl::%ensure-existence 'declarationMethodOrScript)
(stack-dsl::%ensure-existence 'ekind)
(stack-dsl::%ensure-existence 'elsePart)
(stack-dsl::%ensure-existence 'esaKind)
(stack-dsl::%ensure-existence 'esaclass)
(stack-dsl::%ensure-existence 'esaprogram)
(stack-dsl::%ensure-existence 'exitMapStatement)
(stack-dsl::%ensure-existence 'exitWhenStatement)
(stack-dsl::%ensure-existence 'expression)
(stack-dsl::%ensure-existence 'externalMethod)
(stack-dsl::%ensure-existence 'field)
(stack-dsl::%ensure-existence 'fieldMap)
(stack-dsl::%ensure-existence 'filler)
(stack-dsl::%ensure-existence 'fkind)
(stack-dsl::%ensure-existence 'formalList)
(stack-dsl::%ensure-existence 'functionReference)
(stack-dsl::%ensure-existence 'ifStatement)
(stack-dsl::%ensure-existence 'implementation)
(stack-dsl::%ensure-existence 'indirectionKind)
(stack-dsl::%ensure-existence 'internalMethod)
(stack-dsl::%ensure-existence 'letStatement)
(stack-dsl::%ensure-existence 'loopStatement)
(stack-dsl::%ensure-existence 'lval)
(stack-dsl::%ensure-existence 'mapStatement)
(stack-dsl::%ensure-existence 'methodDeclaration)
(stack-dsl::%ensure-existence 'methodDeclarationsAndScriptDeclarations)
(stack-dsl::%ensure-existence 'methodName)
(stack-dsl::%ensure-existence 'methodsTable)
(stack-dsl::%ensure-existence 'name)
(stack-dsl::%ensure-existence 'object)
(stack-dsl::%ensure-existence 'returnFalseStatement)
(stack-dsl::%ensure-existence 'returnKind)
(stack-dsl::%ensure-existence 'returnTrueStatement)
(stack-dsl::%ensure-existence 'returnType)
(stack-dsl::%ensure-existence 'returnValueStatement)
(stack-dsl::%ensure-existence 'scriptDeclaration)
(stack-dsl::%ensure-existence 'setStatement)
(stack-dsl::%ensure-existence 'situationDefinition)
(stack-dsl::%ensure-existence 'situationReferenceList)
(stack-dsl::%ensure-existence 'situationReferenceName)
(stack-dsl::%ensure-existence 'situations)
(stack-dsl::%ensure-existence 'statement)
(stack-dsl::%ensure-existence 'thenPart)
(stack-dsl::%ensure-existence 'typeDecl)
(stack-dsl::%ensure-existence 'typeDecls)
(stack-dsl::%ensure-existence 'typeName)
(stack-dsl::%ensure-existence 'varName)
(stack-dsl::%ensure-existence 'whenDeclaration)
(stack-dsl::%ensure-existence 'whenDeclarations)
(stack-dsl::%stack (input-actualParameterList self))
(stack-dsl::%stack (input-callExternalStatement self))
(stack-dsl::%stack (input-callInternalStatement self))
(stack-dsl::%stack (input-classes self))
(stack-dsl::%stack (input-createStatement self))
(stack-dsl::%stack (input-declarationMethodOrScript self))
(stack-dsl::%stack (input-ekind self))
(stack-dsl::%stack (input-elsePart self))
(stack-dsl::%stack (input-esaKind self))
(stack-dsl::%stack (input-esaclass self))
(stack-dsl::%stack (input-esaprogram self))
(stack-dsl::%stack (input-exitMapStatement self))
(stack-dsl::%stack (input-exitWhenStatement self))
(stack-dsl::%stack (input-expression self))
(stack-dsl::%stack (input-externalMethod self))
(stack-dsl::%stack (input-field self))
(stack-dsl::%stack (input-fieldMap self))
(stack-dsl::%stack (input-filler self))
(stack-dsl::%stack (input-fkind self))
(stack-dsl::%stack (input-formalList self))
(stack-dsl::%stack (input-functionReference self))
(stack-dsl::%stack (input-ifStatement self))
(stack-dsl::%stack (input-implementation self))
(stack-dsl::%stack (input-indirectionKind self))
(stack-dsl::%stack (input-internalMethod self))
(stack-dsl::%stack (input-letStatement self))
(stack-dsl::%stack (input-loopStatement self))
(stack-dsl::%stack (input-lval self))
(stack-dsl::%stack (input-mapStatement self))
(stack-dsl::%stack (input-methodDeclaration self))
(stack-dsl::%stack (input-methodDeclarationsAndScriptDeclarations self))
(stack-dsl::%stack (input-methodName self))
(stack-dsl::%stack (input-methodsTable self))
(stack-dsl::%stack (input-name self))
(stack-dsl::%stack (input-object self))
(stack-dsl::%stack (input-returnFalseStatement self))
(stack-dsl::%stack (input-returnKind self))
(stack-dsl::%stack (input-returnTrueStatement self))
(stack-dsl::%stack (input-returnType self))
(stack-dsl::%stack (input-returnValueStatement self))
(stack-dsl::%stack (input-scriptDeclaration self))
(stack-dsl::%stack (input-setStatement self))
(stack-dsl::%stack (input-situationDefinition self))
(stack-dsl::%stack (input-situationReferenceList self))
(stack-dsl::%stack (input-situationReferenceName self))
(stack-dsl::%stack (input-situations self))
(stack-dsl::%stack (input-statement self))
(stack-dsl::%stack (input-thenPart self))
(stack-dsl::%stack (input-typeDecl self))
(stack-dsl::%stack (input-typeDecls self))
(stack-dsl::%stack (input-typeName self))
(stack-dsl::%stack (input-varName self))
(stack-dsl::%stack (input-whenDeclaration self))
(stack-dsl::%stack (input-whenDeclarations self))
(stack-dsl::%stack (output-actualParameterList self))
(stack-dsl::%stack (output-callExternalStatement self))
(stack-dsl::%stack (output-callInternalStatement self))
(stack-dsl::%stack (output-classes self))
(stack-dsl::%stack (output-createStatement self))
(stack-dsl::%stack (output-declarationMethodOrScript self))
(stack-dsl::%stack (output-ekind self))
(stack-dsl::%stack (output-elsePart self))
(stack-dsl::%stack (output-esaKind self))
(stack-dsl::%stack (output-esaclass self))
(stack-dsl::%stack (output-esaprogram self))
(stack-dsl::%stack (output-exitMapStatement self))
(stack-dsl::%stack (output-exitWhenStatement self))
(stack-dsl::%stack (output-expression self))
(stack-dsl::%stack (output-externalMethod self))
(stack-dsl::%stack (output-field self))
(stack-dsl::%stack (output-fieldMap self))
(stack-dsl::%stack (output-filler self))
(stack-dsl::%stack (output-fkind self))
(stack-dsl::%stack (output-formalList self))
(stack-dsl::%stack (output-functionReference self))
(stack-dsl::%stack (output-ifStatement self))
(stack-dsl::%stack (output-implementation self))
(stack-dsl::%stack (output-indirectionKind self))
(stack-dsl::%stack (output-internalMethod self))
(stack-dsl::%stack (output-letStatement self))
(stack-dsl::%stack (output-loopStatement self))
(stack-dsl::%stack (output-lval self))
(stack-dsl::%stack (output-mapStatement self))
(stack-dsl::%stack (output-methodDeclaration self))
(stack-dsl::%stack (output-methodDeclarationsAndScriptDeclarations self))
(stack-dsl::%stack (output-methodName self))
(stack-dsl::%stack (output-methodsTable self))
(stack-dsl::%stack (output-name self))
(stack-dsl::%stack (output-object self))
(stack-dsl::%stack (output-returnFalseStatement self))
(stack-dsl::%stack (output-returnKind self))
(stack-dsl::%stack (output-returnTrueStatement self))
(stack-dsl::%stack (output-returnType self))
(stack-dsl::%stack (output-returnValueStatement self))
(stack-dsl::%stack (output-scriptDeclaration self))
(stack-dsl::%stack (output-setStatement self))
(stack-dsl::%stack (output-situationDefinition self))
(stack-dsl::%stack (output-situationReferenceList self))
(stack-dsl::%stack (output-situationReferenceName self))
(stack-dsl::%stack (output-situations self))
(stack-dsl::%stack (output-statement self))
(stack-dsl::%stack (output-thenPart self))
(stack-dsl::%stack (output-typeDecl self))
(stack-dsl::%stack (output-typeDecls self))
(stack-dsl::%stack (output-typeName self))
(stack-dsl::%stack (output-varName self))
(stack-dsl::%stack (output-whenDeclaration self))
(stack-dsl::%stack (output-whenDeclarations self))
(thenPart :accessor thenPart)
(typeDecls :accessor typeDecls)
(typeName :accessor typeName)
(unless r (error "stack depth incorrect")))))
(varName :accessor varName)
(varName :accessor varName)
(varName :accessor varName)
(whenDeclarations :accessor whenDeclarations)
) (:default-initargs :%type "callExternalStatement"))
) (:default-initargs :%type "callInternalStatement"))
) (:default-initargs :%type "createStatement"))
) (:default-initargs :%type "esaclass"))
) (:default-initargs :%type "esaprogram"))
) (:default-initargs :%type "exitMapStatement"))
) (:default-initargs :%type "exitWhenStatement"))
) (:default-initargs :%type "expression"))
) (:default-initargs :%type "externalMethod"))
) (:default-initargs :%type "field"))
) (:default-initargs :%type "ifStatement"))
) (:default-initargs :%type "internalMethod"))
) (:default-initargs :%type "letStatement"))
) (:default-initargs :%type "loopStatement"))
) (:default-initargs :%type "mapStatement"))
) (:default-initargs :%type "methodDeclaration"))
) (:default-initargs :%type "object"))
) (:default-initargs :%type "returnFalseStatement"))
) (:default-initargs :%type "returnTrueStatement"))
) (:default-initargs :%type "returnType"))
) (:default-initargs :%type "returnValueStatement"))
) (:default-initargs :%type "scriptDeclaration"))
) (:default-initargs :%type "setStatement"))
) (:default-initargs :%type "typeDecl"))
) (:default-initargs :%type "whenDeclaration"))
))
))
)))
)))
;; check forward types
input-actualParameterList
input-callExternalStatement
input-callInternalStatement
input-classes
input-createStatement
input-declarationMethodOrScript
input-ekind
input-elsePart
input-esaKind
input-esaclass
input-esaprogram
input-exitMapStatement
input-exitWhenStatement
input-expression
input-externalMethod
input-field
input-fieldMap
input-filler
input-fkind
input-formalList
input-functionReference
input-ifStatement
input-implementation
input-indirectionKind
input-internalMethod
input-letStatement
input-loopStatement
input-lval
input-mapStatement
input-methodDeclaration
input-methodDeclarationsAndScriptDeclarations
input-methodName
input-methodsTable
input-name
input-object
input-returnFalseStatement
input-returnKind
input-returnTrueStatement
input-returnType
input-returnValueStatement
input-scriptDeclaration
input-setStatement
input-situationDefinition
input-situationReferenceList
input-situationReferenceName
input-situations
input-statement
input-thenPart
input-typeDecl
input-typeDecls
input-typeName
input-varName
input-whenDeclaration
input-whenDeclarations
output-actualParameterList
output-callExternalStatement
output-callInternalStatement
output-classes
output-createStatement
output-declarationMethodOrScript
output-ekind
output-elsePart
output-esaKind
output-esaclass
output-esaprogram
output-exitMapStatement
output-exitWhenStatement
output-expression
output-externalMethod
output-field
output-fieldMap
output-filler
output-fkind
output-formalList
output-functionReference
output-ifStatement
output-implementation
output-indirectionKind
output-internalMethod
output-letStatement
output-loopStatement
output-lval
output-mapStatement
output-methodDeclaration
output-methodDeclarationsAndScriptDeclarations
output-methodName
output-methodsTable
output-name
output-object
output-returnFalseStatement
output-returnKind
output-returnTrueStatement
output-returnType
output-returnValueStatement
output-scriptDeclaration
output-setStatement
output-situationDefinition
output-situationReferenceList
output-situationReferenceName
output-situations
output-statement
output-thenPart
output-typeDecl
output-typeDecls
output-typeName
output-varName
output-whenDeclaration
output-whenDeclarations
