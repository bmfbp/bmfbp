(in-package :arrowgrams/build)

(defmethod esa-dsl ((p parser))
   (emit p "(in-package :arrowgrams/build)~%~%")
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
((parser-success-p (look-symbol? p "set"))
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
((parser-success-p (look-symbol? p "aux"))(call-rule p #'auxiliary));choice clause
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
(call-external p #'set-current-class)
      (emit p "~&(defclass ~a ()~%(" (atext p))
      (clear-method-stream p)
(loop
(cond
((parser-success-p (look-symbol? p "script"))(call-rule p #'script-decl));choice clause
((parser-success-p (look-symbol? p "method"))
(call-rule p #'method-decl)
);choice alt
((parser-success-p (look-symbol? p "field"))
(call-rule p #'field-decl)
);choice alt
((parser-success-p (look-symbol? p "proto"))
(call-rule p #'proto-decl)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

      (emit p "))~%")
      (emit p "~%(defmethod create-~a () (make-instance '~a))" (current-class p) (current-class p))
(call-external p #'emit-methods)
(input-symbol p "end")
(input-symbol p "kind")
) ; rule

(defmethod auxiliary ((p parser))
(input-symbol p "aux")
(call-rule p #'esa-symbol)
(call-external p #'set-current-class)
(loop
(cond
((parser-success-p (look-symbol? p "method"))(call-rule p #'method-decl));choice clause
((parser-success-p (look-symbol? p "script"))
(call-rule p #'script-decl)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

(call-external p #'emit-methods)
(input-symbol p "end")
(input-symbol p "aux")
) ; rule

(defmethod field-decl ((p parser))
(input-symbol p "field")
(cond
((parser-success-p (look-symbol? p "map"))(call-rule p #'map-decl));choice clause
((parser-success-p (call-predicate p #'non-keyword-symbol))
(call-rule p #'esa-symbol)
     (emit p "~&(~a :accessor ~a)~%" (atext p) (atext p))
);choice alt
( t 
);choice alt
);choice

) ; rule

(defmethod proto-decl ((p parser))
(input-symbol p "proto")
(call-rule p #'esa-symbol)
     (emit p "~&(proto :accessor proto :initform (make-instance '~a))~%" (atext p))
) ; rule

(defmethod method-decl ((p parser))
(input-symbol p "method")
(call-rule p #'esa-symbol)
      (emit-to-method-stream p "~%(defgeneric ~a (self" (atext p))
(call-rule p #'typed-formals)
      (emit-to-method-stream p ")") ;; close parameter list
(call-rule p #'return-type)
      (emit-to-method-stream p ")") ;; close generic
) ; rule

(defmethod script-decl ((p parser))
(input-symbol p "script")
(call-rule p #'esa-symbol)
      (emit-to-method-stream p "~%(defgeneric ~a #|script|# (self" (atext p))
(call-rule p #'typed-formals)
      (emit-to-method-stream p ")")
(call-rule p #'return-type)
      (emit-to-method-stream p ")") ;; close generic
) ; rule

(defmethod map-decl ((p parser))
(input-symbol p "map")
(call-rule p #'esa-symbol)
     (emit p "~&(~a :accessor ~a :initform " (atext p) (atext p))
     (emit p "(empty-map '~a))~%" (atext p))
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
     (emit-to-method-stream p " ~a" (atext p))
(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol)     (emit-to-method-stream p " ~a" (atext p)));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod return-type ((p parser))
(cond
((parser-success-p (look-char? p #\>))(input-char p #\>)(input-char p #\>)(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map")(call-rule p #'esa-symbol)            (emit-to-method-stream p " #|returns map ~a|# " (atext p)));choice clause
( t 
(call-rule p #'esa-symbol)
            (emit-to-method-stream p " #|returns ~a|# " (atext p))
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
(call-external p #'set-current-method)
      (emit p "~%(defmethod ~a #|script|# ((self ~a)" (atext p) (current-class p))
(call-rule p #'formals)
      (emit p ")")  
(call-rule p #'return-type)
(call-rule p #'script-body)
      (emit p ")#|end script|#~%")
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
     (emit p "~%")
(cond
((parser-success-p (look-symbol? p "let"))(call-rule p #'let-statement));choice clause
((parser-success-p (look-symbol? p "map"))
(call-rule p #'map-statement)
);choice alt
((parser-success-p (look-symbol? p "set"))
(call-rule p #'set-statement)
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
      (emit p "(let ((~a " (atext p))
(input-char p #\=)
(call-rule p #'esa-expr)
      (emit p "))")
(input-symbol p "in")
(call-rule p #'script-body)
      (emit p ")#|end let|#")   
(input-symbol p "end")
(input-symbol p "let")
) ; rule

(defmethod set-statement ((p parser))
(input-symbol p "set")
      (emit p "(setf ")
(call-rule p #'esa-expr)
(input-char p #\=)
(call-rule p #'esa-expr)
      (emit p ")")
) ; rule

(defmethod map-statement ((p parser))
(input-symbol p "map")
(call-rule p #'esa-symbol)
      (emit p "(dolist (~a " (atext p))
(input-char p #\=)
(call-rule p #'esa-expr)
      (emit p ")")
(input-symbol p "in")
(call-rule p #'script-body)
      (emit p ")#|end map|#")   
(input-symbol p "end")
(input-symbol p "map")
) ; rule

(defmethod loop-statement ((p parser))
(input-symbol p "loop")
     (emit p "(loop")
(call-rule p #'script-body)
     (emit p ")#|end loop|#")
(input-symbol p "end")
(input-symbol p "loop")
) ; rule

(defmethod exit-when-statement ((p parser))
(input-symbol p "exit-when")
(call-rule p #'esa-expr)
     (emit p "(when ~a (return))" (atext p))
) ; rule

(defmethod if-statement ((p parser))
(input-symbol p "if")
    (emit p "(if ")
(call-rule p #'esa-expr)
(input-symbol p "then")
    (emit p "~%(progn")
(call-rule p #'script-body)
    (emit p ")")
(cond
((parser-success-p (look-symbol? p "else"))(input-symbol p "else")    (emit p "~%(progn")(call-rule p #'script-body)    (emit p ")#|end else|#"));choice clause
( t 
);choice alt
);choice

    (emit p ")#|end if|#")
(input-symbol p "end")
(input-symbol p "if")
) ; rule

(defmethod script-call ((p parser))
(input-char p #\@)
(call-rule p #'qualified-symbol)
    (emit p "(call-script p ~a)" (atext p))
) ; rule

(defmethod method-call ((p parser))
(call-rule p #'qualified-symbol)
    (emit p "(call-external p ~a)" (atext p))
) ; rule

(defmethod return-statement ((p parser))
(input-char p #\>)
(input-char p #\>)
(call-rule p #'esa-symbol)
    (emit p "(return-from ~a ~a)" (current-method p) (atext p))
) ; rule

(defmethod qualified-symbol ((p parser))
(call-rule p #'esa-symbol)
(call-external p #'set-current-class)
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
(call-rule p #'esa-symbol)
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
((parser-success-p (look-char? p #\/))(input-char p #\/)(call-external p #'combine-text)(input p :SYMBOL)(call-external p #'combine-text));choice clause
((parser-success-p (look-char? p #\-))
(input-char p #\-)
(call-external p #'combine-text)
(input p :SYMBOL)
(call-external p #'combine-text)
);choice alt
((parser-success-p (look-char? p #\?))
(input-char p #\?)
(call-external p #'combine-text)
(return)
);choice alt
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod esa-expr ((p parser))
(call-external p #'expr-stack-open)
(cond
((parser-success-p (look-char? p #\@))(input-char p #\@)(call-external p #'set-call-rule-flag));choice clause
( t 
);choice alt
);choice

(call-rule p #'esa-symbol)
(call-external p #'push-symbol-onto-expr-stack)
(loop
(cond
((parser-success-p (look-char? p #\.))(call-rule p #'dotted-symbol)(call-external p #'push-symbol-onto-expr-stack));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

(call-external p #'emit-expr-stack)
(call-rule p #'actuals)
(call-external p #'expr-stack-close)
) ; rule

(defmethod actuals ((p parser))
(cond
((parser-success-p (look-char? p #\())(input-char p #\()(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol)(call-external p #'emit-expr-actual));choice clause
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

