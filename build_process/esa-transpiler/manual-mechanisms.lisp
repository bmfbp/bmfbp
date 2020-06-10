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
    (stack-dsl:%pop (cl-user::input-name (env p)))
    (stack-dsl:%push (cl-user::input-name (env p)) name-object)))

(defmethod $name__combine ((p parser))
  (let ((name-tos (stack-dsl:%top (cl-user::input-name (env p)))))
    (let ((suffix (string (scanner:token-text (pasm:accepted-token p)))))
      (let ((new-text (concatenate 'string (stack-dsl:%value name-tos) suffix)))
	(setf (stack-dsl:%value name-tos) new-text)))))

(defmethod $name__IgnoreInPass1 ((p parser))
  (stack-dsl:%pop (cl-user::output-name (env p))))

(defmethod $name__IgnoreInPass2 ((p parser))
  (stack-dsl:%pop (cl-user::output-name (env p))))

(defmethod $expression__IgnoreInPass1 ((p parser))
  (stack-dsl:%pop (cl-user::output-expression (env p))))

;; emission

(defmethod true-p ((e cl-user::expression))
  (string= "true" (stack-dsl:%as-string (cl-user::ekind e))))
(defmethod false-p ((e cl-user::expression))
  (string= "false" (stack-dsl:%as-string (cl-user::ekind e))))
(defmethod object-p ((e cl-user::expression))
  (string= "object" (stack-dsl:%as-string (cl-user::ekind e))))

(defmethod empty-p ((x T))
(format *error-output* "~&empty-p T ~s~%" x)
  nil)
#+nil(defmethod empty-p ((self arrowgrams/esa-transpiler::empty))
(format *error-output* "~&empty-p self ~s~%" self)
  t)

(defmethod lispify ((self STRING))
  ;(intern (string-upcase self) "ARROWGRAMS/ESA"))
  ;; during early debug
  (intern (string-upcase self) "CL-USER"))

(defmethod lispify ((self stack-dsl:%string))
  (lispify (stack-dsl:%as-string self)))

(defmethod lispify ((self cl-user::name))
  (lispify (stack-dsl:%value self)))

(defmethod $emit__expression ((p parser))
  ;; abc --> abc
  ;; self.def -> (slot-value self 'def)
  ;; self.def.ghi (slot-value (slot-values self 'def) 'ghi)
  ;; self.def(ghi) -> ((slot-value abc 'def) ghi)
  ;; self.def(ghi).L -> *illegal for now* -> (slot-value ((slot-value abc 'def) ghi) 'L)
  ;; self.ensure-input-pin-not-declared(name) -> ((slot-value self 'ensure-input-pin-not-declared) name)
  (let ((e (stack-dsl:%top (cl-user::output-expression (env p)))))
    (break e))) ;; this causes an error, but allows inspect of e - OK during early debug


(defmethod set-current-method ((p parser))
  (setf (current-method p) (scanner:token-text (pasm:accepted-token p))))

(defmethod set-current-class ((p parser))
  (setf (current-class p) (scanner:token-text (pasm:accepted-token p))))

(defmethod $bp ((p parser))
  (break p "forced break"))




;; pass2

(defmethod $esaprogram__BeginScope ((p parser))
  ;; transpile-to-string sets (esaprogram p) to the result of pass1
  (stack-dsl:%push (cl-user::input-esaprogram (env p)) (esaprogram p)))

(defmethod $esaprogram__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-esaprogram (env p))))


(defmethod $whenDeclarations__FromProgram_BeginScope ((p parser))
  (let ((top-esaprogram (stack-dsl:%top (cl-user::input-esaprogram (env p)))))
    (stack-dsl:%push (cl-user::input-whenDeclarations (env p)) (cl-user::whenDeclarations top-esaprogram))))

(defmethod $whenDeclarations__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-whenDeclarations (env p))))

(defmethod $esaclass__LookupByName_BeginScope ((p parser))
  (let ((name (cl-user::as-string (stack-dsl:%top (cl-user::output-name (env p))))))
    (let ((c (cl-user::lookup-class (stack-dsl:%top (cl-user::input-esaprogram (env p))) name)))
      (stack-dsl:%push (cl-user::input-esaclass (env p)) c))
    (stack-dsl:%pop (cl-user::output-name (env p)))))

(defmethod $esaclass__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-esaclass (env p))))







(defun check-stacks (p)
  (let ((i 0))
    (dolist (stack cl-user::*stacks*)
      (let ((name (symbol-name stack)))
	(let ((sym (intern name "CL-USER")))
	  #+nil(let ((wm (cl-user::%water-mark (env p))))
	    (format *standard-output* "~&sym=~a i=~a eq=~a~%" sym i (eq (nth i wm) (stack-dsl::%stack (slot-value (env p) sym)))))
	  (unless (zerop (length (stack-dsl::%stack (slot-value (env p) sym))))
	    (format *standard-output* "~&~a ~a~%" name (length (stack-dsl::%stack (slot-value (env p) sym)))))))
      (incf i))))

