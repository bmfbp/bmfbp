(proclaim '(optimize (debug 3) (safety 3) (speed 0)))(in-package "CL-USER")

(defclass typeDecls (stack-dsl::%map) () (:default-initargs :%type "typeDecls"))
(defmethod initialize-instance :after ((self typeDecls) &key &allow-other-keys)  ;; type for items in map
  (setf (stack-dsl::%element-type self) "typeDecl"))
(defclass typeDecls-stack(stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self typeDecls-stack) &key &allow-other-keys)
    (setf (stack-dsl::%element-type self) "typeDecls"))


(stack-dsl::%ensure-existence 'typeDecls)

(defclass %map-stack (stack-dsl::%typed-stack) ())
(defclass %bag-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self %map-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "%map"))(defmethod initialize-instance :after ((self %bag-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "%bag"))

(defclass environment ()
((%water-mark :accessor %water-mark :initform nil)
(input-typeDecls :accessor input-typeDecls :initform (make-instance 'typeDecls))
(output-typeDecls :accessor output-typeDecls :initform (make-instance 'typeDecls))
))

(defmethod %memoStacks ((self environment))
(setf (%water-mark self)
(list
(stack-dsl::%stack (input-typeDecls self))
(stack-dsl::%stack (output-typeDecls self))

)))
  

(defparameter *stacks* '(
input-typeDecls
output-typeDecls

))  

(defmethod %memoCheck ((self environment))
 (let ((wm (%water-mark self)))
  (let ((r (and
	   
(let ((in-eq (eq (nth 0 wm) (stack-dsl::%stack (input-typeDecls self))))
      (out-eq (eq (nth 1 wm) (stack-dsl::%stack (output-typeDecls self)))))
  (and in-eq out-eq)))))
   (unless r (error "stack depth incorrect")))))
