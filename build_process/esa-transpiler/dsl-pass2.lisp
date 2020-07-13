(in-package "ARROWGRAMS/ESA-TRANSPILER")

(defmethod pass2-rmSpaces ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-rmSpaces")
(cond
((pasm:parser-success? (pasm:lookahead? p :SPACE)))
((pasm:parser-success? (pasm:lookahead? p :COMMENT)))
( t  (pasm:accept p) 
)
)

)

(defmethod pass2-esa-dsl ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-esa-dsl")
(pasm::pasm-filter-stream p #'rmSpaces)
(pasm:call-rule p #'pass2-type-decls)
(pasm:call-rule p #'pass2-situations)
(pasm:call-rule p #'pass2-classes)
(pasm:call-rule p #'pass2-parse-whens-and-scripts)
(pasm:input p :EOF)
)

(defmethod pass2-keyword-symbol ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "create"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "end"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "method"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "let"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "set"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "in"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "loop"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "if"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "then"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "else"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "when"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "or"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-map"))(return-from pass2-keyword-symbol pasm:+succeed+)
)
( t (return-from pass2-keyword-symbol pasm:+fail+)
)
)

)
( t (return-from pass2-keyword-symbol pasm:+fail+)
)
)

)

(defmethod pass2-non-keyword-symbol ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:call-predicate p #'pass2-keyword-symbol))(return-from pass2-non-keyword-symbol pasm:+fail+)
)
( t (return-from pass2-non-keyword-symbol pasm:+succeed+)
)
)

)
( t (return-from pass2-non-keyword-symbol pasm:+fail+)
)
)

)

(defmethod pass2-type-decls ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-type-decls")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(pasm:call-rule p #'pass2-type-decl)
)
( t (return)
)
)

)

)

(defmethod pass2-type-decl ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-type-decl")
(pasm:input-symbol p "type")
(pasm:call-rule p #'pass2-esaSymbol)
)

(defmethod pass2-situations ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-situations")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(pasm:call-rule p #'pass2-parse-situation-def)
)
( t (return)
)
)

)

)

(defmethod pass2-parse-situation-def ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-parse-situation-def")
(pasm:input-symbol p "situation")
(pasm:call-rule p #'pass2-esaSymbol)
)

(defmethod pass2-classes ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-classes")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(pasm:call-rule p #'pass2-class-def)
)
( t (return)
)
)

)

)

(defmethod pass2-parse-whens-and-scripts ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-parse-whens-and-scripts")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "when"))(pasm:call-rule p #'pass2-when-declaration)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(pasm:call-rule p #'pass2-script-implementation)
)
( t (return)
)
)

)

)

(defmethod pass2-class-def ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-class-def")
(pasm:input-symbol p "class")
(pasm:call-rule p #'pass2-esaSymbol)
(pasm:call-rule p #'pass2-field-decl)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'pass2-field-decl-begin))(pasm:call-rule p #'pass2-field-decl)
)
( t (return)
)
)

)

(pasm:input-symbol p "end")
(pasm:input-symbol p "class")
)

(defmethod pass2-field-decl-begin ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(return-from pass2-field-decl-begin pasm:+succeed+)
)
((pasm:parser-success? (pasm:call-predicate p #'pass2-non-keyword-symbol))(return-from pass2-field-decl-begin pasm:+succeed+)
)
( t (return-from pass2-field-decl-begin pasm:+fail+)
)
)

)

(defmethod pass2-field-decl ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-field-decl")
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'pass2-esaSymbol)
)
((pasm:parser-success? (pasm:call-predicate p #'pass2-non-keyword-symbol))(pasm:call-rule p #'pass2-esaSymbol)
)
)

)

(defmethod pass2-when-declaration ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-when-declaration")
(pasm:input-symbol p "when")
(pasm:call-rule p #'pass2-situation-ref)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "or"))(pasm:call-rule p #'pass2-or-situation)
)
( t (return)
)
)

)

(pasm:call-rule p #'pass2-class-ref)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(pasm:call-rule p #'pass2-script-declaration)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "method"))(pasm:call-rule p #'pass2-method-declaration)
)
( t (return)
)
)

)

(pasm:input-symbol p "end")
(pasm:input-symbol p "when")
)

(defmethod pass2-situation-ref ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-situation-ref")
(pasm:call-rule p #'pass2-esaSymbol)
)

(defmethod pass2-or-situation ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-or-situation")
(pasm:input-symbol p "or")
(pasm:call-rule p #'pass2-situation-ref)
)

(defmethod pass2-class-ref ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-class-ref")
(pasm:call-rule p #'pass2-esaSymbol)
)

(defmethod pass2-method-declaration ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-method-declaration")
(pasm:input-symbol p "method")
(pasm:call-rule p #'pass2-esaSymbol)
(pasm:call-rule p #'pass2-formals)
(pasm:call-rule p #'pass2-return-type-declaration)
)

(defmethod pass2-script-declaration ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-script-declaration")
(pasm:input-symbol p "script")
(pasm:call-rule p #'pass2-esaSymbol)
(pasm:call-rule p #'pass2-formals)
(pasm:call-rule p #'pass2-return-type-declaration)
)

(defmethod pass2-formals ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-formals")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-external p #'type-list)
(pasm:input-char p #\))
)
( t )
)

)

(defmethod pass2-type-list ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-type-list")
(pasm:call-rule p #'pass2-esaSymbol)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'pass2-non-keyword-symbol))(pasm:call-rule p #'pass2-esaSymbol)
)
( t (return)
)
)

)

)

(defmethod pass2-return-type-declaration ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-return-type-declaration")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'pass2-esaSymbol)
)
( t (pasm:call-rule p #'pass2-esaSymbol)
)
)

)
( t )
)

)

(defmethod pass2-script-implementation ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-script-implementation")
(pasm:input-symbol p "script")
(pasm:call-rule p #'pass2-esaSymbol)
(pasm:call-rule p #'pass2-esaSymbol)
(pasm:call-rule p #'pass2-optional-formals-definition)
(pasm:call-rule p #'pass2-optional-return-type-definition)
(pasm:call-rule p #'pass2-script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "script")
)

(defmethod pass2-optional-formals-definition ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-optional-formals-definition")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-external p #'untyped-formals-definition)
(pasm:input-char p #\))
)
( t (return)
)
)

)

)

(defmethod pass2-untyped-formals-definition ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-untyped-formals-definition")
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'pass2-non-keyword-symbol))(pasm:call-rule p #'pass2-esaSymbol)
)
( t (return)
)
)

)

)

(defmethod pass2-optional-return-type-definition ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-optional-return-type-definition")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'pass2-esaSymbol)
)
( t (pasm:call-rule p #'pass2-esaSymbol)
)
)

)
( t )
)

)

(defmethod pass2-script-body ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-script-body")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "let"))(pasm:call-rule p #'pass2-let-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:call-rule p #'pass2-map-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-map"))(pasm:call-rule p #'pass2-exit-map-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "set"))(pasm:call-rule p #'pass2-set-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "create"))(pasm:call-rule p #'pass2-create-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "if"))(pasm:call-rule p #'pass2-if-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "loop"))(pasm:call-rule p #'pass2-loop-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-when"))(pasm:call-rule p #'pass2-exit-when-statement)
)
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:call-rule p #'pass2-return-statement)
)
((pasm:parser-success? (pasm:lookahead-char? p #\@))(pasm:call-rule p #'pass2-esa-expr)
)
((pasm:parser-success? (pasm:call-predicate p #'pass2-non-keyword-symbol))(pasm:call-rule p #'pass2-esa-expr)
)
( t (return)
)
)

)

)

(defmethod pass2-let-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-let-statement")
(pasm:input-symbol p "let")
(pasm:call-rule p #'pass2-esaSymbol)
(pasm:input-char p #\=)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
)
( t )
)

(pasm:call-rule p #'pass2-esa-expr)
(pasm:input-symbol p "in")
(pasm:call-rule p #'pass2-script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "let")
)

(defmethod pass2-create-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-create-statement")
(pasm:input-symbol p "create")
(pasm:call-rule p #'pass2-esaSymbol)
(pasm:input-char p #\=)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
)
( t )
)

(cond
((pasm:parser-success? (pasm:lookahead-char? p #\*))(pasm:input-char p #\*)
(pasm:call-rule p #'pass2-class-ref)
)
( t (pasm:call-rule p #'pass2-class-ref)
)
)

(pasm:input-symbol p "in")
(pasm:call-rule p #'pass2-script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "create")
)

(defmethod pass2-set-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-set-statement")
(pasm:input-symbol p "set")
(pasm:call-rule p #'pass2-esa-expr)
(pasm:input-char p #\=)
(pasm:call-rule p #'pass2-esa-expr)
)

(defmethod pass2-map-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-map-statement")
(pasm:input-symbol p "map")
(pasm:call-rule p #'pass2-esaSymbol)
(pasm:input-char p #\=)
(pasm:call-rule p #'pass2-esa-expr)
(pasm:input-symbol p "in")
(pasm:call-rule p #'pass2-script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "map")
)

(defmethod pass2-exit-map-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-exit-map-statement")
(pasm:input-symbol p "exit-map")
)

(defmethod pass2-loop-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-loop-statement")
(pasm:input-symbol p "loop")
(pasm:call-rule p #'pass2-script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "loop")
)

(defmethod pass2-exit-when-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-exit-when-statement")
(pasm:input-symbol p "exit-when")
(pasm:call-rule p #'pass2-esa-expr)
)

(defmethod pass2-if-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-if-statement")
(pasm:input-symbol p "if")
(pasm:call-rule p #'pass2-esa-expr)
(pasm:input-symbol p "then")
(pasm:call-rule p #'pass2-script-body)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "else"))(pasm:input-symbol p "else")
(pasm:call-rule p #'pass2-script-body)
)
( t )
)

(pasm:input-symbol p "end")
(pasm:input-symbol p "if")
)

(defmethod pass2-script-call ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-script-call")
(pasm:input-char p #\@)
(pasm:call-rule p #'pass2-esa-expr)
)

(defmethod pass2-method-call ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-method-call")
(pasm:call-rule p #'pass2-esa-expr)
)

(defmethod pass2-return-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-return-statement")
(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(pasm:input-symbol p "true")
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(pasm:input-symbol p "false")
)
( t (pasm:call-rule p #'pass2-esaSymbol)
)
)

)

(defmethod pass2-esa-expr ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-esa-expr")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\@))(pasm:input-char p #\@)
)
( t )
)

(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(pasm:input-symbol p "true")
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(pasm:input-symbol p "false")
)
( t (pasm:call-rule p #'pass2-object__)
)
)

)

(defmethod pass2-object__ ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-object__")
(pasm:call-rule p #'pass2-object__name)
(pasm:call-rule p #'pass2-object__fields)
)

(defmethod pass2-object__name ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-object__name")
(pasm:call-rule p #'pass2-esaSymbol)
)

(defmethod pass2-object__fields ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-object__fields")
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'pass2-object__field_p))(pasm:call-rule p #'pass2-object__single_field)
)
( t (return)
)
)

)

)

(defmethod pass2-object__field_p ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(return-from pass2-object__field_p pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-char? p #\())(return-from pass2-object__field_p pasm:+succeed+)
)
( t (return-from pass2-object__field_p pasm:+fail+)
)
)

)

(defmethod pass2-object__single_field ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-object__single_field")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(pasm:call-rule p #'pass2-object__dotFieldName)
(pasm:call-rule p #'pass2-object__parameterMap)
)
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:call-rule p #'pass2-object__parameterMap)
)
( t )
)

)

(defmethod pass2-object__dotFieldName ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-object__dotFieldName")
(pasm:input-char p #\.)
(pasm:call-rule p #'pass2-esaSymbol)
)

(defmethod pass2-object__parameterMap ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-object__parameterMap")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-rule p #'pass2-esa-expr)
(pasm:call-rule p #'pass2-object__field__recursive-more-parameters)
(pasm:input-char p #\))
)
( t )
)

)

(defmethod pass2-object__field__recursive-more-parameters ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-object__field__recursive-more-parameters")
(cond
((pasm:parser-success? (pasm:call-predicate p #'pass2-object__field__parameters__pred-parameterBegin))(pasm:call-rule p #'pass2-esa-expr)
(pasm:call-rule p #'pass2-object__field__recursive-more-parameters)
)
( t )
)

)

(defmethod pass2-object__field__parameters__pred-parameterBegin ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))(return-from pass2-object__field__parameters__pred-parameterBegin pasm:+succeed+)
)
( t (return-from pass2-object__field__parameters__pred-parameterBegin pasm:+fail+)
)
)

)

(defmethod pass2-object__field__parameters__parameter ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-object__field__parameters__parameter")
(pasm:call-rule p #'pass2-esaSymbol)
)

(defmethod pass2-esaSymbol ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-esaSymbol")
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

(defmethod pass2-tester ((p pasm:parser))
     (setf (pasm:current-rule p) "pass2-tester")
(pasm::pasm-filter-stream p #'pass2-rmSpaces)
(pasm:call-rule p #'pass2-esa-expr)
)

