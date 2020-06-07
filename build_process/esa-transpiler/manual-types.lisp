(in-package :cl-user)

;; name class

(defmethod as-string ((self name))
  (stack-dsl::%value self))

;; esaclass class
(defmethod name-as-string ((self esaclass))
  (as-string (name self)))
  
;; esaprogram class
(defmethod lookup-class ((self esaprogram) class-name)
  (dolist (c (stack-dsl:%ordered-list (classes self)))
    (when (string= (name-as-string c) class-name)
      (return-from lookup-class c)))
  (error (format nil "class ~a not found in esaprogram" class-name)))

