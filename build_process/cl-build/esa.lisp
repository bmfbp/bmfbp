(in-package :arrowgrams/build)(defclass part-definition ()
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
(sources :accessor sources :initform nil)(destinations :accessor destinations :initform nil)))
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
((all-parts :accessor all-parts :initform nil)(top-node :accessor top-node :initform nil)
))
(defclass event ()
((partpin :accessor partpin :initform nil)
(data :accessor data :initform nil)
))

(defgeneric install-input-pin (self G11618))
(defgeneric install-output-pin (self G11619))
(defgeneric add-input-pin #|script|# (self G11620))
(defgeneric add-output-pin #|script|# (self G11621))
(defgeneric add-part #|script|# (self G11622 G11623 G11624))
(defgeneric add-wire #|script|# (self G11625))
(defgeneric install-wire (self G11626))
(defgeneric install-part (self G11627 G11628 G11629))
(defgeneric parts (self) #|returns map part-definition|# )


(defgeneric install-class (self G11630))
(defgeneric ensure-part-not-declared (self G11631))
(defgeneric ensure-valid-input-pin (self G11632))
(defgeneric ensure-valid-output-pin (self G11633))
(defgeneric ensure-input-pin-not-declared (self G11634))
(defgeneric ensure-output-pin-not-declared (self G11635))
(defgeneric ensure-valid-source #|script|# (self G11636))
(defgeneric ensure-valid-destination #|script|# (self G11637))


(defgeneric ensure-kind-defined (self))


(defmethod add-input-pin #|script|# ((self kind) name )
( ensure-input-pin-not-declared self  name )
( install-input-pin self  name )
)#|end script|#

(defmethod add-output-pin #|script|# ((self kind) name )
( ensure-output-pin-not-declared self  name )
( install-output-pin self  name )
)#|end script|#

(defmethod add-part #|script|# ((self kind) nm  k  nclass )
( ensure-part-not-declared self  nm )
( install-part self  nm  k  nclass )
)#|end script|#

(defmethod add-wire #|script|# ((self kind) w )
(block map (dolist (s ( sources w))
( ensure-valid-source self  s )
))#|end map|#
(block map (dolist (dest ( destinations w))
( ensure-valid-destination self  dest )
))#|end map|#
( install-wire self  w )
)#|end script|#

(defmethod ensure-valid-source #|script|# ((self kind) s )
(cond ((esa-expr-true ( refers-to-self? s))
( ensure-valid-input-pin self ( pin-name s) )
)
(t  ;else
(let ((p ( kind-find-part self ( part-name s) )))
( ensure-kind-defined p)
( ensure-valid-output-pin( part-kind p) ( pin-name s) )
)#|end let|#
)#|end else|#
)#|end if|#
)#|end script|#

(defmethod ensure-valid-destination #|script|# ((self kind) dest )
(cond ((esa-expr-true ( refers-to-self? dest))
( ensure-valid-output-pin self ( pin-name dest) )
)
(t  ;else
(let ((p ( kind-find-part self ( part-name dest) )))
( ensure-kind-defined p)
( ensure-valid-input-pin( part-kind p) ( pin-name dest) )
)#|end let|#
)#|end else|#
)#|end if|#
)#|end script|#

(defgeneric refers-to-self? (self) #|returns boolean|# )


(defgeneric refers-to-self? (self) #|returns boolean|# )


(defgeneric install-source (self G11638 G11639))
(defgeneric install-destination (self G11640 G11641))


(defmethod add-source #|script|# ((self wire) part  pin )
( install-source self  part  pin )
)#|end script|#

(defmethod add-destination #|script|# ((self wire) part  pin )
( install-destination self  part  pin )
)#|end script|#

(defgeneric loader #|script|# (self G11642 G11643 G11644) #|returns node|# )


(defgeneric clear-input-queue (self))
(defgeneric clear-output-queue (self))
(defgeneric install-node (self G11645))
(defgeneric add-child #|script|# (self G11646 G11647))


(defmethod loader #|script|# ((self kind) my-name  my-container  dispatchr )
(let ((clss ( self-class self)))
(let ((inst (make-instance clss)))
( clear-input-queue inst)
( clear-output-queue inst)
(setf ( kind-field inst) self)
(setf ( container inst) my-container)
(setf ( name-in-container inst) my-name)
(block map (dolist (part ( parts self))
(let ((part-instance ( loader( part-kind part) ( part-name part)  inst  dispatchr )))
( add-child inst ( part-name part)  part-instance )
)#|end let|#
))#|end map|#
( memo-node dispatchr  inst )
(return-from loader inst)
)#|end create|#
)#|end let|#
)#|end script|#

(defgeneric memo-node (self G11648))
(defgeneric set-top-node (self G11649))


(defmethod add-child #|script|# ((self node) nm  nd )
( install-child self  nm  nd )
)#|end script|#

(defgeneric initialize-all #|script|# (self))


(defmethod initialize-all #|script|# ((self dispatcher))
(block map (dolist (part ( all-parts self))
( initialize part)
))#|end map|#
)#|end script|#

(defgeneric initialize #|script|# (self))
(defgeneric initially (self))


(defmethod initialize #|script|# ((self node))
( initially self)
)#|end script|#

(defgeneric send (self G11650))
(defgeneric distribute-output-events #|script|# (self))
(defgeneric display-output-events-to-console-and-delete (self))
(defgeneric get-output-events-and-delete (self) #|returns map event|# )
(defgeneric has-no-container? (self) #|returns boolean|# )
(defgeneric distribute-outputs-upwards #|script|# (self))


(defgeneric start #|script|# (self))
(defgeneric distribute-all-outputs #|script|# (self))
(defgeneric run #|script|# (self))
(defgeneric declare-finished (self))


(defgeneric find-wire-for-source (self G11651 G11652) #|returns wire|# )
(defgeneric find-wire-for-self-source (self G11653) #|returns wire|# )


(defgeneric busy? #|script|# (self))
(defgeneric ready? #|script|# (self))
(defgeneric has-inputs-or-outputs? (self) #|returns boolean|# )
(defgeneric children? (self) #|returns boolean|# )
(defgeneric flagged-as-busy? (self) #|returns boolean|# )
(defgeneric dequeue-input (self))
(defgeneric input-queue? (self))
(defgeneric enqueue-input (self G11654))
(defgeneric enqueue-output (self G11655))
(defgeneric react (self G11656))
(defgeneric run-reaction #|script|# (self G11657))
(defgeneric run-composite-reaction #|script|# (self G11658))
(defgeneric node-find-child (self G11659) #|returns named-part-instance|# )


(defmethod busy? #|script|# ((self node))
(cond ((esa-expr-true ( flagged-as-busy? self))
(return-from busy? :true)
)
(t  ;else
(block map (dolist (child-part-instance ( children self))
(let ((child-node ( instance-node child-part-instance)))
(cond ((esa-expr-true ( has-inputs-or-outputs? child-node))
(return-from busy? :true)
)
(t  ;else
(cond ((esa-expr-true ( busy? child-node))
(return-from busy? :true)
))#|end if|#
)#|end else|#
)#|end if|#
)#|end let|#
))#|end map|#
)#|end else|#
)#|end if|#
(return-from busy? :false)
)#|end script|#

(defmethod start #|script|# ((self dispatcher))
( distribute-all-outputs self)
( run self)
)#|end script|#

(defmethod run #|script|# ((self dispatcher))
(let ((done  :true))
(loop
(setf  done :true)
( distribute-all-outputs self)
(block map (dolist (part ( all-parts self))
(cond ((esa-expr-true ( ready? part))
( invoke part)
(setf  done :false)
(return-from map nil)
))#|end if|#
))#|end map|#
(when (esa-expr-true  done) (return))
)#|end loop|#
)#|end let|#
( declare-finished self)
)#|end script|#

(defmethod invoke #|script|# ((self node))
(let ((e ( dequeue-input self)))
( run-reaction self  e )
( distribute-output-events self)
)#|end let|#
)#|end script|#

(defmethod ready? #|script|# ((self node))
(cond ((esa-expr-true ( input-queue? self))
(cond ((esa-expr-true ( busy? self))
(return-from ready? :false)
)
(t  ;else
(return-from ready? :true)
)#|end else|#
)#|end if|#
))#|end if|#
(return-from ready? :false)
)#|end script|#

(defmethod distribute-all-outputs #|script|# ((self dispatcher))
(block map (dolist (p ( all-parts self))
( distribute-output-events p)
( distribute-outputs-upwards p)
))#|end map|#
)#|end script|#

(defmethod distribute-outputs-upwards #|script|# ((self node))
(cond ((esa-expr-true ( has-no-container? self))
)
(t  ;else
(let ((parent ( container self)))
( distribute-output-events parent)
)#|end let|#
)#|end else|#
)#|end if|#
)#|end script|#

(defmethod distribute-output-events #|script|# ((self node))
(cond ((esa-expr-true ( has-no-container? self))
( display-output-events-to-console-and-delete self)
)
(t  ;else
(let ((parent-composite-node ( container self)))
(block map (dolist (output ( get-output-events-and-delete self))
(let ((dest ( partpin output)))
(let ((w ( find-wire-for-source( kind-field parent-composite-node) ( part-name( partpin output)) ( pin-name( partpin output)) )))
(block map (dolist (dest ( destinations w))
(cond ((esa-expr-true ( refers-to-self? dest))
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(setf ( part-name pp)( name-in-container parent-composite-node))
(setf ( pin-name pp)( pin-name dest))
(setf ( partpin new-event) pp)
(setf ( data new-event)( data output))
( send parent-composite-node  new-event )
)#|end create|#
)#|end create|#
)
(t  ;else
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(setf ( part-name pp)( part-name dest))
(setf ( pin-name pp)( pin-name dest))
(setf ( partpin new-event) pp)
(setf ( data new-event)( data output))
(let ((child-part-instance ( node-find-child parent-composite-node ( part-name pp) )))
( enqueue-input( instance-node child-part-instance)  new-event )
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
( react self  e )
)#|end script|#

(defmethod run-composite-reaction #|script|# ((self node) e )
(let ((w  :true))
(cond ((esa-expr-true ( has-no-container? self))
(setf  w( find-wire-for-self-source( kind-field self) ( pin-name( partpin e)) ))
)
(t  ;else
(setf  w( find-wire-for-source( kind-field( container self)) ( part-name( partpin e)) ( pin-name( partpin e)) ))
)#|end else|#
)#|end if|#
(block map (dolist (dest ( destinations w))
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(cond ((esa-expr-true ( refers-to-self? dest))
(setf ( part-name pp)( part-name dest))
(setf ( pin-name pp)( pin-name dest))
(setf ( partpin new-event) pp)
(setf ( data new-event)( data e))
( send self  new-event )
)
(t  ;else
(cond ((esa-expr-true ( children? self))
(setf ( part-name pp)( part-name dest))
(setf ( pin-name pp)( pin-name dest))
(setf ( partpin new-event) pp)
(setf ( data new-event)( data e))
(let ((child-part-instance ( node-find-child self ( part-name dest) )))
( enqueue-input( instance-node child-part-instance)  new-event )
)#|end let|#
))#|end if|#
)#|end else|#
)#|end if|#
)#|end create|#
)#|end create|#
))#|end map|#
)#|end let|#
)#|end script|#
