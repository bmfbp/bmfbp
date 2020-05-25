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


;; name 

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

;; emission

(defmethod true-p ((e arrowgrams/esa-transpiler::expression))
  (string= "true" (stack-dsl:%as-string (arrowgrams/esa-transpiler::ekind e))))
(defmethod false-p ((e arrowgrams/esa-transpiler::expression))
  (string= "false" (stack-dsl:%as-string (arrowgrams/esa-transpiler::ekind e))))
(defmethod object-p ((e arrowgrams/esa-transpiler::expression))
  (string= "object" (stack-dsl:%as-string (arrowgrams/esa-transpiler::ekind e))))

(defmethod empty-p ((x T))
(format *error-output* "~&empty-p T ~s~%" x)
  nil)
#+nil(defmethod empty-p ((self arrowgrams/esa-transpiler::empty))
(format *error-output* "~&empty-p self ~s~%" self)
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

(defun implies (test implication)
  (or (and test (assert implication)) t))
      
(defmethod walk-object ((obj arrowgrams/esa-transpiler::object))
  ;; as per the above comment, an object can have a field or a paramList, but not both
  (unless (empty-p obj)  ;; this is probably redundant
    (let ((name (arrowgrams/esa-transpiler::name obj))
	  (params (arrowgrams/esa-transpiler::parameterList obj))
	  (f (arrowgrams/esa-transpiler::field obj)))
      (implies (not (empty-p f)) (empty-p params))
      (implies (not (empty-p params)) (empty-p f))
      (let ((item (if (not (empty-p f)) 
		      (lispify name))))
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
