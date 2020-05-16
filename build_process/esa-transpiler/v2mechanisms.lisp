(in-package :arrowgrams/esa)

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

(defmethod exprNewScope ((p parser))
  (stack-dsl:%push-empty (input-expression (env p))))

(defmethod exprSetKindTrue ((p parser))
  (stack-dsl:%ensure-field-type (input-expression (env p)) "kind" "true")
  (stack-dsl:%set-field (stack-dsl:%top (input-expression (env p))) "kind" "true"))
(defmethod exprSetKindFalse ((p parser))
  (stack-dsl:%ensure-field-type (input-expression (env p)) "kind" "false")
  (stack-dsl:%set-field (stack-dsl:%top (input-expression (env p))) "kind" "false"))
(defmethod exprSetKindObject ((p parser))
  (stack-dsl:%ensure-field-type (input-expression (env p)) "kind" "object")
  (stack-dsl:%set-field (stack-dsl:%top (input-expression (env p))) "kind" "object"))

(defmethod exprEmit ((p parser))
  (break))
