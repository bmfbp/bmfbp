(in-package "CL-USER")

(defclass expression (stack-dsl::%typed-value)
((%field-type-object :accessor %field-type-object :initform "object")
(object :accessor object)
(%field-type-ekind :accessor %field-type-ekind :initform "ekind")
(ekind :accessor ekind)
) (:default-initargs :%type "expression"))

(defclass expression-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self expression-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "expression"))


(defclass ekind (stack-dsl::%enum) () (:default-initargs :%type "ekind"))

(defmethod initialize-instance :after ((self ekind) &key &allow-other-keys)
  (setf (stack-dsl::%value-list self) '("object" "false" "true")))


(defclass ekind-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self ekind-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "ekind"))
(defclass object (stack-dsl::%typed-value)
((%field-type-field :accessor %field-type-field :initform "field")
(field :accessor field)
(%field-type-parameterList :accessor %field-type-parameterList :initform "parameterList")
(parameterList :accessor parameterList)
(%field-type-name :accessor %field-type-name :initform "name")
(name :accessor name)
) (:default-initargs :%type "object"))

(defclass object-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self object-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "object"))


(defclass name (stack-dsl::%string) () (:default-initargs :%type "name"))
(defclass name-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self name-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "name"))


(defclass field (stack-dsl::%compound-type) () (:default-initargs :%type "field"))
(defmethod initialize-instance :after ((self field) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("object" "empty")))
(defclass field-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "field"))


(defclass parameterList (stack-dsl::%compound-type) () (:default-initargs :%type "parameterList"))
(defmethod initialize-instance :after ((self parameterList) &key &allow-other-keys)
  (setf (stack-dsl::%type-list self) '("nameList" "empty")))
(defclass parameterList-stack (stack-dsl::%typed-stack) () (:default-initargs :%element-type "parameterList"))

(defclass nameList (stack-dsl::%map) () (:default-initargs :%type "nameList"))
(defmethod initialize-instance :after ((self nameList) &key &allow-other-keys)  ;; type for items in map
(setf (stack-dsl::%element-type self) "nameList"))
(defclass nameList-stack(stack-dsl::%typed-stack) ())
 (defmethod initialize-instance :after ((self nameList-stack) &key &allow-other-keys)
(setf (stack-dsl::%element-type self) "nameList"))

(defclass empty (stack-dsl::%null) () (:default-initargs :%type "empty"))
(defclass empty-stack (stack-dsl::%typed-stack) ())
(defmethod initialize-instance :after ((self empty-stack) &key &allow-other-keys)
  (setf (stack-dsl::%element-type self) "empty"))



;; check forward types
(stack-dsl::%ensure-existence 'expression)
(stack-dsl::%ensure-existence 'ekind)
(stack-dsl::%ensure-existence 'object)
(stack-dsl::%ensure-existence 'name)
(stack-dsl::%ensure-existence 'parameterList)
(stack-dsl::%ensure-existence 'field)
(stack-dsl::%ensure-existence 'empty)
(stack-dsl::%ensure-existence 'nameList)

(defclass environment ()
((%water-mark :accessor %water-mark :initform nil)
(input-expression :accessor input-expression :initform (make-instance 'expression-stack))
(output-expression :accessor output-expression :initform (make-instance 'expression-stack))
(input-ekind :accessor input-ekind :initform (make-instance 'ekind-stack))
(output-ekind :accessor output-ekind :initform (make-instance 'ekind-stack))
(input-object :accessor input-object :initform (make-instance 'object-stack))
(output-object :accessor output-object :initform (make-instance 'object-stack))
(input-name :accessor input-name :initform (make-instance 'name-stack))
(output-name :accessor output-name :initform (make-instance 'name-stack))
(input-parameterList :accessor input-parameterList :initform (make-instance 'parameterList-stack))
(output-parameterList :accessor output-parameterList :initform (make-instance 'parameterList-stack))
(input-field :accessor input-field :initform (make-instance 'field-stack))
(output-field :accessor output-field :initform (make-instance 'field-stack))
(input-empty :accessor input-empty :initform (make-instance 'empty-stack))
(output-empty :accessor output-empty :initform (make-instance 'empty-stack))
(input-nameList :accessor input-nameList :initform (make-instance 'nameList-stack))
(output-nameList :accessor output-nameList :initform (make-instance 'nameList-stack))
))

(defmethod %memoStacks ((self environment))
(setf (%water-mark self)
(list
(input-expression self)
(output-expression self)
(input-ekind self)
(output-ekind self)
(input-object self)
(output-object self)
(input-name self)
(output-name self)
(input-parameterList self)
(output-parameterList self)
(input-field self)
(output-field self)
(input-empty self)
(output-empty self)
(input-nameList self)
(output-nameList self)
)))

(defmethod %memoCheck ((self environment))
(let ((wm (%water-mark self)))
(unless (and
(eq (nth 0 wm) (input-expression self))
(eq (nth 1 wm) (output-expression self))
(eq (nth 2 wm) (input-ekind self))
(eq (nth 3 wm) (output-ekind self))
(eq (nth 4 wm) (input-object self))
(eq (nth 5 wm) (output-object self))
(eq (nth 6 wm) (input-name self))
(eq (nth 7 wm) (output-name self))
(eq (nth 8 wm) (input-parameterList self))
(eq (nth 9 wm) (output-parameterList self))
(eq (nth 10 wm) (input-field self))
(eq (nth 11 wm) (output-field self))
(eq (nth 12 wm) (input-empty self))
(eq (nth 13 wm) (output-empty self))
(eq (nth 14 wm) (input-nameList self))
(eq (nth 15 wm) (output-nameList self))
))
(error "stack depth incorrect")))
