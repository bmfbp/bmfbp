(in-package :arrowgrams/esa)

(defmethod esa-dsl ((p parser))
   (emit p "(in-package :arrowgrams/esa)")
(call-external p #'reset-classes)
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
(call-rule p #'when-definition)
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
(call-external p #'set-current-class)
(call-external p #'open-class-descriptor)
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
((parser-success-p (look-symbol? p "map"))(input-symbol p "map")(call-rule p #'esa-symbol)(call-external p #'create-method-descriptor-for-class)(call-external p #'set-current-method-as-map));choice clause
((parser-success-p (call-predicate p #'non-keyword-symbol))
(call-rule p #'esa-symbol)
(call-external p #'create-method-descriptor-for-class)
);choice alt
);choice

) ; rule

(defmethod when-definition ((p parser))
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

(call-external p #'open-new-method-descriptor)
(call-rule p #'class-ref)
(loop
(cond
((parser-success-p (look-symbol? p "script"))(call-rule p #'script-decl));choice clause
((parser-success-p (look-symbol? p "method"))
(call-rule p #'method-decl)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

(input-symbol p "end")
(input-symbol p "when")
(call-external p #'close-new-method-descriptor)
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

(defmethod method-decl ((p parser))
(input-symbol p "method")
(call-rule p #'esa-symbol)
(call-external p #'open-method-descriptor)
(call-rule p #'generic-typed-formals)
(call-rule p #'optional-return-type)
(call-external p #'close-method-descriptor)
) ; rule

(defmethod script-decl ((p parser))
(input-symbol p "script")
(call-rule p #'esa-symbol)
(call-external p #'open-method-descriptor-for-current-class)
(call-rule p #'generic-typed-formals)
(call-rule p #'optional-return-type)
(call-external p #'close-method-descriptor)
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
(call-external p #'add-formal-parameter-to-method)
(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol)(call-external p #'add-formal-parameter-to-method));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod optional-return-type ((p parser))
(cond
((parser-success-p (look-char? p #\>))(input-char p #\>)(input-char p #\>)(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map")(call-rule p #'esa-symbol)(call-external p #'add-return-type-to-current-method)(call-external p #'set-return-type-as-map));choice clause
( t 
(call-rule p #'esa-symbol)
(call-external p #'add-return-type-to-current-method)
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
(call-external p #'current-class-push)
(call-rule p #'qualified-symbol)
(call-external p #'method-open)
(call-rule p #'formals)
(call-rule p #'return-type)
(call-rule p #'script-body)
(call-external p #'method-attach-to-class)
(call-external p #'method-close)
(call-external p #'current-class-pop)
(input-symbol p "end")
(input-symbol p "script")
) ; rule

(defmethod formals ((p parser))
(loop
(cond
((parser-success-p (look-char? p #\())(input-char p #\()(call-external p #'untyped-formals)(input-char p #\)));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod untyped-formals ((p parser))
(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol)    (emit p " ~a " (atext p)));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod script-body ((p parser))
(loop
     (emit p "~%")
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
      (emit-code p "~&let ~a =" (atext p))
(input-char p #\=)
(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map"));choice clause
( t 
);choice alt
);choice

(call-rule p #'esa-expr)
      (emit-code p "; /* let */ ~%")
(input-symbol p "in")
(call-rule p #'script-body)
(input-symbol p "end")
(input-symbol p "let")
) ; rule

(defmethod create-statement ((p parser))
(input-symbol p "create")
(call-rule p #'esa-symbol)
      (emit-code p "~&let ~a = " (atext p))
(input-char p #\=)
(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map"));choice clause
( t 
);choice alt
);choice

(cond
((parser-success-p (look-char? p #\*))(input-char p #\*)(call-rule p #'class-ref)      (emit-code p "new *~a(); /* create* */ ~%" (atext p)));choice clause
( t 
(call-rule p #'class-ref)
      (emit-code p "new ~a(); /* create */ ~%" (atext p))
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
      (emit-code p " = ")
(call-rule p #'esa-expr)
      (emit-code p " ; /* set */~% ")
) ; rule

(defmethod map-statement ((p parser))
(input-symbol p "map")
(call-rule p #'esa-symbol)
      (emit-code p "~&for ~a in " (atext p))
(input-char p #\=)
(call-rule p #'esa-expr)
      (emit-code p ") {~%")
(input-symbol p "in")
(call-rule p #'script-body)
      (emit-code p "} /* end map */ ~%")
(input-symbol p "end")
(input-symbol p "map")
) ; rule

(defmethod exit-map-statement ((p parser))
(input-symbol p "exit-map")
     (emit-code p "~&return; /* exit map */ ~%")
) ; rule

(defmethod loop-statement ((p parser))
(input-symbol p "loop")
     (emit-code p "~&while (true) {~%")
(call-rule p #'script-body)
     (emit-code p "~&} /*end loop*/ ~%")
(input-symbol p "end")
(input-symbol p "loop")
) ; rule

(defmethod exit-when-statement ((p parser))
(input-symbol p "exit-when")
     (emit-code p "~&if (")
(call-rule p #'esa-expr)
     (emit-code p ") return; /* exit-when */ ~%")
) ; rule

(defmethod if-statement ((p parser))
(input-symbol p "if")
    (emit-code p "~&if (")
(call-rule p #'esa-expr)
    (emit-code p ") {~%")
(input-symbol p "then")
(call-rule p #'script-body)
    (emit-code p "~&}  /* end if */ ~%")
(cond
((parser-success-p (look-symbol? p "else"))(input-symbol p "else")    (emit-code p "~&else {~%")(call-rule p #'script-body)    (emit-code p "~&} /* end else */ ~%"));choice clause
( t 
);choice alt
);choice

(input-symbol p "end")
(input-symbol p "if")
) ; rule

(defmethod script-call ((p parser))
(input-char p #\@)
(call-rule p #'qualified-symbol)
    (emit-code p "~&this.~a(); /* call script */ ~%" (atext p))
) ; rule

(defmethod method-call ((p parser))
(call-rule p #'qualified-symbol)
    (emit-code p "~&this.~a(); /* call method */ ~%" (atext p))
) ; rule

(defmethod return-statement ((p parser))
(input-char p #\>)
(input-char p #\>)
(cond
((parser-success-p (look-symbol? p "true"))(input-symbol p "true")                (emit-code p "~&return true; /* return true */ ~%"));choice clause
((parser-success-p (look-symbol? p "false"))
(input-symbol p "false")
                (emit-code p "~&return false; /* return false */ ~%")
);choice alt
( t 
(call-rule p #'esa-symbol)
                (emit-code p "~&return ~a; /* return value */ ~%" (atext p))
);choice alt
);choice

) ; rule

(defmethod qualified-symbol ((p parser))
(call-rule p #'esa-symbol)
(cond
((parser-success-p (look-char? p #\.))(call-rule p #'dotted-symbol));choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod qualifiers ((p parser))
(loop
(cond
((parser-success-p (look-char? p #\.))(call-rule p #'dotted-symbol));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod dotted-symbol ((p parser))
(input-char p #\.)
(call-external p #'emit-code-dot)
(call-rule p #'esa-symbol)
(call-external p #'emit-code-symbol)
) ; rule

(defmethod esa-symbol ((p parser))
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-external p #'clear-saved-text)(input p :SYMBOL)(call-rule p #'esa-symbol-follow));choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod esa-symbol-follow ((p parser))
(call-external p #'save-text)
(loop
(cond
((parser-success-p (look-char? p #\/))(input-char p #\/)(call-external p #'emit-code-slash)(input p :SYMBOL)(call-external p #'emit-code-symbol));choice clause
((parser-success-p (look-char? p #\-))
(input-char p #\-)
(call-external p #'emit-code-dash)
(input p :SYMBOL)
(call-external p #'emit-code-symbol)
);choice alt
((parser-success-p (look-char? p #\?))
(input-char p #\?)
(call-external p #'emit-code-question)
(return)
);choice alt
((parser-success-p (look-char? p #\'))
(input-char p #\')
(call-external p #'emit-code-primed)
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
((parser-success-p (look-symbol? p "true"))(input-symbol p "true")(call-external p #'emit-code-true));choice clause
((parser-success-p (look-symbol? p "false"))
(input-symbol p "false")
(call-external p #'emit-code-false)
);choice alt
( t 
(call-rule p #'esa-symbol)
(call-external p #'emit-code-symbol)
(loop
(cond
((parser-success-p (look-char? p #\.))(call-rule p #'dotted-symbol));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

(call-rule p #'actuals)
);choice alt
);choice

) ; rule

(defmethod actuals ((p parser))
(cond
((parser-success-p (look-char? p #\())(input-char p #\()(call-external p #'emit-code-lpar)(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-external p #'emit-code-comma)(call-rule p #'esa-expr));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop
(input-char p #\))(call-external p #'emit-code-rpar));choice clause
( t 
);choice alt
);choice

) ; rule

