(in-package :arrowgrams/build)

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
      (emit p "~&function ~a () {}~%~a.prototype = {~%" (atext p) (atext p))
(call-rule p #'field-decl-begin)
(call-rule p #'field-decl)
(loop
(cond
((parser-success-p (call-predicate p #'field-decl)));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

      (emit p "};~%")
(input-symbol p "end")
(input-symbol p "class")
) ; rule

(defmethod field-decl-begin ((p parser))
(cond
((parser-success-p (look-symbol? p "map"))(call-rule p #'map-decl));choice clause
((parser-success-p (call-predicate p #'non-keyword-symbol))
(call-rule p #'field-decl)
);choice alt
);choice

) ; rule

(defmethod field-decl ((p parser)) ;; predicate
(cond
((parser-success-p (look-symbol? p "map"))(call-rule p #'map-decl)(return-from field-decl :ok));choice clause
((parser-success-p (call-predicate p #'non-keyword-symbol))
(call-rule p #'esa-symbol)
     (emit p "~&  ~a: null~%" (atext p))
(return-from field-decl :ok)
);choice alt
( t 
(return-from field-decl :fail)
);choice alt
);choice

) ; pred

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

      (clear-method-stream p)
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

(call-external p #'emit-methods)
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

(defmethod method-decl ((p parser))
(input-symbol p "method")
(call-rule p #'esa-symbol)
      (emit-to-method-stream p "~%~a.~a = function (" (current-class p) (atext p))
(call-rule p #'generic-typed-formals)
      (emit-to-method-stream p ") {};~&") ;; close parameter list
(call-rule p #'return-type)
) ; rule

(defmethod script-decl ((p parser))
(input-symbol p "script")
(call-rule p #'esa-symbol)
      (emit-to-method-stream p "~%~a.~a = function /*script*/ (" (current-class p) (atext p))
(call-rule p #'generic-typed-formals)
      (emit-to-method-stream p ") {};~&")
(call-rule p #'return-type)
) ; rule

(defmethod map-decl ((p parser))
(input-symbol p "map")
(call-rule p #'esa-symbol)
     (emit p "~&(~a :accessor ~a :initform nil)" (atext p) (atext p))
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
     (emit-to-method-stream p ", ~a" (atext p))
(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol)     (emit-to-method-stream p ", ~a" (atext p)));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

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
     (emit-to-method-stream p ", ~a" (gensym))
(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol)     (emit-to-method-stream p ", ~a" (gensym)));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

) ; rule

(defmethod return-type ((p parser))
(cond
((parser-success-p (look-char? p #\>))(input-char p #\>)(input-char p #\>)(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map")(call-rule p #'esa-symbol)            (emit-to-method-stream p " /*returns map ~a*/ " (atext p)));choice clause
( t 
(call-rule p #'esa-symbol)
            (emit-to-method-stream p " /*returns ~a*/ " (atext p))
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
(call-external p #'set-current-class)
(call-rule p #'qualified-symbol)
(call-external p #'set-current-method)
      (emit p "~%~a.~a = function /*script*/ (" (current-class p) (current-method p))
(call-rule p #'formals)
      (emit p ") {~&")  
(call-rule p #'return-type)
(call-rule p #'script-body)
      (emit p "~%};~&/*end script*/~&")
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
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-symbol)    (emit p ", ~a " (atext p)));choice clause
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
      (emit p "~&{~%  let ~a =" (atext p))
(input-char p #\=)
(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map"));choice clause
( t 
);choice alt
);choice

(call-rule p #'esa-expr)
      (emit p ";~%")
(input-symbol p "in")
(call-rule p #'script-body)
      (emit p "~&}~%")
(input-symbol p "end")
(input-symbol p "let")
) ; rule

(defmethod create-statement ((p parser))
(input-symbol p "create")
(call-rule p #'esa-symbol)
      (emit p "~&{ let ~a = " (atext p))
(input-char p #\=)
(cond
((parser-success-p (look-symbol? p "map"))(input-symbol p "map"));choice clause
( t 
);choice alt
);choice

(call-rule p #'class-ref)
      (emit p "new ~a();~%" (atext p))
(input-symbol p "in")
(call-rule p #'script-body)
      (emit p "~&}/*end create*/~%")   
(input-symbol p "end")
(input-symbol p "create")
) ; rule

(defmethod set-statement ((p parser))
(input-symbol p "set")
      (emit p "~%")
(call-rule p #'esa-expr)
(input-char p #\=)
      (emit p " = ")
(call-rule p #'esa-expr)
) ; rule

(defmethod map-statement ((p parser))
(input-symbol p "map")
(call-rule p #'esa-symbol)
      (emit p "~&(function () {~%  let ~a;~%" (atext p))
(input-char p #\=)
(call-rule p #'esa-expr)
(input-symbol p "in")
(call-rule p #'script-body)
      (emit p "~&})();/*end map*/~%")
(input-symbol p "end")
(input-symbol p "map")
) ; rule

(defmethod exit-map-statement ((p parser))
(input-symbol p "exit-map")
     (emit p "~&return;~%")
) ; rule

(defmethod loop-statement ((p parser))
(input-symbol p "loop")
     (emit p "~&while (true) {~%")
(call-rule p #'script-body)
     (emit p "~&}/*end loop*/~%")
(input-symbol p "end")
(input-symbol p "loop")
) ; rule

(defmethod exit-when-statement ((p parser))
(input-symbol p "exit-when")
     (emit p "~&if (")
(call-rule p #'esa-expr)
     (emit p ") return;~%")
) ; rule

(defmethod if-statement ((p parser))
(input-symbol p "if")
    (emit p "~&if (")
(call-rule p #'esa-expr)
    (emit p ") {~%")
(input-symbol p "then")
(call-rule p #'script-body)
    (emit p "~&}~%")
(cond
((parser-success-p (look-symbol? p "else"))(input-symbol p "else")    (emit p "~&else {~%")(call-rule p #'script-body)    (emit p "~&}~%"));choice clause
( t 
);choice alt
);choice

(input-symbol p "end")
(input-symbol p "if")
) ; rule

(defmethod script-call ((p parser))
(input-char p #\@)
(call-rule p #'qualified-symbol)
    (emit p "~&this.~a();~%" (atext p))
) ; rule

(defmethod method-call ((p parser))
(call-rule p #'qualified-symbol)
    (emit p "~&this.~a();~%" (atext p))
) ; rule

(defmethod return-statement ((p parser))
(input-char p #\>)
(input-char p #\>)
(cond
((parser-success-p (look-symbol? p "true"))(input-symbol p "true")                (emit p "~&return true;~%"));choice clause
((parser-success-p (look-symbol? p "false"))
(input-symbol p "false")
                (emit p "~&return false;~%")
);choice alt
( t 
(call-rule p #'esa-symbol)
                (emit p "~&return ~a;~%" (atext p))
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
((parser-success-p (look-char? p #\'))
(input-char p #\')
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
(call-external p #'string-stack-open)
(cond
((parser-success-p (look-char? p #\@))(input-char p #\@));choice clause
( t 
);choice alt
);choice

(cond
((parser-success-p (look-symbol? p "true"))(input-symbol p "true")(call-external p #'emit-true));choice clause
((parser-success-p (look-symbol? p "false"))
(input-symbol p "false")
(call-external p #'emit-false)
);choice alt
( t 
(call-rule p #'esa-symbol)
(call-external p #'push-string)
(loop
(cond
((parser-success-p (look-char? p #\.))(call-rule p #'dotted-symbol)(call-external p #'push-string));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop

(cond
((call-external p #'string-stack-has-only-one-item)(call-external p #'emit-string-pop));choice clause
( t 
(call-external p #'emit-lpar-inc-count)
(call-external p #'emit-string-pop)
);choice alt
);choice

(loop
(cond
((call-external p #'string-stack-empty)(return));choice clause
((call-external p #'string-stack-has-only-one-item)
(call-external p #'emit-string-pop)
(return)
);choice alt
( t 
(call-external p #'emit-lpar-inc-count)
(call-external p #'emit-string-pop)
);choice alt
);choice

) ;;loop

(call-external p #'emit-rpars-count-less-1)
(call-rule p #'actuals)
(call-external p #'emit-rpars)
(call-external p #'string-stack-close)
);choice alt
);choice

) ; rule

(defmethod actuals ((p parser))
(cond
((parser-success-p (look-char? p #\())(input-char p #\()           (emit p " ")(call-external p #'set-lpar-count-to-1)(loop
(cond
((parser-success-p (call-predicate p #'non-keyword-symbol))(call-rule p #'esa-expr)          (emit p " "));choice clause
( t 
(return)
);choice alt
);choice

) ;;loop
(input-char p #\)));choice clause
( t 
(call-external p #'emit-rpars-count-less-1)
);choice alt
);choice

) ; rule

