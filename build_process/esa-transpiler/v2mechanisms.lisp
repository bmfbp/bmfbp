(in-package :arrowgrams/esa-transpiler)

;; see file exprtypes.lisp generated from exprtypes.dsl (see README.org)
;;
;; The generated class is environment.
;; All of the expression types are within the generated class environment.

;;;; v2 mechanisms
(defmethod emitHeader ((p parser))
  (pasm:emit-string p "(in-package :arrowgrams/esa)"))

;; an expression is true or false or an object ref
;; an object ref is an object name optionally dotted with fields
;; fields might have parameters
;; e.g. x
;; e.g. x.a.b.c
;; e.g. x.a(g).b(h i).c

(defmethod $expr__NewScope ((p parser))
  (stack-dsl:%push-empty (cl-user::input-expression (env p))))

(defmethod $expr__SetKindTrue ((p parser))
  (stack-dsl:%ensure-field-type "expression" "kind" "true")
  (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-expression (env p))) "kind" "true"))
(defmethod $expr__SetKindFalse ((p parser))
  (stack-dsl:%ensure-field-type "expression" "kind" "false")
  (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-expression (env p))) "kind" "false"))
(defmethod $expr__SetKindObject ((p parser))
  (stack-dsl:%ensure-field-type "expression" "kind" "object")
  (stack-dsl:%set-field (stack-dsl:%top (cl-user::input-expression (env p))) "kind" "object"))

(defmethod $expr__Output ((p parser))
  (stack-dsl:%output (output-expression (env p))) (input-expression (env p))
  (stack-dsl:%pop (input-expression (env p))))


(defmethod $expr__Emit ((p parser))
  (break (stack-dsl:%top (cl-user::input-expression (env p))))
  (stack-dsl:%pop (cl-user::output-expression (env p))))
