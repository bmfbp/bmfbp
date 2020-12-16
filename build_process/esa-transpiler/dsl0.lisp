(in-package "ARROWGRAMS/ESA-TRANSPILER")
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))


(defmethod rmSpaces-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "rmSpaces")
(cond
((pasm:parser-success? (pasm:lookahead? p :SPACE)))
((pasm:parser-success? (pasm:lookahead? p :COMMENT)))
( t  (pasm:accept p) 
)
)

)

(defmethod esa-dsl-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "esa-dsl")
(pasm::pasm-filter-stream p #'rmSpaces-PASS0)
(pasm:call-rule p #'type-decls-PASS0)
(pasm:call-rule p #'situations-PASS0)
(pasm:call-rule p #'classes-PASS0)
(pasm:call-rule p #'parse-whens-and-scripts-PASS0)
(pasm:input p :EOF)
)

(defmethod keyword-symbol-PASS0 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "create"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "end"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "method"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "let"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "set"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "in"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "loop"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "if"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "then"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "else"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "when"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "or"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-map"))(return-from keyword-symbol-PASS0 pasm:+succeed+)
)
( t (return-from keyword-symbol-PASS0 pasm:+fail+)
)
)

)
( t (return-from keyword-symbol-PASS0 pasm:+fail+)
)
)

)

(defmethod non-keyword-symbol-PASS0 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:call-predicate p #'keyword-symbol-PASS0))(return-from non-keyword-symbol-PASS0 pasm:+fail+)
)
( t (return-from non-keyword-symbol-PASS0 pasm:+succeed+)
)
)

)
( t (return-from non-keyword-symbol-PASS0 pasm:+fail+)
)
)

)

(defmethod type-decls-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "type-decls")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(pasm:call-rule p #'type-decl-PASS0)
)
( t (return)
)
)

)

)

(defmethod type-decl-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "type-decl")
(pasm:input-symbol p "type")
(pasm:call-rule p #'esaSymbol-PASS0)
)

(defmethod situations-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "situations")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(pasm:call-rule p #'parse-situation-def-PASS0)
)
( t (return)
)
)

)

)

(defmethod parse-situation-def-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "parse-situation-def")
(pasm:input-symbol p "situation")
(pasm:call-rule p #'esaSymbol-PASS0)
)

(defmethod classes-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "classes")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(pasm:call-rule p #'class-def-PASS0)
)
( t (return)
)
)

)

)

(defmethod parse-whens-and-scripts-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "parse-whens-and-scripts")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "when"))(pasm:call-rule p #'when-declaration-PASS0)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(pasm:call-rule p #'script-implementation-PASS0)
)
( t (return)
)
)

)

)

(defmethod class-def-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "class-def")
(pasm:input-symbol p "class")
(pasm:call-rule p #'esaSymbol-PASS0)
(pasm:call-rule p #'field-decl-PASS0)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'field-decl-begin-PASS0))(pasm:call-rule p #'field-decl-PASS0)
)
( t (return)
)
)

)

(pasm:input-symbol p "end")
(pasm:input-symbol p "class")
)

(defmethod field-decl-begin-PASS0 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(return-from field-decl-begin-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS0))(return-from field-decl-begin-PASS0 pasm:+succeed+)
)
( t (return-from field-decl-begin-PASS0 pasm:+fail+)
)
)

)

(defmethod field-decl-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "field-decl")
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esaSymbol-PASS0)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS0))(pasm:call-rule p #'esaSymbol-PASS0)
)
)

)

(defmethod when-declaration-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "when-declaration")
(pasm:input-symbol p "when")
(pasm:call-rule p #'situation-ref-PASS0)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "or"))(pasm:call-rule p #'or-situation-PASS0)
)
( t (return)
)
)

)

(pasm:call-rule p #'class-ref-PASS0)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(pasm:call-rule p #'script-declaration-PASS0)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "method"))(pasm:call-rule p #'method-declaration-PASS0)
)
( t (return)
)
)

)

(pasm:input-symbol p "end")
(pasm:input-symbol p "when")
)

(defmethod situation-ref-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "situation-ref")
(pasm:call-rule p #'esaSymbol-PASS0)
)

(defmethod or-situation-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "or-situation")
(pasm:input-symbol p "or")
(pasm:call-rule p #'situation-ref-PASS0)
)

(defmethod class-ref-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "class-ref")
(pasm:call-rule p #'esaSymbol-PASS0)
)

(defmethod method-declaration-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "method-declaration")
(pasm:input-symbol p "method")
(pasm:call-rule p #'esaSymbol-PASS0)
(pasm:call-rule p #'formals-PASS0)
(pasm:call-rule p #'return-type-declaration-PASS0)
)

(defmethod script-declaration-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "script-declaration")
(pasm:input-symbol p "script")
(pasm:call-rule p #'esaSymbol-PASS0)
(pasm:call-rule p #'formals-PASS0)
(pasm:call-rule p #'return-type-declaration-PASS0)
)

(defmethod formals-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "formals")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-rule p #'type-list-PASS0)
(pasm:input-char p #\))
)
( t )
)

)

(defmethod type-list-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "type-list")
(pasm:call-rule p #'esaSymbol-PASS0)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS0))(pasm:call-rule p #'esaSymbol-PASS0)
)
( t (return)
)
)

)

)

(defmethod return-type-declaration-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "return-type-declaration")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esaSymbol-PASS0)
)
( t (pasm:call-rule p #'esaSymbol-PASS0)
)
)

)
( t )
)

)

(defmethod script-implementation-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "script-implementation")
(pasm:input-symbol p "script")
(pasm:call-rule p #'esaSymbol-PASS0)
(pasm:call-rule p #'esaSymbol-PASS0)
(pasm:call-rule p #'optional-formals-definition-PASS0)
(pasm:call-rule p #'optional-return-type-definition-PASS0)
(pasm:call-rule p #'script-body-PASS0)
(pasm:input-symbol p "end")
(pasm:input-symbol p "script")
)

(defmethod optional-formals-definition-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "optional-formals-definition")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-rule p #'untyped-formals-definition-PASS0)
(pasm:input-char p #\))
)
( t (return)
)
)

)

)

(defmethod untyped-formals-definition-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "untyped-formals-definition")
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS0))(pasm:call-rule p #'esaSymbol-PASS0)
)
( t (return)
)
)

)

)

(defmethod optional-return-type-definition-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "optional-return-type-definition")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esaSymbol-PASS0)
)
( t (pasm:call-rule p #'esaSymbol-PASS0)
)
)

)
( t )
)

)

(defmethod script-body-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "script-body")
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "let"))(pasm:call-rule p #'let-statement-PASS0)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:call-rule p #'map-statement-PASS0)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-map"))(pasm:call-rule p #'exit-map-statement-PASS0)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "set"))(pasm:call-rule p #'set-statement-PASS0)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "create"))(pasm:call-rule p #'create-statement-PASS0)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "if"))(pasm:call-rule p #'if-statement-PASS0)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "loop"))(pasm:call-rule p #'loop-statement-PASS0)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-when"))(pasm:call-rule p #'exit-when-statement-PASS0)
)
((pasm:parser-success? (pasm:lookahead-char? p #\>))(pasm:call-rule p #'return-statement-PASS0)
)
((pasm:parser-success? (pasm:lookahead-char? p #\@))(pasm:call-rule p #'esa-expr-PASS0)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol-PASS0))(pasm:call-rule p #'esa-expr-PASS0)
)
( t (return)
)
)

)

)

(defmethod let-statement-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "let-statement")
(pasm:input-symbol p "let")
(pasm:call-rule p #'esaSymbol-PASS0)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr-PASS0)
(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body-PASS0)
(pasm:input-symbol p "end")
(pasm:input-symbol p "let")
)

(defmethod create-statement-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "create-statement")
(pasm:input-symbol p "create")
(pasm:call-rule p #'esaSymbol-PASS0)
(pasm:input-char p #\=)
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\*))(pasm:input-char p #\*)
(pasm:call-rule p #'class-ref-PASS0)
)
( t (pasm:call-rule p #'class-ref-PASS0)
)
)

(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body-PASS0)
(pasm:input-symbol p "end")
(pasm:input-symbol p "create")
)

(defmethod set-statement-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "set-statement")
(pasm:input-symbol p "set")
(pasm:call-rule p #'esa-expr-PASS0)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr-PASS0)
)

(defmethod map-statement-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "map-statement")
(pasm:input-symbol p "map")
(pasm:call-rule p #'esaSymbol-PASS0)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr-PASS0)
(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body-PASS0)
(pasm:input-symbol p "end")
(pasm:input-symbol p "map")
)

(defmethod exit-map-statement-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "exit-map-statement")
(pasm:input-symbol p "exit-map")
)

(defmethod loop-statement-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "loop-statement")
(pasm:input-symbol p "loop")
(pasm:call-rule p #'script-body-PASS0)
(pasm:input-symbol p "end")
(pasm:input-symbol p "loop")
)

(defmethod exit-when-statement-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "exit-when-statement")
(pasm:input-symbol p "exit-when")
(pasm:call-rule p #'esa-expr-PASS0)
)

(defmethod if-statement-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "if-statement")
(pasm:input-symbol p "if")
(pasm:call-rule p #'esa-expr-PASS0)
(pasm:input-symbol p "then")
(pasm:call-rule p #'script-body-PASS0)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "else"))(pasm:input-symbol p "else")
(pasm:call-rule p #'script-body-PASS0)
)
( t )
)

(pasm:input-symbol p "end")
(pasm:input-symbol p "if")
)

(defmethod script-call-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "script-call")
(pasm:input-char p #\@)
(pasm:call-rule p #'esa-expr-PASS0)
)

(defmethod method-call-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "method-call")
(pasm:call-rule p #'esa-expr-PASS0)
)

(defmethod return-statement-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "return-statement")
(pasm:input-char p #\>)
(pasm:input-char p #\>)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(pasm:input-symbol p "true")
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(pasm:input-symbol p "false")
)
( t (pasm:call-rule p #'esaSymbol-PASS0)
)
)

)

(defmethod esa-expr-PASS0 ((p pasm:parser))
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
( t (pasm:call-rule p #'object__-PASS0)
)
)

)

(defmethod object__-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__")
(pasm:call-rule p #'object__name-PASS0)
(pasm:call-rule p #'object__fields-PASS0)
)

(defmethod object__name-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__name")
(pasm:call-rule p #'esaSymbol-PASS0)
)

(defmethod object__fields-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__fields")
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'object__field_p-PASS0))(pasm:call-rule p #'object__single_field-PASS0)
)
( t (return)
)
)

)

)

(defmethod object__field_p-PASS0 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(return-from object__field_p-PASS0 pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-char? p #\())(return-from object__field_p-PASS0 pasm:+succeed+)
)
( t (return-from object__field_p-PASS0 pasm:+fail+)
)
)

)

(defmethod object__single_field-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__single_field")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(pasm:call-rule p #'object__dotFieldName-PASS0)
(pasm:call-rule p #'object__parameterMap-PASS0)
)
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:call-rule p #'object__parameterMap-PASS0)
)
( t )
)

)

(defmethod object__dotFieldName-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__dotFieldName")
(pasm:input-char p #\.)
(pasm:call-rule p #'esaSymbol-PASS0)
)

(defmethod object__parameterMap-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__parameterMap")
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-rule p #'esa-expr-PASS0)
(pasm:call-rule p #'object__field__recursive-more-parameters-PASS0)
(pasm:input-char p #\))
)
( t )
)

)

(defmethod object__field__recursive-more-parameters-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__field__recursive-more-parameters")
(cond
((pasm:parser-success? (pasm:call-predicate p #'object__field__parameters__pred-parameterBegin-PASS0))(pasm:call-rule p #'esa-expr-PASS0)
(pasm:call-rule p #'object__field__recursive-more-parameters-PASS0)
)
( t )
)

)

(defmethod object__field__parameters__pred-parameterBegin-PASS0 ((p pasm:parser)) ;; predicate
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))(return-from object__field__parameters__pred-parameterBegin-PASS0 pasm:+succeed+)
)
( t (return-from object__field__parameters__pred-parameterBegin-PASS0 pasm:+fail+)
)
)

)

(defmethod object__field__parameters__parameter-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "object__field__parameters__parameter")
(pasm:call-rule p #'esaSymbol-PASS0)
)

(defmethod esaSymbol-PASS0 ((p pasm:parser))
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

(defmethod tester-PASS0 ((p pasm:parser))
     (setf (pasm:current-rule p) "tester")
(pasm::pasm-filter-stream p #'rmSpaces-PASS0)
(pasm:call-rule p #'esa-expr-PASS0)
)

