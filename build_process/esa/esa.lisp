(in-package :arrowgrams/build)

(defclass part-definition ()
(
(part-name :accessor part-name :initform nil)
(part-kind :accessor part-kind :initform nil)))
#| external method ((self part-definition)) ensure-kind-defined |#

(defclass named-part-instance ()
(
(instance-name :accessor instance-name :initform nil)
(instance-node :accessor instance-node :initform nil)))

(defclass part-pin ()
(
(part-name :accessor part-name :initform nil)
(pin-name :accessor pin-name :initform nil)))

(defclass source ()
(
(part-name :accessor part-name :initform nil)
(pin-name :accessor pin-name :initform nil)))
#| external method ((self source)) refers-to-self? |#

(defclass destination ()
(
(part-name :accessor part-name :initform nil)
(pin-name :accessor pin-name :initform nil)))
#| external method ((self destination)) refers-to-self? |#

(defclass wire ()
(
(index :accessor index :initform nil)
(sources :accessor sources :initform nil)
(destinations :accessor destinations :initform nil)))
#| external method ((self wire)) install-source |#
#| external method ((self wire)) install-destination |#
(defmethod add-source ((self wire) part pin)
        install-source (self, part, pin))
(defmethod add-destination ((self wire) part pin)
        install-destination (self, part, pin))

(defclass kind ()
(
(kind-name :accessor kind-name :initform nil)
(input-pins :accessor input-pins :initform nil)
(self-class :accessor self-class :initform nil)
(output-pins :accessor output-pins :initform nil)
(parts :accessor parts :initform nil)
(wires :accessor wires :initform nil)))
#| external method ((self kind)) install-input-pin |#
#| external method ((self kind)) install-output-pin |#
(defmethod add-input-pin ((self kind) name)
        ensure-input-pin-not-declared (self, name)
        install-input-pin (self, name))
(defmethod add-output-pin ((self kind) name)
        ensure-output-pin-not-declared (self, name)
        install-output-pin (self, name))
(defmethod add-part ((self kind) nm k nclass)
        ensure-part-not-declared (self, nm)
        install-part (self, nm, k, nclass))
(defmethod add-wire ((self kind) w)
        (block %map (dolist (s sources) 
ensure-valid-source (self, s)))
        (block %map (dolist (dest destinations) 
ensure-valid-destination (self, dest)))
        install-wire (self, w))
#| external method ((self kind)) install-wire |#
#| external method ((self kind)) install-part |#
#| external method ((self kind)) parts |#
#| external method ((self kind)) install-class |#
#| external method ((self kind)) ensure-part-not-declared |#
#| external method ((self kind)) ensure-valid-input-pin |#
#| external method ((self kind)) ensure-valid-output-pin |#
#| external method ((self kind)) ensure-input-pin-not-declared |#
#| external method ((self kind)) ensure-output-pin-not-declared |#
(defmethod ensure-valid-source ((self kind) s)
        (if (esa-expr-true refers-to-self?)
(progn
ensure-valid-input-pin (self, pin-name)
)
(progn
(let ((p kind-find-part (self, part-name))) 
ensure-kind-defined
ensure-valid-output-pin (part-kind, pin-name))
)))
(defmethod ensure-valid-destination ((self kind) dest)
        (if (esa-expr-true refers-to-self?)
(progn
ensure-valid-output-pin (self, pin-name)
)
(progn
(let ((p kind-find-part (self, part-name))) 
ensure-kind-defined
ensure-valid-input-pin (part-kind, pin-name))
)))
(defmethod loader ((self kind) my-name my-container dispatchr)
        (let ((clss self-class)) 
(let ((inst (make-instance clss)))
clear-input-queue
clear-output-queue
(setf kind-field self)
(setf container my-container)
(setf name-in-container my-name)
(block %map (dolist (part parts) 
(let ((part-instance loader (part-kind, part-name, inst, dispatchr))) 
add-child (inst, part-name, part-instance))))
memo-node (dispatchr, inst)
(return-from loader inst))))
#| external method ((self kind)) find-wire-for-source |#
#| external method ((self kind)) find-wire-for-self-source |#

(defclass node ()
(
(input-queue :accessor input-queue :initform nil)
(output-queue :accessor output-queue :initform nil)
(kind-field :accessor kind-field :initform nil)
(container :accessor container :initform nil)
(name-in-container :accessor name-in-container :initform nil)
(children :accessor children :initform nil)
(busy-flag :accessor busy-flag :initform nil)))
#| external method ((self node)) clear-input-queue |#
#| external method ((self node)) clear-output-queue |#
#| external method ((self node)) install-node |#
(defmethod add-child ((self node) nm nd)
        install-child (self, nm, nd))
(defmethod initialize ((self node) )
        initially)
#| external method ((self node)) initially |#
#| external method ((self node)) send |#
(defmethod distribute-output-events ((self node) )
        (if (esa-expr-true has-no-container?)
(progn
display-output-events-to-console-and-delete
)
(progn
(let ((parent-composite-node container)) 
(block %map (dolist (output get-output-events-and-delete) 
(let ((dest partpin)) 
(let ((w find-wire-for-source (kind-field, part-name, pin-name))) 
(block %map (dolist (dest destinations) 
(if (esa-expr-true refers-to-self?)
(progn
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(setf part-name name-in-container)
(setf pin-name pin-name)
(setf partpin pp)
(setf data data)
send (parent-composite-node, new-event)))
)
(progn
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(setf part-name part-name)
(setf pin-name pin-name)
(setf partpin pp)
(setf data data)
(let ((child-part-instance node-find-child (parent-composite-node, part-name))) 
enqueue-input (instance-node, new-event))))
)))))))))
)))
#| external method ((self node)) display-output-events-to-console-and-delete |#
#| external method ((self node)) get-output-events-and-delete |#
#| external method ((self node)) has-no-container? |#
(defmethod distribute-outputs-upwards ((self node) )
        (if (esa-expr-true has-no-container?)
(progn
)
(progn
(let ((parent container)) 
distribute-output-events)
)))
(defmethod busy? ((self node) )
        (if (esa-expr-true flagged-as-busy?)
(progn
(return-from busy? :true)
)
(progn
(block %map (dolist (child-part-instance children) 
(let ((child-node instance-node)) 
(if (esa-expr-true has-inputs-or-outputs?)
(progn
(return-from busy? :true)
)
(progn
(when (esa-expr-true busy?)
(return-from busy? :true)
)
)))))
))
        (return-from busy? :false))
(defmethod ready? ((self node) )
        (when (esa-expr-true input-queue?)
(if (esa-expr-true busy?)
(progn
(return-from ready? :false)
)
(progn
(return-from ready? :true)
))
)
        (return-from ready? :false))
(defmethod invoke ((self node) )
        (let ((e dequeue-input)) 
run-reaction (self, e)
distribute-output-events))
#| external method ((self node)) has-inputs-or-outputs? |#
#| external method ((self node)) children? |#
#| external method ((self node)) flagged-as-busy? |#
#| external method ((self node)) dequeue-input |#
#| external method ((self node)) input-queue? |#
#| external method ((self node)) enqueue-input |#
#| external method ((self node)) enqueue-output |#
#| external method ((self node)) react |#
(defmethod run-reaction ((self node) e)
        react (self, e))
(defmethod run-composite-reaction ((self node) e)
        (let ((w :true)) 
(if (esa-expr-true has-no-container?)
(progn
(setf w find-wire-for-self-source (kind-field, pin-name))
)
(progn
(setf w find-wire-for-source (kind-field, part-name, pin-name))
))
(block %map (dolist (dest destinations) 
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(if (esa-expr-true refers-to-self?)
(progn
(setf part-name part-name)
(setf pin-name pin-name)
(setf partpin pp)
(setf data data)
send (self, new-event)
)
(progn
(when (esa-expr-true children?)
(setf part-name part-name)
(setf pin-name pin-name)
(setf partpin pp)
(setf data data)
(let ((child-part-instance node-find-child (self, part-name))) 
enqueue-input (instance-node, new-event))
)
))))))))
#| external method ((self node)) node-find-child |#

(defclass dispatcher ()
(
(all-parts :accessor all-parts :initform nil)
(top-node :accessor top-node :initform nil)))
#| external method ((self dispatcher)) memo-node |#
#| external method ((self dispatcher)) set-top-node |#
(defmethod initialize-all ((self dispatcher) )
        (block %map (dolist (part all-parts) 
initialize)))
(defmethod distribute-all-outputs ((self dispatcher) )
        (block %map (dolist (p all-parts) 
distribute-output-events
distribute-outputs-upwards)))
(defmethod dispatcher-run ((self dispatcher) )
        (let ((done :true)) 
(loop 
(setf done :true)
distribute-all-outputs
(block %map (dolist (part all-parts) 
(when (esa-expr-true ready?)
invoke
(setf done :false)
(return-from %map :false)
)))
(when (esa-expr-true done) (return)))))
(defmethod dispatcher-inject ((self dispatcher) pin val)
        (let ((e create-top-event (self, pin, val))) 
enqueue-input (top-node, e)
dispatcher-run))
#| external method ((self dispatcher)) create-top-event |#

(defclass event ()
(
(partpin :accessor partpin :initform nil)
(data :accessor data :initform nil)))
