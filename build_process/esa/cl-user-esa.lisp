(in-package :cl-user)(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

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
(output-pins :accessor output-pins :initform nil)
(self-class :accessor self-class :initform nil)
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
#| external method ((self kind)) install-class |#
#| external method ((self kind)) install-wire |#
#| external method ((self kind)) install-part |#
#| external method ((self kind)) parts |#
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
#| external method ((self kind)) schematicCommonClass |#
#| external method ((self kind)) make-type-name |#
(defmethod read-leaf ((self kind) json-object-part)
        (let ((kindName (kind json-object-part))) 
(let ((filename (filename json-object-part))) 
(setf (self-class self) (make-type-name self kindName))
(make-leaf-input-pins self json-object-part)
(make-leaf-output-pins self json-object-part))))
(defmethod read-schematic ((self kind) app json-object-part)
        (let ((schematicName (name json-object-part))) 
(setf (self-class newKind) (schematicCommonClass self))
(let ((schematic (schematic json-object-part))) 
(make-schematic-input-pins newKind schematic)
(make-schematic-output-pins newKind schematic)
(let ((parts (as-map (parts schematic)))) 
(block %map (dolist (json-child parts) 
(let ((child-kind-name (kindName json-child))) 
(let ((child-name (partName json-child))) 
(let ((child-kind (lookupKind app child-kind-name))) 
(add-part self child-name child-kind)))))))
(let ((json-parts (as-map (wires schematic)))) 
(let ((newWire (make-instance 'wire)))
(block %map (dolist (wire wires) 
(setf (index self) (wireIndex wire))
(let ((sources (as-map (sources wire)))) 
(block %map (dolist (json-source sources) 
(let ((json-src (make-instance 'source)))
(setf (part-name src) (part json-src))
(setf (pin-name src) (pin json-src))
(add-source newWire src)))))
(let ((receivers (as-map (receivers wire)))) 
(block %map (dolist (json-receiver receivers) 
(let ((dest (make-instance 'destination)))
(setf (part-name dest) (part json-receiver))
(setf (pin-name dest) (pin json-receiver))
(add-destination newWire dest)))))
(addWire self newWire))))))))
(defmethod make-input-pins ((self kind) json-pin-array)
        (let ((pin-map (as-map json-pin-array))) 
(block %map (dolist (pin-name pin-map) 
(add-input-pin self pin-name)))))
(defmethod make-output-pins ((self kind) json-pin-array)
        (let ((pin-map (as-map json-pin-array))) 
(block %map (dolist (pin-name pin-map) 
(add-output-pin self pin-name)))))
(defmethod make-leaf-input-pins ((self kind) json-object-part)
        (make-input-pins self (inPins json-object-part)))
(defmethod make-leaf-output-pins ((self kind) json-object-part)
        (make-output-pins self (outPins json-object-part)))
(defmethod make-schematic-input-pins ((self kind) json-object-schematic)
        (make-input-pins self (inputs json-object-schematic)))
(defmethod make-schematic-output-pins ((self kind) json-object-schematic)
        (make-output-pins self (outputs json-object-schematic)))

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

(defclass App ()
(
(tableOfKinds :accessor tableOfKinds :initform nil)
(alist :accessor alist :initform nil)
(top-node :accessor top-node :initform nil)
(json-string :accessor json-string :initform nil)))
(defmethod read-json ((self App) )
        (let ((top-schematic (nothing self))) 
(initialize self)
(let ((JSON-arr (JSON self))) 
(let ((arr (as-map JSON-arr))) 
(block %map (dolist (json-object-part arr) 
(let ((newKind (make-instance 'kind)))
(setf (kind-name newKind) (name json-part-object))
(if (esa-expr-true (isLeaf json-object-part))
(progn
(read-leaf newKind json-object-part)
)
(progn
(if (esa-expr-true (isSchematic json-object-part))
(progn
(read-schematic newKind self json-object-part)
(setf top-schematic newKind)
)
(progn
(fatalErrorInBuild self)
))
))
(installInTable self (kind-name newKind) newKind))))))
(return-from read-json top-schematic)))
#| external method ((self App)) initialize |#
#| external method ((self App)) fatalErrorInBuild |#
#| external method ((self App)) JSON |#
#| external method ((self App)) nothing |#
#| external method ((self App)) lookupKind |#
#| external method ((self App)) installInTable |#

(defclass JSON-object ()
(
(foreign :accessor foreign :initform nil)))
#| external method ((self JSON-object)) isLeaf |#
#| external method ((self JSON-object)) isSchematic |#
#| external method ((self JSON-object)) name |#
#| external method ((self JSON-object)) itemKind |#
#| external method ((self JSON-object)) kind |#
#| external method ((self JSON-object)) filename |#
#| external method ((self JSON-object)) inPins |#
#| external method ((self JSON-object)) outPins |#
#| external method ((self JSON-object)) schematic |#
#| external method ((self JSON-object)) inputs |#
#| external method ((self JSON-object)) outputs |#
#| external method ((self JSON-object)) parts |#
#| external method ((self JSON-object)) wiring |#
#| external method ((self JSON-object)) partName |#
#| external method ((self JSON-object)) kindName |#
#| external method ((self JSON-object)) wireIndex |#
#| external method ((self JSON-object)) sources |#
#| external method ((self JSON-object)) receivers |#
#| external method ((self JSON-object)) part |#
#| external method ((self JSON-object)) pin |#

(defclass JSON-array ()
(
(foreign :accessor foreign :initform nil)))
#| external method ((self JSON-array)) as-map |#
