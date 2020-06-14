(in-package :cl-user)

;; name class

(defmethod as-string ((self name))
  (stack-dsl::%value self))

;; esaclass class
(defmethod name-as-string ((self esaclass))
  (as-string (name self)))
  
;; esaprogram class
(defmethod lookup-class ((self esaprogram) class-name)
  (lookup-class (classes self) class-name))

(defmethod lookup-class ((self cl-user::classes) class-name)
  (dolist (esa-c (stack-dsl:%ordered-list self))
    (when (string= (name-as-string esa-c) class-name)
      (return-from lookup-class esa-c)))
  (error (format nil "class ~a not found in esaprogram" class-name)))

(defmethod name-as-string ((self methodDeclaration))
  (as-string (name self)))

(defmethod name-as-string ((self scriptDeclaration))
  (as-string (name self)))

(defmethod as-list ((self methodDeclarationsAndScriptDeclarations))
  (stack-dsl::%ordered-list self))

(defmethod as-list ((self whenDeclarations))
  (stack-dsl::%ordered-list self))

(defmethod lookup-method ((self stack-dsl::%map) method-name)
  ;; lookup method or script from methodsTable (a %map)
  (dolist (s (stack-dsl:%ordered-list self))
    (when (string= (name-as-string s) method-name)
      (return-from lookup-method s)))
  (error (format nil "no script named ~a" script-name)))
  
(defmethod implementation-empty-p ((self cl-user::scriptDeclaration))
  (stack-dsl:%empty-p (cl-user::implementation self)))

#+nil(defmethod implementation-empty-p ((self T)
  nil))
