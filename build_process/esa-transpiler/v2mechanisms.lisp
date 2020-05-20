(in-package :arrowgrams/esa-transpiler)
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

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

(defmethod $expression__NewScope ((p parser))
  (stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-expression (env p))))

(defmethod $expression__setField_ekind_from_ekind ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-ekind (env p)))))
    (stack-dsl:%ensure-field-type "expression" "ekind" val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-expression (env p))) "ekind" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-ekind (env p)))))

(defmethod $expression__setField_object_from_object ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-object (env p)))))
    (stack-dsl:%ensure-field-type "expression" "object" val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-expression (env p))) "object" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-object (env p)))))

(defmethod $expression__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-expression (env p)) (arrowgrams/esa-transpiler::input-expression (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-expression (env p))))

;; ekind
(defmethod $ekind__NewScope ((p parser))
  (stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-ekind (env p))))

(defmethod $ekind__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-ekind (env p))
		     (arrowgrams/esa-transpiler::input-ekind  (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-ekind (env p))))

(defmethod $ekind__SetEnum_true ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (arrowgrams/esa-transpiler::input-ekind (env p)))) "true"))
(defmethod $ekind__SetEnum_false ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (arrowgrams/esa-transpiler::input-ekind (env p)))) "false"))
(defmethod $ekind__SetEnum_object ((p parser))
  (setf (stack-dsl:%value (stack-dsl:%top (arrowgrams/esa-transpiler::input-ekind (env p)))) "object"))

;; name 
(defmethod $name__NewScope ((p arrowgrams/esa-transpiler::parser))
  (stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-name (env p))))

(defmethod $name__GetName ((p arrowgrams/esa-transpiler::parser))
  ;; put accepted symbol name onto input stack of "name" (replace top of name stack)
  (let ((str (scanner:token-text (pasm:accepted-token p)))
	(name-object (make-instance (stack-dsl:lisp-sym "name"))))
    (setf (stack-dsl:%value name-object) str)
    ;; 2 steps to replace top of name stack (pop then push)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::input-name (env p)))
    (stack-dsl:%push (arrowgrams/esa-transpiler::input-name (env p)) name-object)))

(defmethod $name__combine ((p parser))
  (let ((name-tos (stack-dsl:%top (arrowgrams/esa-transpiler::input-name (env p)))))
    (let ((suffix (string (scanner:token-text (pasm:accepted-token p)))))
      (let ((new-text (concatenate 'string (stack-dsl:%value name-tos) suffix)))
	(setf (stack-dsl:%value name-tos) new-text)))))

(defmethod $name__Output ((p arrowgrams/esa-transpiler::parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-name (env p)) (arrowgrams/esa-transpiler::input-name (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-name (env p))))

;; object
(defmethod $object__NewScope ((p arrowgrams/esa-transpiler::parser))
  (stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-object (env p))))

(defmethod $object__Output ((p arrowgrams/esa-transpiler::parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-object (env p)) (arrowgrams/esa-transpiler::input-object (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-object (env p))))

(defmethod $object__setField_name_from_name ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-name (env p)))))
    (stack-dsl:%ensure-field-type
     "object"
     "name"
     val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-object (env p))) "name" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-name (env p)))))

(defmethod $object__setField_parameterList_from_parameterList ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-parameterList (env p)))))
    (stack-dsl:%ensure-field-type
     "object"
     "parameterList"
     val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-object (env p))) "parameterList" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-parameterList (env p)))))

(defmethod $object__setField_field_from_field ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-field (env p)))))
    (stack-dsl:%ensure-field-type
     "object"
     "field"
     val)
    (stack-dsl:%set-field (stack-dsl:%top (arrowgrams/esa-transpiler::input-object (env p))) "field" val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-field (env p)))))


;; field
(defmethod $field__NewScope ((p parser))
  (stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-field (env p))))

(defmethod $field__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-field (env p)) (arrowgrams/esa-transpiler::input-field (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-field (env p))))

(defmethod $field__CoerceFrom_empty ((p parser))
  ;; push tos(empty) onto field, pop(empty)
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-empty (env p)))))
    (stack-dsl:%ensure-type "field" val)
    (stack-dsl:%push (arrowgrams/esa-transpiler::input-field (env p)) val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-empty (env p)))))

(defmethod $field__CoerceFrom_object ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-object (env p)))))
    (stack-dsl:%ensure-type "field" val)
    (stack-dsl:%push (arrowgrams/esa-transpiler::input-field (env p)) val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-object (env p)))))

;; parameterList
(defmethod $parameterList__NewScope ((p parser))
  (stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-parameterList (env p))))

(defmethod $parameterList__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-parameterList (env p)) (arrowgrams/esa-transpiler::input-parameterList (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-parameterList (env p))))

(defmethod $parameterList__CoerceFrom_empty ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-empty (env p)))))
    (stack-dsl:%ensure-type "parameterList" val)
    (stack-dsl:%push (arrowgrams/esa-transpiler::input-parameterList (env p)) val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-empty (env p)))))

(defmethod $parameterList__CoerceFrom_nameList ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-nameList (env p)))))
    (stack-dsl:%ensure-type "parameterList" val)
    (stack-dsl:%push (arrowgrams/esa-transpiler::input-parameterList (env p)) val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-nameList (env p)))))

;; nameList
(defmethod $nameList__NewScope ((p parser))
  (stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-nameList (env p))))

(defmethod $nameList__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-nameList (env p)) (arrowgrams/esa-transpiler::input-nameList (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-nameList (env p))))

(defmethod $nameList__AppendFrom_name ((p parser))
  (let ((val (stack-dsl:%top (arrowgrams/esa-transpiler::output-name (env p)))))
    (stack-dsl:%ensure-appendable-type (arrowgrams/esa-transpiler::input-nameList (env p)))
    (stack-dsl:%ensure-type (stack-dsl:%element-type 
			     (stack-dsl:%top (arrowgrams/esa-transpiler::input-nameList (env p))))
			    val)
    (stack-dsl::%append (stack-dsl:%top (arrowgrams/esa-transpiler::input-nameList (env p))) val)
    (stack-dsl:%pop (arrowgrams/esa-transpiler::output-name (env p)))))

;; empty
(defmethod $empty__NewScope ((p parser))
  (stack-dsl:%push-empty (arrowgrams/esa-transpiler::input-empty (env p))))

(defmethod $empty__Output ((p parser))
  (stack-dsl:%output (arrowgrams/esa-transpiler::output-empty (env p)) (arrowgrams/esa-transpiler::input-empty (env p)))
  (stack-dsl:%pop (arrowgrams/esa-transpiler::input-empty (env p))))

;; emission

(defmethod true-p ((e arrowgrams/esa-transpiler::expression))
  (string= "true" (stack-dsl:%as-string (arrowgrams/esa-transpiler::ekind e))))
(defmethod false-p ((e arrowgrams/esa-transpiler::expression))
  (string= "false" (stack-dsl:%as-string (arrowgrams/esa-transpiler::ekind e))))
(defmethod object-p ((e arrowgrams/esa-transpiler::expression))
  (string= "object" (stack-dsl:%as-string (arrowgrams/esa-transpiler::ekind e))))

(defmethod empty-p ((x T))
  nil)
(defmethod empty-p ((self arrowgrams/esa-transpiler::empty))
  t)

(defmethod params-as-list ((self arrowgrams/esa-transpiler::nameList))
  (let ((result nil))
    (dolist (str (stack-dsl:%list self))
      (push (lispify str) result))
    (reverse result)))

(defmethod lispify ((self STRING))
  ;(intern (string-upcase self) "ARROWGRAMS/ESA"))
  ;; during early debug
  (intern (string-upcase self) "CL-USER"))

(defmethod lispify ((self stack-dsl:%string))
  (lispify (stack-dsl:%as-string self)))

(defmethod lispify ((self arrowgrams/esa-transpiler::name))
  (lispify (stack-dsl:%value self)))

(defmethod $emit__expression ((p parser))
  ;; instead of generalizing, I want to make this work soon
  ;; hence, I will implement only the bare minimum required by my use of ../esa/esa.dsl
  ;;
  ;; so, a parameter list can only appear on a field expression that has no more fields (.e. the last .expr)

  ;; abc --> abc
  ;; self.def -> (slot-value self 'def)
  ;; self.def.ghi (slot-value (slot-values self 'def) 'ghi)
  ;; self.def(ghi) -> ((slot-value abc 'def) ghi)
  ;; self.def(ghi).L -> *illegal for now* -> (slot-value ((slot-value abc 'def) ghi) 'L)
  ;; self.ensure-input-pin-not-declared(name) -> ((slot-value self 'ensure-input-pin-not-declared) name)
  (let ((e (stack-dsl:%top (arrowgrams/esa-transpiler::output-expression (env p)))))
    (let ((sexpr (walk-expression e)))
      (pasm:emit-string p "~s" sexpr)
      )))

(defmethod walk-expression ((e arrowgrams/esa-transpiler::expression))
  (cond ((true-p e)  :true)
	((false-p e) nil)
	(t
	 (assert (object-p e))
	 (walk-object (arrowgrams/esa-transpiler::object e)))))

(defmethod walk-object ((obj arrowgrams/esa-transpiler::object))
  ;; as per the above comment, an object can have a field or a paramList, but not both
  (unless (empty-p obj)  ;; this is probably redundant
    (let ((name (arrowgrams/esa-transpiler::name obj))
	  (params (arrowgrams/esa-transpiler::parameterList obj))
	  (f (arrowgrams/esa-transpiler::field obj)))
      (assert (if (not (empty-p f)) (empty-p params)))
      (assert (if (not (empty-p params)) (empty-p f)))
      (let ((item (if (not (empty-p f)) 
		      (lispify name))
	(if (empty-p f)
	    item
	    (let ((slot-name (walk-object f)))
	      (let ((slot-ref 
		     (if (atom slot-name)
			 `(slot-value ,item ',slot-name)
			 `(slot-value ,item ,slot-name))))
		(if (empty-p params)
		    slot-ref
                  `(,slot-ref ,@params))
		)))))))
