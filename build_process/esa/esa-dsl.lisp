(in-package :arrowgrams/esa)

(defmethod esa-dsl ((p parser))
(call-rule p #'type-decls)
(call-rule p #'situations)
(call-rule p #'classes)
(call-rule p #'whens-and-scripts)
(input p :EOF)
) ; rule

(defmethod keyword-symbol ((p parser)) ;; predicate
(cond
((parser-success-p (look? p :SYMBOL))(cond
((parser-success-p (look-symbol? p "type"))(return-from keyword-symbol :ok));choice clause
((parser-success-p (look-symbol? p "class"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "create"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "end"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "method"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "script"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "let"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "set"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "map"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "in"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "loop"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "if"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "then"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "else"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "when"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "situation"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "or"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "true"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "false"))
(return-from keyword-symbol :ok)
);choice alt
((parser-success-p (look-symbol? p "exit-map"))
(return-from keyword-symbol :ok)
);choice alt
( t 
(return-from keyword-symbol :fail)
);choice alt
);choice
);choice clause
( t 
(return-from keyword-symbol :fail)
);choice alt
);choice

) ; pred

(defmethod non-keyword-symbol ((p parser)) ;; predicate
(cond
((parser-success-p (look? p :SYMBOL))(cond
((parser-success-p (call-predicate p #'keyword-symbol))(return-from non-keyword-symbol :fail));choice clause
( t 
(return-from non-keyword-symbol :ok)
);choice alt
);choice
);choice clause
( t 
(return-from non-keyword-symbol :fail)
);choice alt
);choice

) ; pred

(defmethod type-decls ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "type"))(call-rule p #'type-decl));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod type-decl ((p parser))
(input-symbol p "type")
(call-rule p #'esa-symbol)
) ; rule

(defmethod situations ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "situation"))(call-rule p #'situation));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod situation ((p parser))
(input-symbol p "situation")
(input p :SYMBOL)
) ; rule

(defmethod classes ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "class"))(call-rule p #'class-def));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod whens-and-scripts ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "script"))(call-rule p #'script-definition));choice clause
((parser-success-p (look-symbol? p "when"))
(call-rule p #'when-declaration)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod class-def ((p parser))
(input-symbol p "class")
(call-rule p #'esa-symbol)
(call-rule p #'field-decl-begin)
(call-rule p #'field-decl)
(loop
(cond
((parser-success-p (call-predicate p #'field-decl-begin))(call-rule p #'field-decl));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

(input-symbol p "end")
(input-symbol p "class")
) ; rule

(defmethod field-decl-begin ((p parser)) ;; predicate
(cond
((parser-success-p (look-symbol? p "map"))(return-from field-decl-begin :ok));choice clause
((parser-success-p (call-predicate p #'non-keyword-symbol))
(return-from field-decl-begin :ok)
);choice alt
( t 
(return-from field-decl-begin :fail)
);choice alt
);choice

) ; pred

(defmethod field-decl ((p parser))
(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map")(call-rule p #'esa-symbol));choice clause
((parser-success-p (call-predicate p #'non-keyword-symbol))
(call-rule p #'esa-symbol)
);choice alt
);choice

) ; rule

(defmethod when-declaration ((p parser))
(input-symbol p "when")
(call-rule p #'situation-ref)
(loop
(cond
((parser-success-p (look-symbol? p "or"))(call-rule p #'or-situation));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

(call-rule p #'class-ref)
(loop
(cond
((parser-success-p (look-symbol? p "script"))(call-rule p #'script-declaration));choice clause
((parser-success-p (look-symbol? p "method"))
(call-rule p #'method-declaration)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

(input-symbol p "end")
(input-symbol p "when")
) ; rule

(defmethod situation-ref ((p parser))
(call-rule p #'esa-symbol)
) ; rule

(defmethod or-situation ((p parser))
(input-symbol p "or")
(call-rule p #'situation-ref)
) ; rule

(defmethod class-ref ((p parser))
(call-rule p #'esa-symbol)
) ; rule

(defmethod method-declaration ((p parser))
(input-symbol p "method")
(call-rule p #'esa-symbol)
(call-rule p #'generic-typed-formals)
(call-rule p #'optional-return-type-declaration)
) ; rule

(defmethod script-declaration ((p parser))
(input-symbol p "script")
(call-rule p #'esa-symbol)
(call-rule p #'generic-typed-formals)
(call-rule p #'optional-return-type-declaration)
) ; rule

(defmethod generic-typed-formals ((p parser))
(cond
((parser-success-p (look-char? p #\())(input-char p #\()(call-external p #'generic-type-list)(input-char p #\)));choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod generic-type-list ((p parser))
(call-rule p #'esa-symbol)
(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod optional-return-type-declaration ((p parser))
(cond
((parser-success-p (look-char? p #\>))(input-char p #\>)(input-char p #\>)(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map")(call-rule p #'esa-symbol));choice clause
( t 
(call-rule p #'esa-symbol)
);choice alt
);choice
);choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod script-definition ((p parser))
(input-symbol p "script")
(call-rule p #'esa-symbol)
(call-rule p #'esa-symbol)
(call-rule p #'optional-formals-definition)
(call-rule p #'optional-return-type-definition)
(call-rule p #'script-body)
(input-symbol p "end")
(input-symbol p "script")
) ; rule

(defmethod optional-formals-definition ((p parser))
(loop
(cond
((parser-success-p (look-char? p #\())(input-char p #\()(call-external p #'untyped-formals-definition)(input-char p #\)));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod untyped-formals-definition ((p parser))
(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod optional-return-type-definition ((p parser))
(cond
((parser-success-p (look-char? p #\>))(input-char p #\>)(input-char p #\>)(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map")(call-rule p #'esa-symbol));choice clause
( t 
(call-rule p #'esa-symbol)
);choice alt
);choice
);choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod script-body ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "let"))(call-rule p #'let-statement));choice clause
((parser-success-p (look-symbol? p "map"))
(call-rule p #'map-statement)
);choice alt
((parser-success-p (look-symbol? p "exit-map"))
(call-rule p #'exit-map-statement)
);choice alt
((parser-success-p (look-symbol? p "set"))
(call-rule p #'set-statement)
);choice alt
((parser-success-p (look-symbol? p "create"))
(call-rule p #'create-statement)
);choice alt
((parser-success-p (look-symbol? p "if"))
(call-rule p #'if-statement)
);choice alt
((parser-success-p (look-symbol? p "loop"))
(call-rule p #'loop-statement)
);choice alt
((parser-success-p (look-symbol? p "exit-when"))
(call-rule p #'exit-when-statement)
);choice alt
((parser-success-p (look-char? p #\>))
(call-rule p #'return-statement)
);choice alt
((parser-success-p (look-char? p #\@))
(call-rule p #'esa-expr)
);choice alt
((parser-success-p (call-predicate p #'non-keyword-symbol))
(call-rule p #'esa-expr)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod let-statement ((p parser))
(input-symbol p "let")
(call-rule p #'esa-symbol)
(input-char p #\=)
(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map"));choice clause
( t 
);choice alt
);choice

(call-rule p #'esa-expr)
(input-symbol p "in")
(call-rule p #'script-body)
(input-symbol p "end")
(input-symbol p "let")
) ; rule

(defmethod create-statement ((p parser))
(input-symbol p "create")
(call-rule p #'esa-symbol)
(input-char p #\=)
(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map"));choice clause
( t 
);choice alt
);choice

(cond
((parser-success-p (look-char? p #\*))(input-char p #\*)(call-rule p #'class-ref));choice clause
( t 
(call-rule p #'class-ref)
);choice alt
);choice

(input-symbol p "in")
(call-rule p #'script-body)
(input-symbol p "end")
(input-symbol p "create")
) ; rule

(defmethod set-statement ((p parser))
(input-symbol p "set")
(call-rule p #'esa-expr)
(input-char p #\=)
(call-rule p #'esa-expr)
) ; rule

(defmethod map-statement ((p parser))
(input-symbol p "map")
(call-rule p #'esa-symbol)
(input-char p #\=)
(call-rule p #'esa-expr)
(input-symbol p "in")
(call-rule p #'script-body)
(input-symbol p "end")
(input-symbol p "map")
) ; rule

(defmethod exit-map-statement ((p parser))
(input-symbol p "exit-map")
) ; rule

(defmethod loop-statement ((p parser))
(input-symbol p "loop")
(call-rule p #'script-body)
(input-symbol p "end")
(input-symbol p "loop")
) ; rule

(defmethod exit-when-statement ((p parser))
(input-symbol p "exit-when")
(call-rule p #'esa-expr)
) ; rule

(defmethod if-statement ((p parser))
(input-symbol p "if")
(call-rule p #'esa-expr)
(input-symbol p "then")
(call-rule p #'script-body)
(cond
((parser-success-p (look-symbol? p "else"))(input-symbol p "else")(call-rule p #'script-body));choice clause
( t 
);choice alt
);choice

(input-symbol p "end")
(input-symbol p "if")
) ; rule

(defmethod script-call ((p parser))
(input-char p #\@)
(call-rule p #'esa-expr)
) ; rule

(defmethod method-call ((p parser))
(call-rule p #'esa-expr)
) ; rule

(defmethod return-statement ((p parser))
(input-char p #\>)
(input-char p #\>)
(cond
((parser-success-p (look-symbol? p "true"))(input-symbol p "true"));choice clause
((parser-success-p (look-symbol? p "false"))
(input-symbol p "false")
);choice alt
( t 
(call-rule p #'esa-symbol)
);choice alt
);choice

) ; rule

(defmethod field-call ((p parser))
(call-rule p #'esa-symbol)
(cond
((parser-success-p (look-char? p #\.))(call-rule p #'dotted-field-call));choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod esa-symbol ((p parser))
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(input p :SYMBOL)(call-rule p #'esa-symbol-follow));choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod esa-symbol-follow ((p parser))
(loop
(cond
((parser-success-p (look-char? p #\/))(input-char p #\/)(input p :SYMBOL));choice clause
((parser-success-p (look-char? p #\-))
(input-char p #\-)
(input p :SYMBOL)
);choice alt
((parser-success-p (look-char? p #\?))
(input-char p #\?)
(return)
);choice alt
((parser-success-p (look-char? p #\'))
(input-char p #\')
(return)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod esa-expr ((p parser))
(cond
((parser-success-p (look-char? p #\@))(input-char p #\@));choice clause
( t 
);choice alt
);choice

(cond
((parser-success-p (look-symbol? p "true"))(input-symbol p "true"));choice clause
((parser-success-p (look-symbol? p "false"))
(input-symbol p "false")
);choice alt
( t 
(call-rule p #'esa-field)
(loop
(cond
((parser-success-p (look-char? p #\.))(input-char p #\.)(call-rule p #'esa-field)(call-rule p #'optional-actuals));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

);choice alt
);choice

) ; rule

(defmethod optional-actuals ((p parser))
(cond
((parser-success-p (look-char? p #\())(input-char p #\()(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-expr));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop
(input-char p #\)));choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod esa-field ((p parser))
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(input p :SYMBOL)(call-rule p #'esa-symbol-follow));choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod esa-field-follow ((p parser))
(loop
(cond
((parser-success-p (look-char? p #\/))(input-char p #\/)(input p :SYMBOL));choice clause
((parser-success-p (look-char? p #\-))
(input-char p #\-)
(input p :SYMBOL)
);choice alt
((parser-success-p (look-char? p #\?))
(input-char p #\?)
(return)
);choice alt
((parser-success-p (look-char? p #\'))
(input-char p #\')
(return)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

