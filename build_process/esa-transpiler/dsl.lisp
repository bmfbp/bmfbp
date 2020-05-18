(in-package "ARROWGRAMS/ESA-TRANSPILER")

(defmethod esa-dsl ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "esa-dsl") (pasm::p-into-trace p)
(pasm:call-external p #'emitHeader)
(pasm:call-rule p #'type-decls)
(pasm:call-rule p #'situations)
(pasm:call-rule p #'classes)
(pasm:call-rule p #'whens-and-scripts)
(pasm:input p :EOF)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod keyword-symbol ((p pasm:parser)) ;; predicate
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "keyword-symbol") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "create"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "end"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "method"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "script"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "let"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "set"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "in"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "loop"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "if"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "then"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "else"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "when"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "or"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "exit-map"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from keyword-symbol pasm:+succeed+)
)
( t (setf (pasm:current-rule p) prev-rule) (pasm::p-into-trace p)(return-from keyword-symbol pasm:+fail+)
)
)

)
( t (setf (pasm:current-rule p) prev-rule) (pasm::p-into-trace p)(return-from keyword-symbol pasm:+fail+)
)
)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod non-keyword-symbol ((p pasm:parser)) ;; predicate
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "non-keyword-symbol") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(cond
((pasm:parser-success? (pasm:call-predicate p #'keyword-symbol))(setf (pasm:current-rule p) prev-rule) (pasm::p-into-trace p)(return-from non-keyword-symbol pasm:+fail+)
)
( t (setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from non-keyword-symbol pasm:+succeed+)
)
)

)
( t (setf (pasm:current-rule p) prev-rule) (pasm::p-into-trace p)(return-from non-keyword-symbol pasm:+fail+)
)
)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod type-decls ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "type-decls") (pasm::p-into-trace p)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "type"))(pasm:call-rule p #'type-decl)
)
( t (return)
)
)

)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod type-decl ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "type-decl") (pasm::p-into-trace p)
(pasm:input-symbol p "type")
(pasm:call-rule p #'esa-symbol)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod situations ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "situations") (pasm::p-into-trace p)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "situation"))(pasm:call-rule p #'situation)
)
( t (return)
)
)

)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod situation ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "situation") (pasm::p-into-trace p)
(pasm:input-symbol p "situation")
(pasm:input p :SYMBOL)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod classes ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "classes") (pasm::p-into-trace p)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "class"))(pasm:call-rule p #'class-def)
)
( t (return)
)
)

)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod whens-and-scripts ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "whens-and-scripts") (pasm::p-into-trace p)
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

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod class-def ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "class-def") (pasm::p-into-trace p)
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
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod field-decl-begin ((p pasm:parser)) ;; predicate
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "field-decl-begin") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from field-decl-begin pasm:+succeed+)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)(return-from field-decl-begin pasm:+succeed+)
)
( t (setf (pasm:current-rule p) prev-rule) (pasm::p-into-trace p)(return-from field-decl-begin pasm:+fail+)
)
)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod field-decl ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "field-decl") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "map"))(pasm:input-symbol p "map")
(pasm:call-rule p #'esa-symbol)
)
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(pasm:call-rule p #'esa-symbol)
)
)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod when-declaration ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "when-declaration") (pasm::p-into-trace p)
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
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod situation-ref ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "situation-ref") (pasm::p-into-trace p)
(pasm:call-rule p #'esa-symbol)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod or-situation ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "or-situation") (pasm::p-into-trace p)
(pasm:input-symbol p "or")
(pasm:call-rule p #'situation-ref)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod class-ref ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "class-ref") (pasm::p-into-trace p)
(pasm:call-rule p #'esa-symbol)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod method-declaration ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "method-declaration") (pasm::p-into-trace p)
(pasm:input-symbol p "method")
(pasm:call-rule p #'esa-symbol)
(pasm:call-rule p #'generic-typed-formals)
(pasm:call-rule p #'optional-return-type-declaration)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod script-declaration ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "script-declaration") (pasm::p-into-trace p)
(pasm:input-symbol p "script")
(pasm:call-rule p #'esa-symbol)
(pasm:call-rule p #'generic-typed-formals)
(pasm:call-rule p #'optional-return-type-declaration)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod generic-typed-formals ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "generic-typed-formals") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-external p #'generic-type-list)
(pasm:input-char p #\))
)
( t )
)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod generic-type-list ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "generic-type-list") (pasm::p-into-trace p)
(pasm:call-rule p #'esa-symbol)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(pasm:call-rule p #'esa-symbol)
)
( t (return)
)
)

)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod optional-return-type-declaration ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "optional-return-type-declaration") (pasm::p-into-trace p)
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

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod script-definition ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "script-definition") (pasm::p-into-trace p)
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
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod optional-formals-definition ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "optional-formals-definition") (pasm::p-into-trace p)
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

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod untyped-formals-definition ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "untyped-formals-definition") (pasm::p-into-trace p)
(loop
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(pasm:call-rule p #'esa-symbol)
)
( t (return)
)
)

)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod optional-return-type-definition ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "optional-return-type-definition") (pasm::p-into-trace p)
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

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod script-body ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "script-body") (pasm::p-into-trace p)
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

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod let-statement ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "let-statement") (pasm::p-into-trace p)
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
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod create-statement ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "create-statement") (pasm::p-into-trace p)
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
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod set-statement ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "set-statement") (pasm::p-into-trace p)
(pasm:input-symbol p "set")
(pasm:call-rule p #'esa-expr)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod map-statement ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "map-statement") (pasm::p-into-trace p)
(pasm:input-symbol p "map")
(pasm:call-rule p #'esa-symbol)
(pasm:input-char p #\=)
(pasm:call-rule p #'esa-expr)
(pasm:input-symbol p "in")
(pasm:call-rule p #'script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "map")
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod exit-map-statement ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "exit-map-statement") (pasm::p-into-trace p)
(pasm:input-symbol p "exit-map")
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod loop-statement ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "loop-statement") (pasm::p-into-trace p)
(pasm:input-symbol p "loop")
(pasm:call-rule p #'script-body)
(pasm:input-symbol p "end")
(pasm:input-symbol p "loop")
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod exit-when-statement ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "exit-when-statement") (pasm::p-into-trace p)
(pasm:input-symbol p "exit-when")
(pasm:call-rule p #'esa-expr)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod if-statement ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "if-statement") (pasm::p-into-trace p)
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
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod script-call ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "script-call") (pasm::p-into-trace p)
(pasm:input-char p #\@)
(pasm:call-rule p #'esa-expr)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod method-call ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "method-call") (pasm::p-into-trace p)
(pasm:call-rule p #'esa-expr)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod return-statement ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "return-statement") (pasm::p-into-trace p)
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

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod esa-symbol ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "esa-symbol") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:call-predicate p #'non-keyword-symbol))(pasm:input p :SYMBOL)
(pasm:call-rule p #'esa-field-follow-nonemitting)
)
( t )
)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod esa-field-follow-nonemitting ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "esa-field-follow-nonemitting") (pasm::p-into-trace p)
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

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod esa-expr ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "esa-expr") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\@))(pasm:input-char p #\@)
)
( t )
)

(pasm:call-external p #'$expr__NewScope)
(cond
((pasm:parser-success? (pasm:lookahead-symbol? p "true"))(pasm:input-symbol p "true")
(pasm:call-external p #'$expr__SetKindTrue)
)
((pasm:parser-success? (pasm:lookahead-symbol? p "false"))(pasm:input-symbol p "false")
(pasm:call-external p #'$expr__SetKindTrue)
)
( t (pasm:call-external p #'$expr__SetKindObject)
(pasm:call-rule p #'object__)
(pasm:call-external p #'$expr__setField_object_from_object)
)
)

(pasm:call-external p #'$expr__Output)
(pasm:call-external p #'$expr__Emit)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod object__ ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "object__") (pasm::p-into-trace p)
(pasm:call-external p #'$object__NewScope)
(pasm:call-rule p #'object__name)
(pasm:call-external p #'$object__setField_name_from_name)
(pasm:call-rule p #'object__fieldList)
(pasm:call-external p #'$object__Output)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod object__name ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "object__name") (pasm::p-into-trace p)
(pasm:call-external p #'$name__NewScope)
(pasm:call-rule p #'esaSymbol)
(pasm:call-external p #'$name__Output)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod object__fieldList ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "object__fieldList") (pasm::p-into-trace p)
(loop
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\.))(pasm:call-rule p #'object__fieldList__field)
)
( t (return)
)
)

)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod object__fieldList__field ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "object__fieldList__field") (pasm::p-into-trace p)
(pasm:input-char p #\.)
(pasm:call-rule p #'object__fieldList__field__name)
(pasm:call-rule p #'object__fieldList__field__optionalParameterMap)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod object__fieldList__field__name ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "object__fieldList__field__name") (pasm::p-into-trace p)
(pasm:call-external p #'$name__NewScope)
(pasm:call-rule p #'esaSymbol)
(pasm:call-external p #'$name__Output)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod object__fieldList__field__optionalParameterMap ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "object__fieldList__field__optionalParameterMap") (pasm::p-into-trace p)
(cond
((pasm:parser-success? (pasm:lookahead-char? p #\())(pasm:input-char p #\()
(pasm:call-external p #'object__fieldList__field__rec-parameters)
(pasm:input-char p #\))
)
( t )
)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod object__fieldList__field__rec-parameters ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "object__fieldList__field__rec-parameters") (pasm::p-into-trace p)
(pasm:call-rule p #'object__fieldList__field__parameters__parameter)
(cond
((pasm:parser-success? (pasm:call-predicate p #'object__fieldList__field__parameters__pred-parameterBegin))(pasm:call-rule p #'object__fieldList__field__rec-parameters)
)
( t )
)

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod object__fields__field__parameters__pred-parameterBegin ((p pasm:parser)) ;; predicate
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "object__fields__field__parameters__pred-parameterBegin") (pasm::p-into-trace p)
(pasm:parser-success? (pasm:lookahead? p :SYMBOL))
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod object__fields__field__parameters__parameter ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "object__fields__field__parameters__parameter") (pasm::p-into-trace p)
(pasm:call-external p #'$name__NewScope)
(pasm:call-rule p #'esaSymbol)
(pasm:call-external p #'$name_Output)
(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

(defmethod esaSymbol ((p pasm:parser))
  (let ((prev-rule (pasm:current-rule p)))     (setf (pasm:current-rule p) "esaSymbol") (pasm::p-into-trace p)
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

(setf (pasm:current-rule p) prev-rule) (pasm::p-return-trace p)))

