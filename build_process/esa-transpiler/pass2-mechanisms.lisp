(in-package :arrowgrams/esa-transpiler)

(defmethod $esamethod__CheckThatMethodExistsInNamedClass ((p parser))
  ;; niy
  )

(defmethod $esamethod__CheckFormals ((p parser))
  ;; niy
  )

(defmethod $esamethod__CheckReturnType((p parser))
  ;; niy
  )

(defmethod $namedClass__LookupBeginScope ((p parser))
  ;; lookup named class in pass2 table and push the class onto the namedClass input stack
  (let ((class-name (cl-user::as-string 
		     (stack-dsl:%top (cl-user::output-name (env p))))))
    (let ((c (cl-user::lookup-class 
	      (stack-dsl:%top (cl-user::input-pass2 (env p)))
	      class-name)))
      (stack-dsl:%push (cl-user::input-namedClass (env p)) c)))
  (stack-dsl:%pop (cl-user::output-name (env p))))

(defmethod $namedClass__EndScope ((p parser))
  ;; pop namedClass input stack
  (stack-dsl:%pop (cl-user::input-namedClass (env p))))

;; pass2 mechanisms
(defmethod $methodsList__BeginScopeFrom_namedClass ((p parser))
  (let ((top-class (stack-dsl:%top (cl-user::input-namedClass (env p)))))
    (stack-dsl:%push (cl-user::input-methodsList (env p))
		     (cl-user::get-methods-list top-class))))

(defmethod $methodsList__EndScope ((p parser))
  (stack-dsl:%pop (cl-user::input-methodsList (env p))))
