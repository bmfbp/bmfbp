(in-package :arrowgram/compiler)

(defmethod esa-dsl ((p parser))
(call-rule p #'types)
(call-rule p #'kinds)
(call-rule p #'aux)
(call-rule p #'scripts)
(input p :EOF)
) ; rule

(defmethod keyword ((p parser)) ;; predicate
(cond
((parser-success-p (look? p :SYMBOL))(cond
((parser-success-p (look-symbol? p "type"))(return-from keyword :ok));choice clause
((parser-success-p (look-symbol? p "kind"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "end"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "proto"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "method"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "script"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "aux"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "let"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "map"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "in"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "loop"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "if"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "then"))
(return-from keyword :ok)
);choice alt
((parser-success-p (look-symbol? p "else"))
(return-from keyword :ok)
);choice alt
( t 
(return-from keyword :fail)
);choice alt
);choice
);choice clause
( t 
(return-from keyword :fail)
);choice alt
);choice

) ; pred

(defmethod non-keyword-symbol ((p parser)) ;; predicate
(cond
((parser-success-p (look? p :SYMBOL))(cond
((parser-success-p (call-predicate p #'keyword))(return-from non-keyword-symbol :fail));choice clause
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

(defmethod types ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "type"))(call-rule p #'type));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod type ((p parser))
(input-symbol p "type")
(call-rule p #'esa-symbol)
) ; rule

(defmethod kinds ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "kind"))(call-rule p #'kind));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod aux ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "aux"))(call-rule p #'aux));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod scripts ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "script"))(call-rule p #'script-definition));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod kind ((p parser))
(input-symbol p "kind")
(call-rule p #'esa-symbol)
(call-rule p #'optional-prototype)
(loop
(cond
((parser-success-p (look-symbol? p "script"))(call-rule p #'script-decl));choice clause
((parser-success-p (look-symbol? p "method"))
(call-rule p #'method-decl)
);choice alt
((parser-success-p (look-symbol? p "field"))
(call-rule p #'field-decl)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

(input-symbol p "end")
(input-symbol p "kind")
) ; rule

(defmethod optional-prototype ((p parser))
(cond
((parser-success-p (look-symbol? p "proto"))(input-symbol p "proto")(call-rule p #'esa-symbol));choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod aux ((p parser))
(input-symbol p "aux")
(call-rule p #'esa-symbol)
(loop
(cond
((parser-success-p (look-symbol? p "field"))(call-rule p #'field-decl));choice clause
((parser-success-p (look-symbol? p "method"))
(call-rule p #'method-decl)
);choice alt
((parser-success-p (look-symbol? p "script"))
(call-rule p #'script-decl)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

(input-symbol p "end")
(input-symbol p "aux")
) ; rule

(defmethod field-decl ((p parser))
(input-symbol p "field")
(cond
((parser-success-p (look-symbol? p "map"))(call-rule p #'map-decl));choice clause
((parser-success-p (call-predicate p #'non-keyword-symbol))
(call-rule p #'esa-symbol)
);choice alt
( t 
);choice alt
);choice

) ; rule

(defmethod method-decl ((p parser))
(input-symbol p "method")
(call-rule p #'esa-symbol)
(call-rule p #'typed-formals)
(call-rule p #'return-type)
) ; rule

(defmethod script-decl ((p parser))
(input-symbol p "script")
(call-rule p #'esa-symbol)
(call-rule p #'typed-formals)
(call-rule p #'return-type)
) ; rule

(defmethod map-decl ((p parser))
(input-symbol p "map")
(call-rule p #'esa-symbol)
) ; rule

(defmethod typed-formals ((p parser))
(cond
((parser-success-p (look-char? p #\())(input-char p #\()(call-external p #'type-list)(input-char p #\)));choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod type-list ((p parser))
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

(defmethod return-type ((p parser))
(cond
((parser-success-p (look-char? p #\>))(input-char p #\>)(input-char p #\>)(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map")(call-rule p #'esa-symbol));choice clause
((call-rule p #'esa-symbol)
);choice alt
);choice
);choice clause
( t 
);choice alt
);choice

) ; rule

(defmethod script-definition ((p parser))
(input-symbol p "script")
(call-rule p #'qualified-symbol)
(call-rule p #'formals)
(call-rule p #'return-type)
(call-rule p #'script-body)
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
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod script-body ((p parser))
(loop
(cond
((parser-success-p (look-symbol? p "let"))(call-rule p #'let-statement));choice clause
((parser-success-p (look-symbol? p "map"))
(call-rule p #'map-statement)
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
(call-rule p #'script-call)
);choice alt
((parser-success-p (call-predicate p #'non-keyword-symbol))
(call-rule p #'method-call)
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
(call-rule p #'esa-expr)
(input-symbol p "in")
(call-rule p #'script-body)
(input-symbol p "end")
(input-symbol p "let")
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
(call-rule p #'qualified-symbol)
) ; rule

(defmethod method-call ((p parser))
(call-rule p #'qualified-symbol)
) ; rule

(defmethod return-statement ((p parser))
(input-char p #\>)
(input-char p #\>)
(call-rule p #'esa-symbol)
) ; rule

(defmethod qualified-symbol ((p parser))
(call-rule p #'esa-symbol)
(call-rule p #'qualifiers)
(call-rule p #'actuals)
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

(defmethod actuals ((p parser))
(cond
((parser-success-p (look-char? p #\())(input-char p #\()(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol));choice clause
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

(defmethod dotted-symbol ((p parser))
(input-char p #\.)
(call-rule p #'esa-symbol)
) ; rule

(defmethod esa-symbol ((p parser))
(input p :SYMBOL)
(call-rule p #'esa-symbol-follow)
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

(call-rule p #'qualified-symbol)
) ; rule

