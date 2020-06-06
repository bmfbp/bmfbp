(defmethod $$method__CheckThatMethodExistsInNamedClass ((p parser))
  ;; niy
  )

(defmethod $$method__CheckFormals ((p parser))
  ;; niy
  )

(defmethod $$method__CheckReturnType((p parser))
  ;; niy
  )


(defmethod $$method__LookupBeginScope ((p parser))
  ;; lookup named class in pass2 table and push the class onto the namedClass input stack
  (let ((c (lookup-class (pass2 (env p)))))
    (stack-dsl:%push (namedClass (env p)) c)))

(defmethod $$method__EndScope ((p parser))
  ;; pop namedClass input stack
  (stack-dsl:%pop (namedClass (env p))))
