(in-package "ARROWGRAMS/ESA-TRANSPILER")

(defmethod rmSpaces ((p pasm:parser))
     (setf (pasm:current-rule p) "rmSpaces")
(cond
((pasm:parser-success? (pasm:lookahead? p :SPACE)))
((pasm:parser-success? (pasm:lookahead? p :COMMENT)))
( t  (pasm:accept p) 
)
)

)

(defmethod esa-dsl ((p pasm:parser))
     (setf (pasm:current-rule p) "esa-dsl")
(pasm::pasm-filter-stream p #'rmSpaces)
(pasm:call-external p #'emitHeader)
(pasm:call-rule p #'type-decls)
(pasm:call-rule p #'situations)
(pasm:call-rule p #'classes)
(pasm:call-rule p #'whens-and-scripts)
(pasm:input p :EOF)
)

(defmethod keyword-symbol ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "create"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "end"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "method"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "let"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "set"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "in"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "loop"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "if"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "then"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "else"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "when"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "or"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-map"))(return-from keyword-symbol pasm:+succeed+)
)
( t (return-from keyword-symbol pasm:+fail+)
)
)

)
( t (return-from keyword-symbol pasm:+fail+)
)
)

)

(defmethod non-keyword-symbol ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:call-predicate p #'keyword-symbol))(return-from non-keyword-symbol pasm:+fail+)
)
( t (return-from non-keyword-symbol pasm:+succeed+)
)
)

)
( t (return-from non-keyword-symbol pasm:+fail+)
)
)

)

(defmethod type-decls ((p pasm:parser))
     (setf (pasm:current-rule p) "type-decls")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(pasm:call-rule p #'type-decl)
)
( t (return)
)
)

)

)

(defmethod type-decl ((p pasm:parser))
     (setf (pasm:current-rule p) "type-decl")
(pasm:input-symbol p "type")
(pasm:call-rule p #'esa-symbol)
)

(defmethod situations ((p pasm:parser))
     (setf (pasm:current-rule p) "situations")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(pasm:call-rule p #'situation)
)
( t (return)
)
)

)

)

(defmethod situation ((p pasm:parser))
     (setf (pasm:current-rule p) "situation")
(pasm:input-symbol p "situation")
(pasm:input p :SYMBOL)
)

(defmethod classes ((p pasm:parser))
     (setf (pasm:current-rule p) "classes")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(pasm:call-rule p #'class-def)
)
( t (return)
)
)

)

)

(defmethod whens-and-scripts ((p pasm:parser))
     (setf (pasm:current-rule p) "whens-and-scripts")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(pasm:call-rule p #'script-definition)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "when"))(pasm:call-rule p #'when-declaration)
)
( t (return)
)
)

)

)

(defmethod class-def ((p pasm:parser))
     (setf (pasm:current-rule p) "class-def")
(pasm:input-symbol p "class")
(pasm:call-rule p #'esa-symbol)
(pasm:call-rule p #'field-decl-begin)
(pasm:call-rule p #'field-decl)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'field-decl-begin))(pasm:call-rule p #'field-decl)
)
( t (return)
)
)

)

(pasm:input-symbol p "end")
(pasm:input-symbol p "class")
)

(defmethod field-decl-begin ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(return-from field-decl-begin pasm:+succeed+)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(return-from field-decl-begin pasm:+succeed+)
)
( t (return-from field-decl-begin pasm:+fail+)
)
)

)

(defmethod field-decl ((p pasm:parser))
     (setf (pasm:current-rule p) "field-decl")
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esa-symbol)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(pasm:call-rule p #'esa-symbol)
)
)

)

(defmethod when-declaration ((p pasm:parser))
     (setf (pasm:current-rule p) "when-declaration")
(pasm:input-symbol p "when")
(pasm:call-rule p #'situation-ref)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "or"))(pasm:call-rule p #'or-situation)
)
( t (return)
)
)

)

(pasm:call-rule p #'class-ref)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(pasm:call-rule p #'script-declaration)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "method"))(pasm:call-rule p #'method-declaration)
)
( t (return)
)
)

)

(pasm:input-symbol p "end")
(pasm:input-symbol p "when")
)

(defmethod situation-ref ((p pasm:parser))
     (setf (pasm:current-rule p) "situation-ref")
(pasm:call-rule p #'esa-symbol)
)

(defmethod or-situation ((p pasm:parser))
     (setf (pasm:current-rule p) "or-situation")
(pasm:input-symbol p "or")
(pasm:call-rule p #'situation-ref)
)

(defmethod class-ref ((p pasm:parser))
     (setf (pasm:current-rule p) "class-ref")
(pasm:call-rule p #'esa-symbol)
)

(defmethod method-declaration ((p pasm:parser))
     (setf (pasm:current-rule p) "method-declaration")
(pasm:input-symbol p "method")
(pasm:call-rule p #'esa-symbol)
(pasm:call-rule p #'generic-typed-formals)
(pasm:call-rule p #'optional-return-type-declaration)
)

(defmethod script-declaration ((p pasm:parser))
     (setf (pasm:current-rule p) "script-declaration")
(pasm:input-symbol p "script")
(pasm:call-rule p #'esa-symbol)
(pasm:call-rule p #'generic-typed-formals)
(pasm:call-rule p #'optional-return-type-declaration)
)

(defmethod generic-typed-formals ((p pasm:parser))
     (setf (pasm:current-rule p) "generic-typed-formals")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-external p #'generic-type-list)
(pasm:input-char p #\))
)
( t )
)

)

(defmethod generic-type-list ((p pasm:parser))
     (setf (pasm:current-rule p) "generic-type-list")
(pasm:call-rule p #'esa-symbol)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(pasm:call-rule p #'esa-symbol)
)
( t (return)
)
)

)

)

(defmethod optional-return-type-declaration ((p pasm:parser))
     (setf (pasm:current-rule p) "optional-return-type-declaration")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esa-symbol)
)
( t (pasm:call-rule p #'esa-symbol)
)
)

)
( t )
)

)

(defmethod script-definition ((p pasm:parser))
     (setf (pasm:current-rule p) "script-definition")
(pasm:input-symbol p "script")
(pasm:call-rule p #'esa-symbol)
(pasm:call-external p #'set-current-class)
(pasm:call-rule p #'esa-symbol)
(pasm:call-external p #'set-current-method)
(pasm:call-rule p #'optional-formals-definition)
(pasm:call-rule p #'optional-return-type-definition)
(pasm:call-rule p #'script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "script")
)

(defmethod optional-formals-definition ((p pasm:parser))
     (setf (pasm:current-rule p) "optional-formals-definition")
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

(defmethod untyped-formals-definition ((p pasm:parser))
     (setf (pasm:current-rule p) "untyped-formals-definition")
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(pasm:call-rule p #'esa-symbol)
)
( t (return)
)
)

)

)

(defmethod optional-return-type-definition ((p pasm:parser))
     (setf (pasm:current-rule p) "optional-return-type-definition")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esa-symbol)
)
( t (pasm:call-rule p #'esa-symbol)
)
)

)
( t )
)

)

(defmethod script-body ((p pasm:parser))
     (setf (pasm:current-rule p) "script-body")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "let"))(pasm:call-rule p #'let-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:call-rule p #'map-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-map"))(pasm:call-rule p #'exit-map-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "set"))(pasm:call-rule p #'set-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "create"))(pasm:call-rule p #'create-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "if"))(pasm:call-rule p #'if-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "loop"))(pasm:call-rule p #'loop-statement)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-when"))(pasm:call-rule p #'exit-when-statement)
)
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:call-rule p #'return-statement)
)
((pasm:parser-success? (pasm:lookahead-char? p #\@))(pasm:call-rule p #'esa-expr)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(pasm:call-rule p #'esa-expr)
)
( t (return)
)
)

)

)

(defmethod let-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "let-statement")
(pasm:input-symbol p "let")
(pasm:call-rule p #'esa-symbol)
(pasm:input-char p #\=)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
)
( t )
)

(pasm:call-rule p #'esa-expr)
(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "let")
)

(defmethod create-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "create-statement")
(pasm:input-symbol p "create")
(pasm:call-rule p #'esa-symbol)
(pasm:input-char p #\=)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
)
( t )
)

(cond
((pasm:parser-success? (pasm:lookahead-char? p #\*))(pasm:input-char p #\*)
(pasm:call-rule p #'class-ref)
)
( t (pasm:call-rule p #'class-ref)
)
)

(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "create")
)

(defmethod set-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "set-statement")
(pasm:input-symbol p "set")
(pasm:call-rule p #'esa-expr)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr)
)

(defmethod map-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "map-statement")
(pasm:input-symbol p "map")
(pasm:call-rule p #'esa-symbol)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr)
(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "map")
)

(defmethod exit-map-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "exit-map-statement")
(pasm:input-symbol p "exit-map")
)

(defmethod loop-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "loop-statement")
(pasm:input-symbol p "loop")
(pasm:call-rule p #'script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "loop")
)

(defmethod exit-when-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "exit-when-statement")
(pasm:input-symbol p "exit-when")
(pasm:call-rule p #'esa-expr)
)

(defmethod if-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "if-statement")
(pasm:input-symbol p "if")
(pasm:call-rule p #'esa-expr)
(pasm:input-symbol p "then")
(pasm:call-rule p #'script-body)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "else"))(pasm:input-symbol p "else")
(pasm:call-rule p #'script-body)
)
( t )
)

(pasm:input-symbol p "end")
(pasm:input-symbol p "if")
)

(defmethod script-call ((p pasm:parser))
     (setf (pasm:current-rule p) "script-call")
(pasm:input-char p #\@)
(pasm:call-rule p #'esa-expr)
)

(defmethod method-call ((p pasm:parser))
     (setf (pasm:current-rule p) "method-call")
(pasm:call-rule p #'esa-expr)
)

(defmethod return-statement ((p pasm:parser))
     (setf (pasm:current-rule p) "return-statement")
(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(pasm:input-symbol p "true")
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(pasm:input-symbol p "false")
)
( t (pasm:call-rule p #'esa-symbol)
)
)

)

(defmethod esa-symbol ((p pasm:parser))
     (setf (pasm:current-rule p) "esa-symbol")
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(pasm:input p :SYMBOL)
(pasm:call-rule p #'esa-field-follow-nonemitting)
)
( t )
)

)

(defmethod esa-field-follow-nonemitting ((p pasm:parser))
     (setf (pasm:current-rule p) "esa-field-follow-nonemitting")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\/))(pasm:input-char p #\/)
(pasm:input p :SYMBOL)
)
((pasm:parser-success? (pasm:lookahead-char? p #\-))(pasm:input-char p #\-)
(pasm:input p :SYMBOL)
)
((pasm:parser-success? (pasm:lookahead-char? p #\?))(pasm:input-char p #\?)
(return)
)
((pasm:parser-success? (pasm:lookahead-char? p #\'))(pasm:input-char p #\')
(return)
)
( t (return)
)
)

)

)

(defmethod esa-expr ((p pasm:parser))
     (setf (pasm:current-rule p) "esa-expr")
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
( t (pasm:call-rule p #'object__)
)
)

)

(defmethod object__ ((p pasm:parser))
     (setf (pasm:current-rule p) "object__")
(pasm:call-external p #'$object__NewScope)
(pasm:call-rule p #'object__name)
(pasm:call-external p #'$object_SetField_name_from_name)
(pasm:call-external p #'$fieldMap__NewScope)
(pasm:call-rule p #'object__tailList)
(pasm:call-external p #'$object_SetField_fieldMap_from_fieldMap)
(pasm:call-external p #'$object__Output)
)

(defmethod object__tailList ((p pasm:parser))
     (setf (pasm:current-rule p) "object__tailList")
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'object__field_p))(pasm:call-rule p #'object__single_field)
)
( t (return)
)
)

)

)

(defmethod object__field_p ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(return-from object__field_p pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-char? p #\())(return-from object__field_p pasm:+succeed+)
)
( t (return-from object__field_p pasm:+fail+)
)
)

)

(defmethod object__single_field ((p pasm:parser))
     (setf (pasm:current-rule p) "object__single_field")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(pasm:call-rule p #'object__dotField)
(pasm:call-rule p #'object__optionalParameterMap)
)
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:call-rule p #'object__optionalParameterMap)
)
( t )
)

)

(defmethod object__name ((p pasm:parser))
     (setf (pasm:current-rule p) "object__name")
(pasm:call-rule p #'esaSymbol)
)

(defmethod object__dotField ((p pasm:parser))
     (setf (pasm:current-rule p) "object__dotField")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(pasm:input-char p #\.)
(pasm:call-rule p #'object__)
)
( t )
)

)

(defmethod object__optionalParameterMap ((p pasm:parser))
     (setf (pasm:current-rule p) "object__optionalParameterMap")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-external p #'object__field__rec-parameters)
(pasm:input-char p #\))
)
( t )
)

)

(defmethod object__field__rec-parameters ((p pasm:parser))
     (setf (pasm:current-rule p) "object__field__rec-parameters")
(pasm:call-rule p #'object__field__parameters__parameter)
(cond
((pasm:parser-success? (pasm:call-predicate p #'object__field__rec-parameters__pred-parameterBegin))(pasm:call-rule p #'object__field__rec-parameters)
)
( t )
)

)

(defmethod object__field__rec-parameters__pred-parameterBegin ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))(return-from object__field__rec-parameters__pred-parameterBegin pasm:+succeed+)
)
( t (return-from object__field__rec-parameters__pred-parameterBegin pasm:+fail+)
)
)

)

(defmethod object__field__parameters__parameter ((p pasm:parser))
     (setf (pasm:current-rule p) "object__field__parameters__parameter")
(pasm:call-rule p #'esaSymbol)
)

(defmethod esaSymbol ((p pasm:parser))
     (setf (pasm:current-rule p) "esaSymbol")
(pasm:input p :SYMBOL)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\/))(pasm:input-char p #\/)
(pasm:input p :SYMBOL)
)
((pasm:parser-success? (pasm:lookahead-char? p #\-))(pasm:input-char p #\-)
(pasm:input p :SYMBOL)
)
((pasm:parser-success? (pasm:lookahead-char? p #\?))(pasm:input-char p #\?)
(return)
)
((pasm:parser-success? (pasm:lookahead-char? p #\'))(pasm:input-char p #\')
(return)
)
( t (return)
)
)

)

)

(defmethod tester ((p pasm:parser))
     (setf (pasm:current-rule p) "tester")
(pasm::pasm-filter-stream p #'rmSpaces)
(pasm:call-external p #'$mech-tester)
)

