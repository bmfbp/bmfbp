(in-package :arrowgrams/esa)(defclass part-definition ()
((part-name :accessor part-name :initform nil)
(part-kind :accessor part-kind :initform nil)
))
(defclass named-part-instance ()
((instance-name :accessor instance-name :initform nil)
(instance-node :accessor instance-node :initform nil)
))
(defclass part-pin ()
((part-name :accessor part-name :initform nil)
(pin-name :accessor pin-name :initform nil)
))
(defclass source ()
((part-name :accessor part-name :initform nil)
(pin-name :accessor pin-name :initform nil)
))
(defclass destination ()
((part-name :accessor part-name :initform nil)
(pin-name :accessor pin-name :initform nil)
))
(defclass wire ()
((index :accessor index :initform nil)
))
(defclass kind ()
((kind-name :accessor kind-name :initform nil)
(input-pins :accessor input-pins :initform nil)
(self-class :accessor self-class :initform nil)
(output-pins :accessor output-pins :initform nil)
(parts :accessor parts :initform nil)
(wires :accessor wires :initform nil)
))
(defclass node ()
((input-queue :accessor input-queue :initform nil)
(output-queue :accessor output-queue :initform nil)
(kind-field :accessor kind-field :initform nil)
(container :accessor container :initform nil)
(name-in-container :accessor name-in-container :initform nil)
(children :accessor children :initform nil)
(busy-flag :accessor busy-flag :initform nil)
))
(defclass dispatcher ()
((top-node :accessor top-node :initform nil)
))
(defclass event ()
((partpin :accessor partpin :initform nil)
(data :accessor data :initform nil)
))

(defmethod add-input-pin #|script|# ((self kind) name )


)#|end script|#

(defmethod add-output-pin #|script|# ((self kind) name )


)#|end script|#

(defmethod add-part #|script|# ((self kind) nm  k  nclass )


)#|end script|#

(defmethod add-wire #|script|# ((self kind) w )
(block map (dolist (s )

))#|end map|#
(block map (dolist (dest )

))#|end map|#

)#|end script|#

(defmethod ensure-valid-source #|script|# ((self kind) s )
(cond ((esa-expr-true ))


(t  ;else
(let ((p ))


)#|end let|#
)#|end else|#
)#|end if|#
)#|end script|#

(defmethod ensure-valid-destination #|script|# ((self kind) dest )
(cond ((esa-expr-true ))


(t  ;else
(let ((p ))


)#|end let|#
)#|end else|#
)#|end if|#
)#|end script|#

(defmethod add-source #|script|# ((self wire) part  pin )

)#|end script|#

(defmethod add-destination #|script|# ((self wire) part  pin )

)#|end script|#

(defmethod loader #|script|# ((self kind) my-name  my-container  dispatchr )
(let ((clss ))
(let ((inst (make-instance clss)))


(setf )
(setf )
(setf )
(block map (dolist (part )
(let ((part-instance ))

)#|end let|#
))#|end map|#

(return-from loader inst)
)#|end create|#
)#|end let|#
)#|end script|#

(defmethod add-child #|script|# ((self node) nm  nd )

)#|end script|#

(defmethod initialize-all #|script|# ((self dispatcher))
(block map (dolist (part )

))#|end map|#
)#|end script|#

(defmethod initialize #|script|# ((self node))

)#|end script|#

(defmethod ? #|script|# ((self node))
(cond ((esa-expr-true ))
(return-from ? :true)

(t  ;else
(block map (dolist (child-part-instance )
(let ((child-node ))
(cond ((esa-expr-true ))
(return-from ? :true)

(t  ;else
(cond ((esa-expr-true ))
(return-from ? :true)
)#|end if|#
)#|end else|#
)#|end if|#
)#|end let|#
))#|end map|#
)#|end else|#
)#|end if|#
(return-from ? :false)
)#|end script|#

(defmethod start #|script|# ((self dispatcher))


)#|end script|#

(defmethod run #|script|# ((self dispatcher))
(let ((done ))
(loop
(setf )

(block map (dolist (part )
(cond ((esa-expr-true ))

(setf )
(return-from map nil)
)#|end if|#
))#|end map|#
(when (esa-expr-true ) (return))
)#|end loop|#
)#|end let|#

)#|end script|#

(defmethod invoke #|script|# ((self node))
(let ((e ))


)#|end let|#
)#|end script|#

(defmethod ? #|script|# ((self node))
(cond ((esa-expr-true ))
(cond ((esa-expr-true ))
(return-from ? :false)

(t  ;else
(return-from ? :true)
)#|end else|#
)#|end if|#
)#|end if|#
(return-from ? :false)
)#|end script|#

(defmethod distribute-all-outputs #|script|# ((self dispatcher))
(block map (dolist (p )


))#|end map|#
)#|end script|#

(defmethod distribute-outputs-upwards #|script|# ((self node))
(cond ((esa-expr-true ))

(t  ;else
(let ((parent ))

)#|end let|#
)#|end else|#
)#|end if|#
)#|end script|#

(defmethod distribute-output-events #|script|# ((self node))
(cond ((esa-expr-true ))


(t  ;else
(let ((parent-composite-node ))
(block map (dolist (output )
(let ((dest ))
(let ((w ))
(block map (dolist (dest )
(cond ((esa-expr-true ))
(let ((new-event (make-instance event)))
(let ((pp (make-instance part-pin)))
(setf )
(setf )
(setf )
(setf )

)#|end create|#
)#|end create|#

(t  ;else
(let ((new-event (make-instance event)))
(let ((pp (make-instance part-pin)))
(setf )
(setf )
(setf )
(setf )
(let ((child-part-instance ))

)#|end let|#
)#|end create|#
)#|end create|#
)#|end else|#
)#|end if|#
))#|end map|#
)#|end let|#
)#|end let|#
))#|end map|#
)#|end let|#
)#|end else|#
)#|end if|#
)#|end script|#

(defmethod run-reaction #|script|# ((self node) e )

)#|end script|#

(defmethod run-composite-reaction #|script|# ((self node) e )
(let ((w ))
(cond ((esa-expr-true ))
(setf )

(t  ;else
(setf )
)#|end else|#
)#|end if|#
(block map (dolist (dest )
(let ((new-event (make-instance event)))
(let ((pp (make-instance part-pin)))
(cond ((esa-expr-true ))
(setf )
(setf )
(setf )
(setf )


(t  ;else
(cond ((esa-expr-true ))
(setf )
(setf )
(setf )
(setf )
(let ((child-part-instance ))

)#|end let|#
)#|end if|#
)#|end else|#
)#|end if|#
)#|end create|#
)#|end create|#
))#|end map|#
)#|end let|#
)#|end script|#
