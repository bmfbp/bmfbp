

















































































































	   
      (out-eq (eq (nth 1 wm) (stack-dsl::%stack (output-typeDecls self)))))
      (out-eq (eq (nth 101 wm) (stack-dsl::%stack (output-thenPart self)))))
      (out-eq (eq (nth 103 wm) (stack-dsl::%stack (output-elsePart self)))))
      (out-eq (eq (nth 105 wm) (stack-dsl::%stack (output-methodName self)))))
      (out-eq (eq (nth 107 wm) (stack-dsl::%stack (output-functionReference self)))))
      (out-eq (eq (nth 11 wm) (stack-dsl::%stack (output-name self)))))
      (out-eq (eq (nth 13 wm) (stack-dsl::%stack (output-typeName self)))))
      (out-eq (eq (nth 15 wm) (stack-dsl::%stack (output-typeDecl self)))))
      (out-eq (eq (nth 17 wm) (stack-dsl::%stack (output-situationDefinition self)))))
      (out-eq (eq (nth 19 wm) (stack-dsl::%stack (output-fieldMap self)))))
      (out-eq (eq (nth 21 wm) (stack-dsl::%stack (output-methodsTable self)))))
      (out-eq (eq (nth 23 wm) (stack-dsl::%stack (output-esaclass self)))))
      (out-eq (eq (nth 25 wm) (stack-dsl::%stack (output-situationReferenceList self)))))
      (out-eq (eq (nth 27 wm) (stack-dsl::%stack (output-esaKind self)))))
      (out-eq (eq (nth 29 wm) (stack-dsl::%stack (output-methodDeclarationsAndScriptDeclarations self)))))
      (out-eq (eq (nth 3 wm) (stack-dsl::%stack (output-situations self)))))
      (out-eq (eq (nth 31 wm) (stack-dsl::%stack (output-whenDeclaration self)))))
      (out-eq (eq (nth 33 wm) (stack-dsl::%stack (output-situationReferenceName self)))))
      (out-eq (eq (nth 35 wm) (stack-dsl::%stack (output-methodDeclaration self)))))
      (out-eq (eq (nth 37 wm) (stack-dsl::%stack (output-scriptDeclaration self)))))
      (out-eq (eq (nth 39 wm) (stack-dsl::%stack (output-declarationMethodOrScript self)))))
      (out-eq (eq (nth 41 wm) (stack-dsl::%stack (output-formalList self)))))
      (out-eq (eq (nth 43 wm) (stack-dsl::%stack (output-returnType self)))))
      (out-eq (eq (nth 45 wm) (stack-dsl::%stack (output-implementation self)))))
      (out-eq (eq (nth 47 wm) (stack-dsl::%stack (output-returnKind self)))))
      (out-eq (eq (nth 49 wm) (stack-dsl::%stack (output-ekind self)))))
      (out-eq (eq (nth 5 wm) (stack-dsl::%stack (output-classes self)))))
      (out-eq (eq (nth 51 wm) (stack-dsl::%stack (output-object self)))))
      (out-eq (eq (nth 53 wm) (stack-dsl::%stack (output-expression self)))))
      (out-eq (eq (nth 55 wm) (stack-dsl::%stack (output-fkind self)))))
      (out-eq (eq (nth 57 wm) (stack-dsl::%stack (output-actualParameterList self)))))
      (out-eq (eq (nth 59 wm) (stack-dsl::%stack (output-field self)))))
      (out-eq (eq (nth 61 wm) (stack-dsl::%stack (output-externalMethod self)))))
      (out-eq (eq (nth 63 wm) (stack-dsl::%stack (output-internalMethod self)))))
      (out-eq (eq (nth 65 wm) (stack-dsl::%stack (output-letStatement self)))))
      (out-eq (eq (nth 67 wm) (stack-dsl::%stack (output-mapStatement self)))))
      (out-eq (eq (nth 69 wm) (stack-dsl::%stack (output-exitMapStatement self)))))
      (out-eq (eq (nth 7 wm) (stack-dsl::%stack (output-whenDeclarations self)))))
      (out-eq (eq (nth 71 wm) (stack-dsl::%stack (output-setStatement self)))))
      (out-eq (eq (nth 73 wm) (stack-dsl::%stack (output-createStatement self)))))
      (out-eq (eq (nth 75 wm) (stack-dsl::%stack (output-ifStatement self)))))
      (out-eq (eq (nth 77 wm) (stack-dsl::%stack (output-loopStatement self)))))
      (out-eq (eq (nth 79 wm) (stack-dsl::%stack (output-exitWhenStatement self)))))
      (out-eq (eq (nth 81 wm) (stack-dsl::%stack (output-callInternalStatement self)))))
      (out-eq (eq (nth 83 wm) (stack-dsl::%stack (output-callExternalStatement self)))))
      (out-eq (eq (nth 85 wm) (stack-dsl::%stack (output-returnTrueStatement self)))))
      (out-eq (eq (nth 87 wm) (stack-dsl::%stack (output-returnFalseStatement self)))))
      (out-eq (eq (nth 89 wm) (stack-dsl::%stack (output-returnValueStatement self)))))
      (out-eq (eq (nth 9 wm) (stack-dsl::%stack (output-esaprogram self)))))
      (out-eq (eq (nth 91 wm) (stack-dsl::%stack (output-statement self)))))
      (out-eq (eq (nth 93 wm) (stack-dsl::%stack (output-varName self)))))
      (out-eq (eq (nth 95 wm) (stack-dsl::%stack (output-filler self)))))
      (out-eq (eq (nth 97 wm) (stack-dsl::%stack (output-lval self)))))
      (out-eq (eq (nth 99 wm) (stack-dsl::%stack (output-indirectionKind self)))))
    (setf (stack-dsl::%element-type self) "actualParameterList"))
    (setf (stack-dsl::%element-type self) "classes"))
    (setf (stack-dsl::%element-type self) "fieldMap"))
    (setf (stack-dsl::%element-type self) "formalList"))
    (setf (stack-dsl::%element-type self) "implementation"))
    (setf (stack-dsl::%element-type self) "methodDeclarationsAndScriptDeclarations"))
    (setf (stack-dsl::%element-type self) "methodsTable"))
    (setf (stack-dsl::%element-type self) "situationReferenceList"))
    (setf (stack-dsl::%element-type self) "situations"))
    (setf (stack-dsl::%element-type self) "typeDecls"))
    (setf (stack-dsl::%element-type self) "whenDeclarations"))
   (unless r (error "stack depth incorrect")))))
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
  (and in-eq out-eq)))))
  (let ((r (and
  (setf (stack-dsl::%element-type self) "%bag"))
  (setf (stack-dsl::%element-type self) "%map"))(defmethod initialize-instance :after ((self %bag-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "ekind"))
  (setf (stack-dsl::%element-type self) "fkind"))
  (setf (stack-dsl::%element-type self) "indirectionKind"))
  (setf (stack-dsl::%element-type self) "name"))
  (setf (stack-dsl::%element-type self) "returnKind"))
  (setf (stack-dsl::%element-type self) actualParameterList))
  (setf (stack-dsl::%element-type self) classes))
  (setf (stack-dsl::%element-type self) fieldMap))
  (setf (stack-dsl::%element-type self) formalList))
  (setf (stack-dsl::%element-type self) implementation))
  (setf (stack-dsl::%element-type self) methodDeclarationsAndScriptDeclarations))
  (setf (stack-dsl::%element-type self) methodsTable))
  (setf (stack-dsl::%element-type self) situationReferenceList))
  (setf (stack-dsl::%element-type self) situations))
  (setf (stack-dsl::%element-type self) typeDecls))
  (setf (stack-dsl::%element-type self) whenDeclarations))
  (setf (stack-dsl::%type-list self) '(ekindobject)))
  (setf (stack-dsl::%type-list self) '(esaKindnameformalListreturnType)))
  (setf (stack-dsl::%type-list self) '(esaKindnameformalListreturnTypeimplementation)))
  (setf (stack-dsl::%type-list self) '(expression)))
  (setf (stack-dsl::%type-list self) '(expression)))
  (setf (stack-dsl::%type-list self) '(expression)))
  (setf (stack-dsl::%type-list self) '(expressionthenPartelsePart)))
  (setf (stack-dsl::%type-list self) '(filler)))
  (setf (stack-dsl::%type-list self) '(functionReference)))
  (setf (stack-dsl::%type-list self) '(functionReference)))
  (setf (stack-dsl::%type-list self) '(implementation)))
  (setf (stack-dsl::%type-list self) '(implementation)))
  (setf (stack-dsl::%type-list self) '(implementation)))
  (setf (stack-dsl::%type-list self) '(letStatementmapStatementexitMapStatementsetStatementcreateStatementifStatementloopStatementexitWhenStatementcallInternalStatementcallExternalStatementreturnTrueStatementreturnFalseStatementreturnValueStatement)))
  (setf (stack-dsl::%type-list self) '(lvalexpression)))
  (setf (stack-dsl::%type-list self) '(methodDeclarationscriptDeclaration)))
  (setf (stack-dsl::%type-list self) '(methodName)))
  (setf (stack-dsl::%type-list self) '(methodName)))
  (setf (stack-dsl::%type-list self) '(methodNamename)))
  (setf (stack-dsl::%type-list self) '(name)))
  (setf (stack-dsl::%type-list self) '(name)))
  (setf (stack-dsl::%type-list self) '(name)))
  (setf (stack-dsl::%type-list self) '(name)))
  (setf (stack-dsl::%type-list self) '(name)))
  (setf (stack-dsl::%type-list self) '(name)))
  (setf (stack-dsl::%type-list self) '(name)))
  (setf (stack-dsl::%type-list self) '(namefieldMap)))
  (setf (stack-dsl::%type-list self) '(namefieldMapmethodsTable)))
  (setf (stack-dsl::%type-list self) '(namefkindactualParameterList)))
  (setf (stack-dsl::%type-list self) '(nameformalListreturnType)))
  (setf (stack-dsl::%type-list self) '(nameformalListreturnTypeimplementation)))
  (setf (stack-dsl::%type-list self) '(nametypeName)))
  (setf (stack-dsl::%type-list self) '(returnKindname)))
  (setf (stack-dsl::%type-list self) '(situationReferenceListesaKindmethodDeclarationsAndScriptDeclarations)))
  (setf (stack-dsl::%type-list self) '(typeDeclssituationsclasseswhenDeclarations)))
  (setf (stack-dsl::%type-list self) '(varNameexpressionimplementation)))
  (setf (stack-dsl::%type-list self) '(varNameexpressionimplementation)))
  (setf (stack-dsl::%type-list self) '(varNameindirectionKindnameimplementation)))
  (setf (stack-dsl::%value-list self) '(indirectdirect)))
  (setf (stack-dsl::%value-list self) '(mapsimple)))
  (setf (stack-dsl::%value-list self) '(mapsimplevoid)))
  (setf (stack-dsl::%value-list self) '(truefalseobjectcalledObject)))
 (let ((wm (%water-mark self)))
((%water-mark :accessor %water-mark :initform nil)
(defclass %bag-stack (stack-dsl::%typed-stack) ())
(defclass %map-stack (stack-dsl::%typed-stack) ())
(defclass actualParameterList (stack-dsl::%map) () (:default-initargs :%type "actualParameterList"))
(defclass actualParameterList-stack(stack-dsl::%typed-stack) ())
(defclass callExternalStatement (stack-dsl::%compound-type) () (:default-initargs :%type "callExternalStatement"))
(defclass callExternalStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "callExternalStatement"))
(defclass callInternalStatement (stack-dsl::%compound-type) () (:default-initargs :%type "callInternalStatement"))
(defclass callInternalStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "callInternalStatement"))
(defclass classes (stack-dsl::%map) () (:default-initargs :%type "classes"))
(defclass classes-stack(stack-dsl::%typed-stack) ())
(defclass createStatement (stack-dsl::%compound-type) () (:default-initargs :%type "createStatement"))
(defclass createStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "createStatement"))
(defclass declarationMethodOrScript (stack-dsl::%compound-type) () (:default-initargs :%type "declarationMethodOrScript"))
(defclass declarationMethodOrScript-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "declarationMethodOrScript"))
(defclass ekind (stack-dsl::%enum) () (:default-initargs :%type "ekind"))
(defclass ekind-stack (stack-dsl::%typed-stack) ())
(defclass elsePart (stack-dsl::%compound-type) () (:default-initargs :%type "elsePart"))
(defclass elsePart-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "elsePart"))
(defclass environment ()
(defclass esaKind (stack-dsl::%compound-type) () (:default-initargs :%type "esaKind"))
(defclass esaKind-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "esaKind"))
(defclass esaclass (stack-dsl::%compound-type) () (:default-initargs :%type "esaclass"))
(defclass esaclass-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "esaclass"))
(defclass esaprogram (stack-dsl::%compound-type) () (:default-initargs :%type "esaprogram"))
(defclass esaprogram-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "esaprogram"))
(defclass exitMapStatement (stack-dsl::%compound-type) () (:default-initargs :%type "exitMapStatement"))
(defclass exitMapStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "exitMapStatement"))
(defclass exitWhenStatement (stack-dsl::%compound-type) () (:default-initargs :%type "exitWhenStatement"))
(defclass exitWhenStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "exitWhenStatement"))
(defclass expression (stack-dsl::%compound-type) () (:default-initargs :%type "expression"))
(defclass expression-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "expression"))
(defclass externalMethod (stack-dsl::%compound-type) () (:default-initargs :%type "externalMethod"))
(defclass externalMethod-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "externalMethod"))
(defclass field (stack-dsl::%compound-type) () (:default-initargs :%type "field"))
(defclass field-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "field"))
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
(defclass ifStatement (stack-dsl::%compound-type) () (:default-initargs :%type "ifStatement"))
(defclass ifStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "ifStatement"))
(defclass implementation (stack-dsl::%map) () (:default-initargs :%type "implementation"))
(defclass implementation-stack(stack-dsl::%typed-stack) ())
(defclass indirectionKind (stack-dsl::%enum) () (:default-initargs :%type "indirectionKind"))
(defclass indirectionKind-stack (stack-dsl::%typed-stack) ())
(defclass internalMethod (stack-dsl::%compound-type) () (:default-initargs :%type "internalMethod"))
(defclass internalMethod-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "internalMethod"))
(defclass letStatement (stack-dsl::%compound-type) () (:default-initargs :%type "letStatement"))
(defclass letStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "letStatement"))
(defclass loopStatement (stack-dsl::%compound-type) () (:default-initargs :%type "loopStatement"))
(defclass loopStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "loopStatement"))
(defclass lval (stack-dsl::%compound-type) () (:default-initargs :%type "lval"))
(defclass lval-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "lval"))
(defclass mapStatement (stack-dsl::%compound-type) () (:default-initargs :%type "mapStatement"))
(defclass mapStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "mapStatement"))
(defclass methodDeclaration (stack-dsl::%compound-type) () (:default-initargs :%type "methodDeclaration"))
(defclass methodDeclaration-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "methodDeclaration"))
(defclass methodDeclarationsAndScriptDeclarations (stack-dsl::%map) () (:default-initargs :%type "methodDeclarationsAndScriptDeclarations"))
(defclass methodDeclarationsAndScriptDeclarations-stack(stack-dsl::%typed-stack) ())
(defclass methodName (stack-dsl::%compound-type) () (:default-initargs :%type "methodName"))
(defclass methodName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "methodName"))
(defclass methodsTable (stack-dsl::%map) () (:default-initargs :%type "methodsTable"))
(defclass methodsTable-stack(stack-dsl::%typed-stack) ())
(defclass name (stack-dsl::%string) () (:default-initargs :%type "name"))
(defclass name-stack (stack-dsl::%typed-stack) ())
(defclass object (stack-dsl::%compound-type) () (:default-initargs :%type "object"))
(defclass object-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "object"))
(defclass returnFalseStatement (stack-dsl::%compound-type) () (:default-initargs :%type "returnFalseStatement"))
(defclass returnFalseStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "returnFalseStatement"))
(defclass returnKind (stack-dsl::%enum) () (:default-initargs :%type "returnKind"))
(defclass returnKind-stack (stack-dsl::%typed-stack) ())
(defclass returnTrueStatement (stack-dsl::%compound-type) () (:default-initargs :%type "returnTrueStatement"))
(defclass returnTrueStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "returnTrueStatement"))
(defclass returnType (stack-dsl::%compound-type) () (:default-initargs :%type "returnType"))
(defclass returnType-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "returnType"))
(defclass returnValueStatement (stack-dsl::%compound-type) () (:default-initargs :%type "returnValueStatement"))
(defclass returnValueStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "returnValueStatement"))
(defclass scriptDeclaration (stack-dsl::%compound-type) () (:default-initargs :%type "scriptDeclaration"))
(defclass scriptDeclaration-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "scriptDeclaration"))
(defclass setStatement (stack-dsl::%compound-type) () (:default-initargs :%type "setStatement"))
(defclass setStatement-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "setStatement"))
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
(defclass typeDecl (stack-dsl::%compound-type) () (:default-initargs :%type "typeDecl"))
(defclass typeDecl-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "typeDecl"))
(defclass typeDecls (stack-dsl::%map) () (:default-initargs :%type "typeDecls"))
(defclass typeDecls-stack(stack-dsl::%typed-stack) ())
(defclass typeName (stack-dsl::%compound-type) () (:default-initargs :%type "typeName"))
(defclass typeName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "typeName"))
(defclass varName (stack-dsl::%compound-type) () (:default-initargs :%type "varName"))
(defclass varName-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "varName"))
(defclass whenDeclaration (stack-dsl::%compound-type) () (:default-initargs :%type "whenDeclaration"))
(defclass whenDeclaration-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "whenDeclaration"))
(defclass whenDeclarations (stack-dsl::%map) () (:default-initargs :%type "whenDeclarations"))
(defclass whenDeclarations-stack(stack-dsl::%typed-stack) ())
(defmethod %memoCheck ((self environment))
(defmethod initialize-instance :after ((self %map-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self actualParameterList) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self actualParameterList-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self callExternalStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self callInternalStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self classes) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self classes-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self createStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self declarationMethodOrScript) &key &allow-other-keys)
(defmethod initialize-instance :after ((self ekind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self ekind-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self elsePart) &key &allow-other-keys)
(defmethod initialize-instance :after ((self esaKind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self esaclass) &key &allow-other-keys)
(defmethod initialize-instance :after ((self esaprogram) &key &allow-other-keys)
(defmethod initialize-instance :after ((self exitMapStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self exitWhenStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self expression) &key &allow-other-keys)
(defmethod initialize-instance :after ((self externalMethod) &key &allow-other-keys)
(defmethod initialize-instance :after ((self field) &key &allow-other-keys)
(defmethod initialize-instance :after ((self fieldMap) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self fieldMap-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self filler) &key &allow-other-keys)
(defmethod initialize-instance :after ((self fkind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self fkind-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self formalList) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self formalList-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self functionReference) &key &allow-other-keys)
(defmethod initialize-instance :after ((self ifStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self implementation) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self implementation-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self indirectionKind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self indirectionKind-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self internalMethod) &key &allow-other-keys)
(defmethod initialize-instance :after ((self letStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self loopStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self lval) &key &allow-other-keys)
(defmethod initialize-instance :after ((self mapStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self methodDeclaration) &key &allow-other-keys)
(defmethod initialize-instance :after ((self methodDeclarationsAndScriptDeclarations) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self methodDeclarationsAndScriptDeclarations-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self methodName) &key &allow-other-keys)
(defmethod initialize-instance :after ((self methodsTable) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self methodsTable-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self object) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnFalseStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnKind) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnKind-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnTrueStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnType) &key &allow-other-keys)
(defmethod initialize-instance :after ((self returnValueStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self scriptDeclaration) &key &allow-other-keys)
(defmethod initialize-instance :after ((self setStatement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self situationDefinition) &key &allow-other-keys)
(defmethod initialize-instance :after ((self situationReferenceList) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self situationReferenceList-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self situationReferenceName) &key &allow-other-keys)
(defmethod initialize-instance :after ((self situations) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self situations-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self statement) &key &allow-other-keys)
(defmethod initialize-instance :after ((self thenPart) &key &allow-other-keys)
(defmethod initialize-instance :after ((self typeDecl) &key &allow-other-keys)
(defmethod initialize-instance :after ((self typeDecls) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self typeDecls-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self typeName) &key &allow-other-keys)
(defmethod initialize-instance :after ((self varName) &key &allow-other-keys)
(defmethod initialize-instance :after ((self whenDeclaration) &key &allow-other-keys)
(defmethod initialize-instance :after ((self whenDeclarations) &key &allow-other-keys)  ;; type for items in map
(defmethod initialize-instance :after ((self whenDeclarations-stack) &key &allow-other-keys)
(defmethod initialize-instance :after ((self ~a-stack) &key &allow-other-keys)
(defparameter *stacks* '(
(input-actualParameterList :accessor input-actualParameterList :initform (make-instance 'actualParameterList))
(input-callExternalStatement :accessor input-callExternalStatement :initform (make-instance 'callExternalStatement))
(input-callInternalStatement :accessor input-callInternalStatement :initform (make-instance 'callInternalStatement))
(input-classes :accessor input-classes :initform (make-instance 'classes))
(input-createStatement :accessor input-createStatement :initform (make-instance 'createStatement))
(input-declarationMethodOrScript :accessor input-declarationMethodOrScript :initform (make-instance 'declarationMethodOrScript))
(input-ekind :accessor input-ekind :initform (make-instance 'ekind))
(input-elsePart :accessor input-elsePart :initform (make-instance 'elsePart))
(input-esaKind :accessor input-esaKind :initform (make-instance 'esaKind))
(input-esaclass :accessor input-esaclass :initform (make-instance 'esaclass))
(input-esaprogram :accessor input-esaprogram :initform (make-instance 'esaprogram))
(input-exitMapStatement :accessor input-exitMapStatement :initform (make-instance 'exitMapStatement))
(input-exitWhenStatement :accessor input-exitWhenStatement :initform (make-instance 'exitWhenStatement))
(input-expression :accessor input-expression :initform (make-instance 'expression))
(input-externalMethod :accessor input-externalMethod :initform (make-instance 'externalMethod))
(input-field :accessor input-field :initform (make-instance 'field))
(input-fieldMap :accessor input-fieldMap :initform (make-instance 'fieldMap))
(input-filler :accessor input-filler :initform (make-instance 'filler))
(input-fkind :accessor input-fkind :initform (make-instance 'fkind))
(input-formalList :accessor input-formalList :initform (make-instance 'formalList))
(input-functionReference :accessor input-functionReference :initform (make-instance 'functionReference))
(input-ifStatement :accessor input-ifStatement :initform (make-instance 'ifStatement))
(input-implementation :accessor input-implementation :initform (make-instance 'implementation))
(input-indirectionKind :accessor input-indirectionKind :initform (make-instance 'indirectionKind))
(input-internalMethod :accessor input-internalMethod :initform (make-instance 'internalMethod))
(input-letStatement :accessor input-letStatement :initform (make-instance 'letStatement))
(input-loopStatement :accessor input-loopStatement :initform (make-instance 'loopStatement))
(input-lval :accessor input-lval :initform (make-instance 'lval))
(input-mapStatement :accessor input-mapStatement :initform (make-instance 'mapStatement))
(input-methodDeclaration :accessor input-methodDeclaration :initform (make-instance 'methodDeclaration))
(input-methodDeclarationsAndScriptDeclarations :accessor input-methodDeclarationsAndScriptDeclarations :initform (make-instance 'methodDeclarationsAndScriptDeclarations))
(input-methodName :accessor input-methodName :initform (make-instance 'methodName))
(input-methodsTable :accessor input-methodsTable :initform (make-instance 'methodsTable))
(input-name :accessor input-name :initform (make-instance 'name))
(input-object :accessor input-object :initform (make-instance 'object))
(input-returnFalseStatement :accessor input-returnFalseStatement :initform (make-instance 'returnFalseStatement))
(input-returnKind :accessor input-returnKind :initform (make-instance 'returnKind))
(input-returnTrueStatement :accessor input-returnTrueStatement :initform (make-instance 'returnTrueStatement))
(input-returnType :accessor input-returnType :initform (make-instance 'returnType))
(input-returnValueStatement :accessor input-returnValueStatement :initform (make-instance 'returnValueStatement))
(input-scriptDeclaration :accessor input-scriptDeclaration :initform (make-instance 'scriptDeclaration))
(input-setStatement :accessor input-setStatement :initform (make-instance 'setStatement))
(input-situationDefinition :accessor input-situationDefinition :initform (make-instance 'situationDefinition))
(input-situationReferenceList :accessor input-situationReferenceList :initform (make-instance 'situationReferenceList))
(input-situationReferenceName :accessor input-situationReferenceName :initform (make-instance 'situationReferenceName))
(input-situations :accessor input-situations :initform (make-instance 'situations))
(input-statement :accessor input-statement :initform (make-instance 'statement))
(input-thenPart :accessor input-thenPart :initform (make-instance 'thenPart))
(input-typeDecl :accessor input-typeDecl :initform (make-instance 'typeDecl))
(input-typeDecls :accessor input-typeDecls :initform (make-instance 'typeDecls))
(input-typeName :accessor input-typeName :initform (make-instance 'typeName))
(input-varName :accessor input-varName :initform (make-instance 'varName))
(input-whenDeclaration :accessor input-whenDeclaration :initform (make-instance 'whenDeclaration))
(input-whenDeclarations :accessor input-whenDeclarations :initform (make-instance 'whenDeclarations))
(let ((in-eq (eq (nth 0 wm) (stack-dsl::%stack (input-typeDecls self))))
(let ((in-eq (eq (nth 10 wm) (stack-dsl::%stack (input-name self))))
(let ((in-eq (eq (nth 100 wm) (stack-dsl::%stack (input-thenPart self))))
(let ((in-eq (eq (nth 102 wm) (stack-dsl::%stack (input-elsePart self))))
(let ((in-eq (eq (nth 104 wm) (stack-dsl::%stack (input-methodName self))))
(let ((in-eq (eq (nth 106 wm) (stack-dsl::%stack (input-functionReference self))))
(let ((in-eq (eq (nth 12 wm) (stack-dsl::%stack (input-typeName self))))
(let ((in-eq (eq (nth 14 wm) (stack-dsl::%stack (input-typeDecl self))))
(let ((in-eq (eq (nth 16 wm) (stack-dsl::%stack (input-situationDefinition self))))
(let ((in-eq (eq (nth 18 wm) (stack-dsl::%stack (input-fieldMap self))))
(let ((in-eq (eq (nth 2 wm) (stack-dsl::%stack (input-situations self))))
(let ((in-eq (eq (nth 20 wm) (stack-dsl::%stack (input-methodsTable self))))
(let ((in-eq (eq (nth 22 wm) (stack-dsl::%stack (input-esaclass self))))
(let ((in-eq (eq (nth 24 wm) (stack-dsl::%stack (input-situationReferenceList self))))
(let ((in-eq (eq (nth 26 wm) (stack-dsl::%stack (input-esaKind self))))
(let ((in-eq (eq (nth 28 wm) (stack-dsl::%stack (input-methodDeclarationsAndScriptDeclarations self))))
(let ((in-eq (eq (nth 30 wm) (stack-dsl::%stack (input-whenDeclaration self))))
(let ((in-eq (eq (nth 32 wm) (stack-dsl::%stack (input-situationReferenceName self))))
(let ((in-eq (eq (nth 34 wm) (stack-dsl::%stack (input-methodDeclaration self))))
(let ((in-eq (eq (nth 36 wm) (stack-dsl::%stack (input-scriptDeclaration self))))
(let ((in-eq (eq (nth 38 wm) (stack-dsl::%stack (input-declarationMethodOrScript self))))
(let ((in-eq (eq (nth 4 wm) (stack-dsl::%stack (input-classes self))))
(let ((in-eq (eq (nth 40 wm) (stack-dsl::%stack (input-formalList self))))
(let ((in-eq (eq (nth 42 wm) (stack-dsl::%stack (input-returnType self))))
(let ((in-eq (eq (nth 44 wm) (stack-dsl::%stack (input-implementation self))))
(let ((in-eq (eq (nth 46 wm) (stack-dsl::%stack (input-returnKind self))))
(let ((in-eq (eq (nth 48 wm) (stack-dsl::%stack (input-ekind self))))
(let ((in-eq (eq (nth 50 wm) (stack-dsl::%stack (input-object self))))
(let ((in-eq (eq (nth 52 wm) (stack-dsl::%stack (input-expression self))))
(let ((in-eq (eq (nth 54 wm) (stack-dsl::%stack (input-fkind self))))
(let ((in-eq (eq (nth 56 wm) (stack-dsl::%stack (input-actualParameterList self))))
(let ((in-eq (eq (nth 58 wm) (stack-dsl::%stack (input-field self))))
(let ((in-eq (eq (nth 6 wm) (stack-dsl::%stack (input-whenDeclarations self))))
(let ((in-eq (eq (nth 60 wm) (stack-dsl::%stack (input-externalMethod self))))
(let ((in-eq (eq (nth 62 wm) (stack-dsl::%stack (input-internalMethod self))))
(let ((in-eq (eq (nth 64 wm) (stack-dsl::%stack (input-letStatement self))))
(let ((in-eq (eq (nth 66 wm) (stack-dsl::%stack (input-mapStatement self))))
(let ((in-eq (eq (nth 68 wm) (stack-dsl::%stack (input-exitMapStatement self))))
(let ((in-eq (eq (nth 70 wm) (stack-dsl::%stack (input-setStatement self))))
(let ((in-eq (eq (nth 72 wm) (stack-dsl::%stack (input-createStatement self))))
(let ((in-eq (eq (nth 74 wm) (stack-dsl::%stack (input-ifStatement self))))
(let ((in-eq (eq (nth 76 wm) (stack-dsl::%stack (input-loopStatement self))))
(let ((in-eq (eq (nth 78 wm) (stack-dsl::%stack (input-exitWhenStatement self))))
(let ((in-eq (eq (nth 8 wm) (stack-dsl::%stack (input-esaprogram self))))
(let ((in-eq (eq (nth 80 wm) (stack-dsl::%stack (input-callInternalStatement self))))
(let ((in-eq (eq (nth 82 wm) (stack-dsl::%stack (input-callExternalStatement self))))
(let ((in-eq (eq (nth 84 wm) (stack-dsl::%stack (input-returnTrueStatement self))))
(let ((in-eq (eq (nth 86 wm) (stack-dsl::%stack (input-returnFalseStatement self))))
(let ((in-eq (eq (nth 88 wm) (stack-dsl::%stack (input-returnValueStatement self))))
(let ((in-eq (eq (nth 90 wm) (stack-dsl::%stack (input-statement self))))
(let ((in-eq (eq (nth 92 wm) (stack-dsl::%stack (input-varName self))))
(let ((in-eq (eq (nth 94 wm) (stack-dsl::%stack (input-filler self))))
(let ((in-eq (eq (nth 96 wm) (stack-dsl::%stack (input-lval self))))
(let ((in-eq (eq (nth 98 wm) (stack-dsl::%stack (input-indirectionKind self))))
(output-actualParameterList :accessor output-actualParameterList :initform (make-instance 'actualParameterList))
(output-callExternalStatement :accessor output-callExternalStatement :initform (make-instance 'callExternalStatement))
(output-callInternalStatement :accessor output-callInternalStatement :initform (make-instance 'callInternalStatement))
(output-classes :accessor output-classes :initform (make-instance 'classes))
(output-createStatement :accessor output-createStatement :initform (make-instance 'createStatement))
(output-declarationMethodOrScript :accessor output-declarationMethodOrScript :initform (make-instance 'declarationMethodOrScript))
(output-ekind :accessor output-ekind :initform (make-instance 'ekind))
(output-elsePart :accessor output-elsePart :initform (make-instance 'elsePart))
(output-esaKind :accessor output-esaKind :initform (make-instance 'esaKind))
(output-esaclass :accessor output-esaclass :initform (make-instance 'esaclass))
(output-esaprogram :accessor output-esaprogram :initform (make-instance 'esaprogram))
(output-exitMapStatement :accessor output-exitMapStatement :initform (make-instance 'exitMapStatement))
(output-exitWhenStatement :accessor output-exitWhenStatement :initform (make-instance 'exitWhenStatement))
(output-expression :accessor output-expression :initform (make-instance 'expression))
(output-externalMethod :accessor output-externalMethod :initform (make-instance 'externalMethod))
(output-field :accessor output-field :initform (make-instance 'field))
(output-fieldMap :accessor output-fieldMap :initform (make-instance 'fieldMap))
(output-filler :accessor output-filler :initform (make-instance 'filler))
(output-fkind :accessor output-fkind :initform (make-instance 'fkind))
(output-formalList :accessor output-formalList :initform (make-instance 'formalList))
(output-functionReference :accessor output-functionReference :initform (make-instance 'functionReference))
(output-ifStatement :accessor output-ifStatement :initform (make-instance 'ifStatement))
(output-implementation :accessor output-implementation :initform (make-instance 'implementation))
(output-indirectionKind :accessor output-indirectionKind :initform (make-instance 'indirectionKind))
(output-internalMethod :accessor output-internalMethod :initform (make-instance 'internalMethod))
(output-letStatement :accessor output-letStatement :initform (make-instance 'letStatement))
(output-loopStatement :accessor output-loopStatement :initform (make-instance 'loopStatement))
(output-lval :accessor output-lval :initform (make-instance 'lval))
(output-mapStatement :accessor output-mapStatement :initform (make-instance 'mapStatement))
(output-methodDeclaration :accessor output-methodDeclaration :initform (make-instance 'methodDeclaration))
(output-methodDeclarationsAndScriptDeclarations :accessor output-methodDeclarationsAndScriptDeclarations :initform (make-instance 'methodDeclarationsAndScriptDeclarations))
(output-methodName :accessor output-methodName :initform (make-instance 'methodName))
(output-methodsTable :accessor output-methodsTable :initform (make-instance 'methodsTable))
(output-name :accessor output-name :initform (make-instance 'name))
(output-object :accessor output-object :initform (make-instance 'object))
(output-returnFalseStatement :accessor output-returnFalseStatement :initform (make-instance 'returnFalseStatement))
(output-returnKind :accessor output-returnKind :initform (make-instance 'returnKind))
(output-returnTrueStatement :accessor output-returnTrueStatement :initform (make-instance 'returnTrueStatement))
(output-returnType :accessor output-returnType :initform (make-instance 'returnType))
(output-returnValueStatement :accessor output-returnValueStatement :initform (make-instance 'returnValueStatement))
(output-scriptDeclaration :accessor output-scriptDeclaration :initform (make-instance 'scriptDeclaration))
(output-setStatement :accessor output-setStatement :initform (make-instance 'setStatement))
(output-situationDefinition :accessor output-situationDefinition :initform (make-instance 'situationDefinition))
(output-situationReferenceList :accessor output-situationReferenceList :initform (make-instance 'situationReferenceList))
(output-situationReferenceName :accessor output-situationReferenceName :initform (make-instance 'situationReferenceName))
(output-situations :accessor output-situations :initform (make-instance 'situations))
(output-statement :accessor output-statement :initform (make-instance 'statement))
(output-thenPart :accessor output-thenPart :initform (make-instance 'thenPart))
(output-typeDecl :accessor output-typeDecl :initform (make-instance 'typeDecl))
(output-typeDecls :accessor output-typeDecls :initform (make-instance 'typeDecls))
(output-typeName :accessor output-typeName :initform (make-instance 'typeName))
(output-varName :accessor output-varName :initform (make-instance 'varName))
(output-whenDeclaration :accessor output-whenDeclaration :initform (make-instance 'whenDeclaration))
(output-whenDeclarations :accessor output-whenDeclarations :initform (make-instance 'whenDeclarations))
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))(in-package "CL-USER")
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
))
))  
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
