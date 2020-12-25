(in-package "ARROWGRAMS/ESA-TRANSPILER")
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))


(defmethod rmSpaces-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "rmSpaces")
(cond
((pasm:parser-success? (pasm:lookahead? p :SPACE)))
((pasm:parser-success? (pasm:lookahead? p :COMMENT)))
( t  (pasm:accept p) 
)
)

)

(defmethod esa-dsl-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "esa-dsl")
(pasm::pasm-filter-stream p #'rmSpaces-PASS2)
(pasm:call-external p #'$esaprogram__BeginScope)
(pasm:call-external p #'$classes__FromProgram_BeginScope)
(pasm:call-rule p #'type-decls-PASS2)
(pasm:call-rule p #'situations-PASS2)
(pasm:call-rule p #'classes-PASS2)
(pasm:call-external p #'$whenDeclarations__FromProgram_BeginScope)
(pasm:call-rule p #'parse-whens-and-scripts-PASS2)
(pasm:call-external p #'$whenDeclarations__EndScope)
(pasm:input p :EOF)
(pasm:call-external p #'$classes__EndScope)
(pasm:call-external p #'$esaprogram__Output)
)

(defmethod keyword-symbol-PASS2 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "create"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "end"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "method"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "let"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "set"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "in"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "loop"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "if"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "then"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "else"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "when"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "or"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-map"))(return-from keyword-symbol-PASS2 pasm:+succeed+)
)
( t (return-from keyword-symbol-PASS2 pasm:+fail+)
)
)

)
( t (return-from keyword-symbol-PASS2 pasm:+fail+)
)
)

)

(defmethod non-keyword-symbol-PASS2 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:call-predicate p #'keyword-symbol-PASS2))(return-from non-keyword-symbol-PASS2 pasm:+fail+)
)
( t (return-from non-keyword-symbol-PASS2 pasm:+succeed+)
)
)

)
( t (return-from non-keyword-symbol-PASS2 pasm:+fail+)
)
)

)

(defmethod type-decls-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "type-decls")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(pasm:call-rule p #'type-decl-PASS2)
)
( t (return)
)
)

)

)

(defmethod type-decl-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "type-decl")
(pasm:input-symbol p "type")
(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
)

(defmethod situations-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "situations")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(pasm:call-rule p #'parse-situation-def-PASS2)
)
( t (return)
)
)

)

)

(defmethod parse-situation-def-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "parse-situation-def")
(pasm:input-symbol p "situation")
(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
)

(defmethod classes-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "classes")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(pasm:call-rule p #'class-def-PASS2)
)
( t (return)
)
)

)

)

(defmethod parse-whens-and-scripts-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "parse-whens-and-scripts")
(pasm:call-external p #'$whenDeclarations__BeginMapping)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "when"))(pasm:call-external p #'$whenDeclaration__FromWhenDeclarationsMap_BeginScope)
(pasm:call-rule p #'when-declaration-PASS2)
(pasm:call-external p #'$whenDeclaration__EndScope)
(pasm:call-external p #'$whenDeclarations__Next)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(pasm:call-rule p #'script-implementation-PASS2)
)
( t (return)
)
)

)

(pasm:call-external p #'$whenDeclarations__EndMapping)
)

(defmethod class-def-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "class-def")
(pasm:input-symbol p "class")
(pasm:call-rule p #'esaSymbol-PASS2)
(pasm:call-external p #'$esaclass__LookupFromClasses_BeginScope)
(pasm:call-external p #'$esaclass__SetField_methodsTable_empty)
(pasm:call-rule p #'field-decl-PASS2)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'field-decl-begin-PASS2))(pasm:call-rule p #'field-decl-PASS2)
)
( t (return)
)
)

)

(pasm:input-symbol p "end")
(pasm:input-symbol p "class")
(pasm:call-external p #'$esaclass__EndScope)
)

(defmethod field-decl-begin-PASS2 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(return-from field-decl-begin-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS2))(return-from field-decl-begin-PASS2 pasm:+succeed+)
)
( t (return-from field-decl-begin-PASS2 pasm:+fail+)
)
)

)

(defmethod field-decl-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "field-decl")
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS2))(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
)
)

)

(defmethod when-declaration-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "when-declaration")
(pasm:input-symbol p "when")
(pasm:call-rule p #'situation-ref-PASS2)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "or"))(pasm:call-rule p #'or-situation-PASS2)
)
( t (return)
)
)

)

(pasm:call-rule p #'class-ref-PASS2)
(pasm:call-external p #'$esaclass__LookupFromClasses_BeginScope)
(pasm:call-external p #'$methodDeclarationsAndScriptDeclarations__FromWhenDeclaration_BeginScope)
(pasm:call-external p #'$methodDeclarationsAndScriptDeclarations__BeginMapping)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(pasm:call-external p #'$scriptDeclaration__FromMap_BeginScope)
(pasm:call-external p #'$esaKind__FromClass_BeginOutputScope)
(pasm:call-external p #'$scriptDeclaration__SetField_esaKind_from_esaKind)
(pasm:call-rule p #'script-declaration-in-when-PASS2)
(pasm:call-external p #'$scriptDeclaration__SetField_implementation_empty)
(pasm:call-external p #'$scriptDeclaration__Output)
(pasm:call-external p #'$declarationMethodOrScript__NewScope)
(pasm:call-external p #'$declarationMethodOrScript__CoerceFrom_scriptDeclaration)
(pasm:call-external p #'$declarationMethodOrScript__Output)
(pasm:call-external p #'$methodsTable__FromClass_BeginScope)
(pasm:call-external p #'$methodsTable__AppendFrom_declarationMethodOrScript)
(pasm:call-external p #'$methodsTable__EndScope)
(pasm:call-external p #'$methodDeclarationsAndScriptDeclarations__Next)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "method"))(pasm:call-external p #'$methodDeclaration__FromMap_BeginScope)
(pasm:call-external p #'$esaKind__FromClass_BeginOutputScope)
(pasm:call-external p #'$methodDeclaration__SetField_esaKind_from_esaKind)
(pasm:call-rule p #'method-declaration-in-when-PASS2)
(pasm:call-external p #'$methodDeclaration__Output)
(pasm:call-external p #'$declarationMethodOrScript__NewScope)
(pasm:call-external p #'$declarationMethodOrScript__CoerceFrom_methodDeclaration)
(pasm:call-external p #'$declarationMethodOrScript__Output)
(pasm:call-external p #'$methodsTable__FromClass_BeginScope)
(pasm:call-external p #'$methodsTable__AppendFrom_declarationMethodOrScript)
(pasm:call-external p #'$methodsTable__EndScope)
(pasm:call-external p #'$methodDeclarationsAndScriptDeclarations__Next)
)
( t (return)
)
)

)

(pasm:input-symbol p "end")
(pasm:input-symbol p "when")
(pasm:call-external p #'$methodDeclarationsAndScriptDeclarations__EndMapping)
(pasm:call-external p #'$methodDeclarationsAndScriptDeclarations__EndScope)
(pasm:call-external p #'$esaclass__EndScope)
)

(defmethod situation-ref-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "situation-ref")
(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
)

(defmethod or-situation-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "or-situation")
(pasm:input-symbol p "or")
(pasm:call-rule p #'situation-ref-PASS2)
)

(defmethod class-ref-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "class-ref")
(pasm:call-rule p #'esaSymbol-PASS2)
)

(defmethod method-declaration-in-when-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "method-declaration-in-when")
(pasm:input-symbol p "method")
(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
(pasm:call-rule p #'formals-PASS2)
(pasm:call-rule p #'return-type-declaration-PASS2)
)

(defmethod script-declaration-in-when-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "script-declaration-in-when")
(pasm:input-symbol p "script")
(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
(pasm:call-rule p #'formals-PASS2)
(pasm:call-rule p #'return-type-declaration-PASS2)
)

(defmethod formals-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "formals")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-rule p #'type-list-PASS2)
(pasm:input-char p #\))
)
( t )
)

)

(defmethod type-list-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "type-list")
(pasm:call-rule p #'esaSymbol-PASS2)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS2))(pasm:call-rule p #'esaSymbol-PASS2)
)
( t (return)
)
)

)

)

(defmethod return-type-declaration-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "return-type-declaration")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esaSymbol-PASS2)
)
( t (pasm:call-rule p #'esaSymbol-PASS2)
)
)

)
( t )
)

)

(defmethod esaSymbol-in-decl-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "esaSymbol-in-decl")
(pasm:call-rule p #'esaSymbol-PASS2)
(pasm:call-external p #'$name__IgnoreInPass2)
)

(defmethod script-implementation-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "script-implementation")
(pasm:input-symbol p "script")
(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
(pasm:call-rule p #'optional-formals-definition-PASS2)
(pasm:call-rule p #'optional-return-type-definition-PASS2)
(pasm:call-rule p #'script-body-PASS2)
(pasm:input-symbol p "end")
(pasm:input-symbol p "script")
(pasm:call-external p #'$esaclass__EndScope)
)

(defmethod optional-formals-definition-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "optional-formals-definition")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-rule p #'untyped-formals-definition-PASS2)
(pasm:input-char p #\))
)
( t (return)
)
)

)

)

(defmethod untyped-formals-definition-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "untyped-formals-definition")
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS2))(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
)
( t (return)
)
)

)

)

(defmethod optional-return-type-definition-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "optional-return-type-definition")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esaSymbol-in-decl-PASS2)
)
( t (pasm:call-rule p #'esaSymbol-in-decl-PASS2)
)
)

)
( t )
)

)

(defmethod script-body-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "script-body")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "let"))(pasm:call-rule p #'let-statement-PASS2)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:call-rule p #'map-statement-PASS2)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-map"))(pasm:call-rule p #'exit-map-statement-PASS2)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "set"))(pasm:call-rule p #'set-statement-PASS2)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "create"))(pasm:call-rule p #'create-statement-PASS2)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "if"))(pasm:call-rule p #'if-statement-PASS2)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "loop"))(pasm:call-rule p #'loop-statement-PASS2)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-when"))(pasm:call-rule p #'exit-when-statement-PASS2)
)
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:call-rule p #'return-statement-PASS2)
)
((pasm:parser-success? (pasm:lookahead-char? p #\@))(pasm:call-rule p #'callInternalStatement-PASS2)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS2))(pasm:call-rule p #'callExternalStatement-PASS2)
)
( t (return)
)
)

)

)

(defmethod callInternalStatement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "callInternalStatement")
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
(pasm:call-external p #'$expression__IgnoreInPass1)
)

(defmethod callExternalStatement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "callExternalStatement")
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
(pasm:call-external p #'$expression__IgnoreInPass1)
)

(defmethod let-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "let-statement")
(pasm:input-symbol p "let")
(pasm:call-rule p #'esaSymbol-in-statement-PASS2)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body-PASS2)
(pasm:input-symbol p "end")
(pasm:input-symbol p "let")
)

(defmethod create-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "create-statement")
(pasm:input-symbol p "create")
(pasm:call-rule p #'esaSymbol-in-statement-PASS2)
(pasm:input-char p #\=)
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\*))(pasm:input-char p #\*)
(pasm:call-rule p #'class-ref-PASS2)
(pasm:call-external p #'$name__IgnoreInPass2)
)
( t (pasm:call-rule p #'class-ref-PASS2)
(pasm:call-external p #'$name__IgnoreInPass2)
)
)

(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body-PASS2)
(pasm:input-symbol p "end")
(pasm:input-symbol p "create")
)

(defmethod set-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "set-statement")
(pasm:input-symbol p "set")
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
)

(defmethod map-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "map-statement")
(pasm:input-symbol p "map")
(pasm:call-rule p #'esaSymbol-in-statement-PASS2)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body-PASS2)
(pasm:input-symbol p "end")
(pasm:input-symbol p "map")
)

(defmethod exit-map-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "exit-map-statement")
(pasm:input-symbol p "exit-map")
)

(defmethod loop-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "loop-statement")
(pasm:input-symbol p "loop")
(pasm:call-rule p #'script-body-PASS2)
(pasm:input-symbol p "end")
(pasm:input-symbol p "loop")
)

(defmethod exit-when-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "exit-when-statement")
(pasm:input-symbol p "exit-when")
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
)

(defmethod if-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "if-statement")
(pasm:input-symbol p "if")
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
(pasm:input-symbol p "then")
(pasm:call-rule p #'script-body-PASS2)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "else"))(pasm:input-symbol p "else")
(pasm:call-rule p #'script-body-PASS2)
)
( t )
)

(pasm:input-symbol p "end")
(pasm:input-symbol p "if")
)

(defmethod script-call-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "script-call")
(pasm:input-char p #\@)
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
)

(defmethod method-call-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "method-call")
(pasm:call-rule p #'esa-expr-in-statement-PASS2)
)

(defmethod return-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "return-statement")
(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(pasm:input-symbol p "true")
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(pasm:input-symbol p "false")
)
( t (pasm:call-rule p #'esaSymbol-in-statement-PASS2)
)
)

)

(defmethod esaSymbol-in-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "esaSymbol-in-statement")
(pasm:call-rule p #'esaSymbol-PASS2)
)

(defmethod esa-expr-in-statement-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "esa-expr-in-statement")
(pasm:call-rule p #'esa-expr-PASS2)
)

(defmethod esa-expr-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "esa-expr")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\@))(pasm:input-char p #\@)
)
( t )
)

(pasm:call-external p #'$expression__NewScope)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(pasm:input-symbol p "true")
(pasm:call-external p #'$ekind__NewScope)
(pasm:call-external p #'$ekind__SetEnum_true)
(pasm:call-external p #'$ekind__Output)
(pasm:call-external p #'$expression__SetField_ekind_from_ekind)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(pasm:input-symbol p "false")
(pasm:call-external p #'$ekind__NewScope)
(pasm:call-external p #'$ekind__SetEnum_false)
(pasm:call-external p #'$ekind__Output)
(pasm:call-external p #'$expression__SetField_ekind_from_ekind)
)
( t (pasm:call-external p #'$ekind__NewScope)
(pasm:call-external p #'$ekind__SetEnum_object)
(pasm:call-external p #'$ekind__Output)
(pasm:call-external p #'$expression__SetField_ekind_from_ekind)
(pasm:call-rule p #'object__-PASS2)
(pasm:call-external p #'$expression__SetField_object_from_object)
)
)

(pasm:call-external p #'$expression__Output)
)

(defmethod object__-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__")
(pasm:call-external p #'$object__NewScope)
(pasm:call-rule p #'object__name-PASS2)
(pasm:call-external p #'$object__SetField_name_from_name)
(pasm:call-external p #'$fieldMap__NewScope)
(pasm:call-rule p #'object__fields-PASS2)
(pasm:call-external p #'$fieldMap__Output)
(pasm:call-external p #'$object__SetField_fieldMap_from_fieldMap)
(pasm:call-external p #'$object__Output)
)

(defmethod object__name-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__name")
(pasm:call-rule p #'esaSymbol-PASS2)
)

(defmethod object__fields-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__fields")
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'object__field_p-PASS2))(pasm:call-external p #'$field__NewScope)
(pasm:call-rule p #'object__single_field-PASS2)
(pasm:call-external p #'$field__Output)
(pasm:call-external p #'$fieldMap__AppendFrom_field)
)
( t (return)
)
)

)

)

(defmethod object__field_p-PASS2 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(return-from object__field_p-PASS2 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-char? p #\())(return-from object__field_p-PASS2 pasm:+succeed+)
)
( t (return-from object__field_p-PASS2 pasm:+fail+)
)
)

)

(defmethod object__single_field-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__single_field")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(pasm:call-rule p #'object__dotFieldName-PASS2)
(pasm:call-rule p #'object__parameterMap-PASS2)
)
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:call-rule p #'object__parameterMap-PASS2)
)
( t )
)

)

(defmethod object__dotFieldName-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__dotFieldName")
(pasm:input-char p #\.)
(pasm:call-rule p #'esaSymbol-PASS2)
(pasm:call-external p #'$field__SetField_name_from_name)
)

(defmethod object__parameterMap-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__parameterMap")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:call-external p #'$actualParameterList__NewScope)
(pasm:input-char p #\()
(pasm:call-rule p #'esa-expr-PASS2)
(pasm:call-external p #'$actualParameterList__AppendFrom_expression)
(pasm:call-rule p #'object__field__recursive-more-parameters-PASS2)
(pasm:input-char p #\))
(pasm:call-external p #'$actualParameterList__Output)
(pasm:call-external p #'$field__SetField_actualParameterList_from_actualParameterList)
)
( t )
)

)

(defmethod object__field__recursive-more-parameters-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__field__recursive-more-parameters")
(cond
((pasm:parser-success? (pasm:call-predicate p #'object__field__parameters__pred-parameterBegin-PASS2))(pasm:call-rule p #'esa-expr-PASS2)
(pasm:call-external p #'$actualParameterList__AppendFrom_expression)
(pasm:call-rule p #'object__field__recursive-more-parameters-PASS2)
)
( t )
)

)

(defmethod object__field__parameters__pred-parameterBegin-PASS2 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))(return-from object__field__parameters__pred-parameterBegin-PASS2 pasm:+succeed+)
)
( t (return-from object__field__parameters__pred-parameterBegin-PASS2 pasm:+fail+)
)
)

)

(defmethod object__field__parameters__parameter-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__field__parameters__parameter")
(pasm:call-rule p #'esaSymbol-PASS2)
)

(defmethod esaSymbol-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "esaSymbol")
(pasm:call-external p #'$name__NewScope)
(pasm:input p :SYMBOL)
(pasm:call-external p #'$name__GetName)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\/))(pasm:input-char p #\/)
(pasm:call-external p #'$name__combine)
(pasm:input p :SYMBOL)
(pasm:call-external p #'$name__combine)
)
((pasm:parser-success? (pasm:lookahead-char? p #\-))(pasm:input-char p #\-)
(pasm:call-external p #'$name__combine)
(pasm:input p :SYMBOL)
(pasm:call-external p #'$name__combine)
)
((pasm:parser-success? (pasm:lookahead-char? p #\?))(pasm:input-char p #\?)
(pasm:call-external p #'$name__combine)
(return)
)
((pasm:parser-success? (pasm:lookahead-char? p #\'))(pasm:input-char p #\')
(pasm:call-external p #'$name__combine)
(return)
)
( t (return)
)
)

)

(pasm:call-external p #'$name__Output)
)

(defmethod tester-PASS2 ((p pasm:parser))
     (setf (pasm:current-rule p) "tester")
(pasm::pasm-filter-stream p #'rmSpaces-PASS2)
(pasm:call-rule p #'esa-expr-PASS2)
(pasm:call-external p #'$bp)
)

