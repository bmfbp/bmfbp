;; methods + lookups during code emission
(defmethod $expression__IgnoreInPass1 ((p parser))
  (stack-dsl:%pop (cl-user::output-expression (env p))))

(defmethod $expression__OverwriteField_from_ekind ((p parser))
  ;; reset field kind of TOs(output-expression)
  (setf (cl-user::ekind (stack-dsl:%top (cl-user::output-expression (env p))))
	(stack-dsl:%top (cl-user::output-ekind (env p))))
  (stack-dsl:%pop (cl-user::output-ekind (env p))))





(defmethod $scriptsTable__BeginScopeFrom_esaclass ((p parser))
  (let ((top-class (stack-dsl:%top (cl-user::input-esaclass (env p)))))
    (let ((stable (cl-user::scriptsTable top-class)))
      (stack-dsl:%push (cl-user::input-scriptsTable (env p)) stable))))

(defmethod $scriptsTable__EndScope ((p parser))
  (stack-dsl:%pop p (cl-user::scriptsTable (env p))))

(defmethod $scriptsTable__AppendFrom_internalMethod ((p parser))
  (let ((top-scriptsTable (stack-dsl:%top (cl-user::input-scriptsTable (env p)))))
    (let ((top-internalMethod (stack-dsl:%top (cl-user::output-internalMethod (env p)))))
      (stack-dsl:%ensure-appendable-type top-scriptsTable)
      (stack-dsl:%append top-scriptsTable top-internalMethod)
      (stack-dsl:%pop (cl-user::output-internalMethod (env p))))))


(defmethod $methodsTable__BeginScopeFrom_esaclass ((p parser))
  (let ((top-class (stack-dsl:%top (cl-user::input-esaclass (env p)))))
    (let ((mtable (cl-user::methodsTable top-class)))
      (stack-dsl:%push (cl-user::input-methodsTable (env p)) mtable))))


(defmethod $methodsTable__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-methodsTable (env p))))

(defmethod $methodsTable__AppendFrom_externalMethod ((p parser))
  (let ((top-methodsTable (stack-dsl:%top (cl-user::input-methodsTable (env p)))))
    (let ((top-externalMethod (stack-dsl:%top (cl-user::output-externalMethod (env p)))))
      (stack-dsl:%ensure-appendable-type top-methodsTable)
      (stack-dsl:%append top-methodsTable top-externalMethod)
      (stack-dsl:%pop (cl-user::output-externalMethod (env p))))))
