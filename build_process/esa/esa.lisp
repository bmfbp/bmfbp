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
        (install-source self part pin))
(defmethod add-destination ((self wire) part pin)
        (install-destination self part pin))

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
        (ensure-input-pin-not-declared self name)
        (install-input-pin self name))
(defmethod add-output-pin ((self kind) name)
        (ensure-output-pin-not-declared self name)
        (install-output-pin self name))
(defmethod add-part ((self kind) nm k nclass)
        (ensure-part-not-declared self nm)
        (install-part self nm k nclass))
(defmethod add-wire ((self kind) w)
        (block %map (dolist (s (sources w)) 
(ensure-valid-source self s)))
        (block %map (dolist (dest (destinations w)) 
(ensure-valid-destination self dest)))
        (install-wire self w))
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
        (if (esa-expr-true (refers-to-self? s))
(progn
(ensure-valid-input-pin self (pin-name s))
)
(progn
(let ((p (kind-find-part self (part-name s)))) 
(ensure-kind-defined p)
(ensure-valid-output-pin (part-kind p) (pin-name s)))
)))
(defmethod ensure-valid-destination ((self kind) dest)
        (if (esa-expr-true (refers-to-self? dest))
(progn
(ensure-valid-output-pin self (pin-name dest))
)
(progn
(let ((p (kind-find-part self (part-name dest)))) 
(ensure-kind-defined p)
(ensure-valid-input-pin (part-kind p) (pin-name dest)))
)))
(defmethod loader ((self kind) my-name my-container dispatchr)
        (let ((clss (self-class self))) 
(let ((inst (make-instance clss)))
(clear-input-queue inst)
(clear-output-queue inst)
(setf (kind-field inst) self)
(setf (container inst) my-container)
(setf (name-in-container inst) my-name)
(block %map (dolist (part (parts self)) 
(let ((part-instance (loader (part-kind part) (part-name part) inst dispatchr))) 
(add-child inst (part-name part) part-instance))))
(memo-node dispatchr inst)
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
        (install-child self nm nd))
(defmethod initialize ((self node) )
        (initially self))
#| external method ((self node)) initially |#
#| external method ((self node)) send |#
(defmethod distribute-output-events ((self node) )
        (if (esa-expr-true (has-no-container? self))
(progn
(display-output-events-to-console-and-delete self)
)
(progn
(let ((parent-composite-node (container self))) 
(block %map (dolist (output (get-output-events-and-delete self)) 
(let ((dest (partpin output))) 
(let ((w (find-wire-for-source (kind-field parent-composite-node) (part-name (partpin output)) (pin-name (partpin output))))) 
(block %map (dolist (dest (destinations w)) 
(if (esa-expr-true (refers-to-self? dest))
(progn
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(setf (part-name pp) (name-in-container parent-composite-node))
(setf (pin-name pp) (pin-name dest))
(setf (partpin new-event) pp)
(setf (data new-event) (data output))
(send parent-composite-node new-event)))
)
(progn
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(setf (part-name pp) (part-name dest))
(setf (pin-name pp) (pin-name dest))
(setf (partpin new-event) pp)
(setf (data new-event) (data output))
(let ((child-part-instance (node-find-child parent-composite-node (part-name pp)))) 
(enqueue-input (instance-node child-part-instance) new-event))))
)))))))))
)))
#| external method ((self node)) display-output-events-to-console-and-delete |#
#| external method ((self node)) get-output-events-and-delete |#
#| external method ((self node)) has-no-container? |#
(defmethod distribute-outputs-upwards ((self node) )
        (if (esa-expr-true (has-no-container? self))
(progn
)
(progn
(let ((parent (container self))) 
(distribute-output-events parent))
)))
(defmethod busy? ((self node) )
        (if (esa-expr-true (flagged-as-busy? self))
(progn
(return-from busy? :true)
)
(progn
(block %map (dolist (child-part-instance (children self)) 
(let ((child-node (instance-node child-part-instance))) 
(if (esa-expr-true (has-inputs-or-outputs? child-node))
(progn
(return-from busy? :true)
)
(progn
(when (esa-expr-true (busy? child-node))
(return-from busy? :true)
)
)))))
))
        (return-from busy? :false))
(defmethod ready? ((self node) )
        (when (esa-expr-true (input-queue? self))
(if (esa-expr-true (busy? self))
(progn
(return-from ready? :false)
)
(progn
(return-from ready? :true)
))
)
        (return-from ready? :false))
(defmethod invoke ((self node) )
        (let ((e (dequeue-input self))) 
(run-reaction self e)
(distribute-output-events self)))
#| external method ((self node)) has-inputs-or-outputs? |#
#| external method ((self node)) children? |#
#| external method ((self node)) flagged-as-busy? |#
#| external method ((self node)) dequeue-input |#
#| external method ((self node)) input-queue? |#
#| external method ((self node)) enqueue-input |#
#| external method ((self node)) enqueue-output |#
#| external method ((self node)) react |#
(defmethod run-reaction ((self node) e)
        (react self e))
(defmethod run-composite-reaction ((self node) e)
        (let ((w :true)) 
(if (esa-expr-true (has-no-container? self))
(progn
(setf w (find-wire-for-self-source (kind-field self) (pin-name (partpin e))))
)
(progn
(setf w (find-wire-for-source (kind-field (container self)) (part-name (partpin e)) (pin-name (partpin e))))
))
(block %map (dolist (dest (destinations w)) 
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(if (esa-expr-true (refers-to-self? dest))
(progn
(setf (part-name pp) (part-name dest))
(setf (pin-name pp) (pin-name dest))
(setf (partpin new-event) pp)
(setf (data new-event) (data e))
(send self new-event)
)
(progn
(when (esa-expr-true (children? self))
(setf (part-name pp) (part-name dest))
(setf (pin-name pp) (pin-name dest))
(setf (partpin new-event) pp)
(setf (data new-event) (data e))
(let ((child-part-instance (node-find-child self (part-name dest)))) 
(enqueue-input (instance-node child-part-instance) new-event))
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
        (block %map (dolist (part (all-parts self)) 
(initialize part))))
(defmethod distribute-all-outputs ((self dispatcher) )
        (block %map (dolist (p (all-parts self)) 
(distribute-output-events p)
(distribute-outputs-upwards p))))
(defmethod dispatcher-run ((self dispatcher) )
        (let ((done :true)) 
(loop 
(setf done :true)
(distribute-all-outputs self)
(block %map (dolist (part (all-parts self)) 
(when (esa-expr-true (ready? part))
(invoke part)
(setf done :false)
(return-from %map :false)
)))
(when (esa-expr-true done) (return)))))
(defmethod dispatcher-inject ((self dispatcher) pin val)
        (let ((e (create-top-event self pin val))) 
(enqueue-input (top-node self) e)
(dispatcher-run self)))
#| external method ((self dispatcher)) create-top-event |#

(defclass event ()
(
(partpin :accessor partpin :initform nil)
(data :accessor data :initform nil)))