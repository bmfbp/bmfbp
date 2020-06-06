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

;; pass2 class
(defmethod lookup-class ((self pass2) class-name)
  (dolist (c (stack-dsl:%ordered-list (classTable self)))
   ;; c.name.name-as-string
   (when (string= (name-as-string c) class-name)
      (return-from lookup-class c)))
  (error (format nil "class ~a not found in esaprogram" class-name)))

;; pass2 namedClass class
(defmethod name-as-string ((self namedClass))
  (let ((n (name self)))
    (as-string n)))
