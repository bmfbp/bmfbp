(in-package :arrowgrams/build)(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

(defclass part-definition (stack-dsl:%typed-value)
(
(part-name :accessor part-name :initform nil)
(part-kind :accessor part-kind :initform nil)))
#| external method ((self part-definition)) ensure-kind-defined |#

(defclass named-part-instance (stack-dsl:%typed-value)
(
(instance-name :accessor instance-name :initform nil)
(instance-node :accessor instance-node :initform nil)))

(defclass part-pin (stack-dsl:%typed-value)
(
(part-name :accessor part-name :initform nil)
(pin-name :accessor pin-name :initform nil)))

(defclass source (stack-dsl:%typed-value)
(
(part-name :accessor part-name :initform nil)
(pin-name :accessor pin-name :initform nil)))
#| external method ((self source)) refers-to-self? |#

(defclass destination (stack-dsl:%typed-value)
(
(part-name :accessor part-name :initform nil)
(pin-name :accessor pin-name :initform nil)))
#| external method ((self destination)) refers-to-self? |#

(defclass wire (stack-dsl:%typed-value)
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

(defclass kind (stack-dsl:%typed-value)
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
        (block %map (dolist (s (stack-dsl::%ordered-list (sources w)))

(unless (and (subtypep (type-of s) 'stack-dsl:%typed-value)
               (subtypep (type-of s) (stack-dsl::%element-type (sources w))))
  (error (format nil "ESA: [~a] must be of type [~a]" s (stack-dsl::%element-type (sources w)))))

(ensure-valid-source self s)))
        (block %map (dolist (dest (stack-dsl::%ordered-list (destinations w)))

(unless (and (subtypep (type-of dest) 'stack-dsl:%typed-value)
               (subtypep (type-of dest) (stack-dsl::%element-type (destinations w))))
  (error (format nil "ESA: [~a] must be of type [~a]" dest (stack-dsl::%element-type (destinations w)))))

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
(block %map (dolist (part (stack-dsl::%ordered-list (parts self)))

(unless (and (subtypep (type-of part) 'stack-dsl:%typed-value)
               (subtypep (type-of part) (stack-dsl::%element-type (parts self))))
  (error (format nil "ESA: [~a] must be of type [~a]" part (stack-dsl::%element-type (parts self)))))

(let ((part-instance (loader (part-kind part) (part-name part) inst dispatchr))) 
(add-child inst (part-name part) part-instance))))
(memo-node dispatchr inst)
(return-from loader inst))))
#| external method ((self kind)) find-wire-for-source |#
#| external method ((self kind)) find-wire-for-self-source |#
(defmethod make-input-pins ((self kind) json-part)
        (block %map (dolist (inpin-name (stack-dsl::%ordered-list (inPins json-part)))

(unless (and (subtypep (type-of inpin-name) 'stack-dsl:%typed-value)
               (subtypep (type-of inpin-name) (stack-dsl::%element-type (inPins json-part))))
  (error (format nil "ESA: [~a] must be of type [~a]" inpin-name (stack-dsl::%element-type (inPins json-part)))))

(add-input-pin self inpin-name))))
(defmethod make-output-pins ((self kind) json-part)
        (block %map (dolist (outpin-name (stack-dsl::%ordered-list (outPins json-part)))

(unless (and (subtypep (type-of outpin-name) 'stack-dsl:%typed-value)
               (subtypep (type-of outpin-name) (stack-dsl::%element-type (outPins json-part))))
  (error (format nil "ESA: [~a] must be of type [~a]" outpin-name (stack-dsl::%element-type (outPins json-part)))))

(add-output-pin self outpin-name))))

(defclass node (stack-dsl:%typed-value)
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
(block %map (dolist (output (stack-dsl::%ordered-list (get-output-events-and-delete self)))

(unless (and (subtypep (type-of output) 'stack-dsl:%typed-value)
               (subtypep (type-of output) (stack-dsl::%element-type (get-output-events-and-delete self))))
  (error (format nil "ESA: [~a] must be of type [~a]" output (stack-dsl::%element-type (get-output-events-and-delete self)))))

(let ((dest (partpin output))) 
(let ((w (find-wire-for-source (kind-field parent-composite-node) (part-name (partpin output)) (pin-name (partpin output))))) 
(block %map (dolist (dest (stack-dsl::%ordered-list (destinations w)))

(unless (and (subtypep (type-of dest) 'stack-dsl:%typed-value)
               (subtypep (type-of dest) (stack-dsl::%element-type (destinations w))))
  (error (format nil "ESA: [~a] must be of type [~a]" dest (stack-dsl::%element-type (destinations w)))))

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
(block %map (dolist (child-part-instance (stack-dsl::%ordered-list (children self)))

(unless (and (subtypep (type-of child-part-instance) 'stack-dsl:%typed-value)
               (subtypep (type-of child-part-instance) (stack-dsl::%element-type (children self))))
  (error (format nil "ESA: [~a] must be of type [~a]" child-part-instance (stack-dsl::%element-type (children self)))))

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
(block %map (dolist (dest (stack-dsl::%ordered-list (destinations w)))

(unless (and (subtypep (type-of dest) 'stack-dsl:%typed-value)
               (subtypep (type-of dest) (stack-dsl::%element-type (destinations w))))
  (error (format nil "ESA: [~a] must be of type [~a]" dest (stack-dsl::%element-type (destinations w)))))

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

(defclass dispatcher (stack-dsl:%typed-value)
(
(all-parts :accessor all-parts :initform nil)
(top-node :accessor top-node :initform nil)))
#| external method ((self dispatcher)) memo-node |#
#| external method ((self dispatcher)) set-top-node |#
(defmethod initialize-all ((self dispatcher) )
        (block %map (dolist (part (stack-dsl::%ordered-list (all-parts self)))

(unless (and (subtypep (type-of part) 'stack-dsl:%typed-value)
               (subtypep (type-of part) (stack-dsl::%element-type (all-parts self))))
  (error (format nil "ESA: [~a] must be of type [~a]" part (stack-dsl::%element-type (all-parts self)))))

(initialize part))))
(defmethod distribute-all-outputs ((self dispatcher) )
        (block %map (dolist (p (stack-dsl::%ordered-list (all-parts self)))

(unless (and (subtypep (type-of p) 'stack-dsl:%typed-value)
               (subtypep (type-of p) (stack-dsl::%element-type (all-parts self))))
  (error (format nil "ESA: [~a] must be of type [~a]" p (stack-dsl::%element-type (all-parts self)))))

(distribute-output-events p)
(distribute-outputs-upwards p))))
(defmethod dispatcher-run ((self dispatcher) )
        (let ((done :true)) 
(loop 
(setf done :true)
(distribute-all-outputs self)
(block %map (dolist (part (stack-dsl::%ordered-list (all-parts self)))

(unless (and (subtypep (type-of part) 'stack-dsl:%typed-value)
               (subtypep (type-of part) (stack-dsl::%element-type (all-parts self))))
  (error (format nil "ESA: [~a] must be of type [~a]" part (stack-dsl::%element-type (all-parts self)))))

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

(defclass event (stack-dsl:%typed-value)
(
(partpin :accessor partpin :initform nil)
(data :accessor data :initform nil)))

(defclass isaBuilder (stack-dsl:%typed-value)
(
(tableOfKinds :accessor tableOfKinds :initform nil)
(alist :accessor alist :initform nil)
(json-string :accessor json-string :initform nil)))
(defmethod isabuild ((self isaBuilder) )
        (initialize self)
        (let ((arr (get-app-from-JSON-as-map self))) 
(block %map (dolist (json-part (stack-dsl::%ordered-list arr))

(unless (and (subtypep (type-of json-part) 'stack-dsl:%typed-value)
               (subtypep (type-of json-part) (stack-dsl::%element-type arr)))
  (error (format nil "ESA: [~a] must be of type [~a]" json-part (stack-dsl::%element-type arr))))

(if (esa-expr-true (isLeaf json-part))
(progn
(make-leaf-kind self json-part)
)
(progn
(if (esa-expr-true (isSchematic json-part))
(progn
(make-schematic-kind self json-part)
)
(progn
(fatalErrorInBuild self)
))
))))))
#| external method ((self isaBuilder)) fatalErrorInBuild |#
#| external method ((self isaBuilder)) get-app-from-JSON-as-map |#
(defmethod make-leaf-kind ((self isaBuilder) json-part)
        (let ((kindString (kind json-part))) 
(let ((filename (filename json-part))) 
(let ((newKind (make-instance 'kind)))
(setf (kind-name newKind) (make-type-name self kindString))
(setf (self-class newKind) (make-type-name self kindString))
(make-input-pins newKind json-part)
(make-output-pins newKind json-part)
(installInTable self kindString newKind)))))
(defmethod make-schematic-kind ((self isaBuilder) json-part)
        (let ((schematicName (name json-part))) 
(let ((newKind (make-instance 'kind)))
(setf (kind-name newKind) schematicName)
(setf (self-class newKind) (schematicCommonClass self))
(make-input-pins newKind json-part)
(make-output-pins newKind json-part)
(block %map (dolist (child (stack-dsl::%ordered-list (partsMap json-part)))

(unless (and (subtypep (type-of child) 'stack-dsl:%typed-value)
               (subtypep (type-of child) (stack-dsl::%element-type (partsMap json-part))))
  (error (format nil "ESA: [~a] must be of type [~a]" child (stack-dsl::%element-type (partsMap json-part)))))

(let ((partKind_name (kindName child))) 
(let ((part_kind (lookupKind self partKind_name))) 
(add-part newKind (partName child) part_kind partKind_name)))))
(block %map (dolist (wJSON (stack-dsl::%ordered-list (wireMap json-part)))

(unless (and (subtypep (type-of wJSON) 'stack-dsl:%typed-value)
               (subtypep (type-of wJSON) (stack-dsl::%element-type (wireMap json-part))))
  (error (format nil "ESA: [~a] must be of type [~a]" wJSON (stack-dsl::%element-type (wireMap json-part)))))

(let ((w (make-instance 'Wire)))
(setf (index w) (index wJSON))
(block %map (dolist (sourceJSON (stack-dsl::%ordered-list (sourceMap wJSON)))

(unless (and (subtypep (type-of sourceJSON) 'stack-dsl:%typed-value)
               (subtypep (type-of sourceJSON) (stack-dsl::%element-type (sourceMap wJSON))))
  (error (format nil "ESA: [~a] must be of type [~a]" sourceJSON (stack-dsl::%element-type (sourceMap wJSON)))))

(add-source w (partName sourceJSON) (pinName sourceJSON))))
(block %map (dolist (destinationJSON (stack-dsl::%ordered-list (destinationMap wJSON)))

(unless (and (subtypep (type-of destinationJSON) 'stack-dsl:%typed-value)
               (subtypep (type-of destinationJSON) (stack-dsl::%element-type (destinationMap wJSON))))
  (error (format nil "ESA: [~a] must be of type [~a]" destinationJSON (stack-dsl::%element-type (destinationMap wJSON)))))

(add-source w (partName destinationJSON) (pinName destinationJSON))))
(add-wire newKind w))))
(installInTable self kindString newKind))))
#| external method ((self isaBuilder)) make-type-name |#
#| external method ((self isaBuilder)) schematicCommonClass |#

(defclass kindsByName (stack-dsl:%typed-value)
(
(table :accessor table :initform nil)))

(defclass JSONpart (stack-dsl:%typed-value)
(
(foreign :accessor foreign :initform nil)))
#| external method ((self JSONpart)) name |#
#| external method ((self JSONpart)) kind |#
#| external method ((self JSONpart)) filename |#
#| external method ((self JSONpart)) inPins |#
#| external method ((self JSONpart)) outPins |#
#| external method ((self JSONpart)) schematicName |#
#| external method ((self JSONpart)) partsMap |#
#| external method ((self JSONpart)) wireMap |#
#| external method ((self JSONpart)) isLeaf |#
#| external method ((self JSONpart)) isSchematic |#
#| external method ((self JSONpart)) getWire |#

(defclass JSONpartNameAndKind (stack-dsl:%typed-value)
(
(foreign :accessor foreign :initform nil)))
#| external method ((self JSONpartNameAndKind)) partName |#
#| external method ((self JSONpartNameAndKind)) kindName |#

(defclass JSONpartNameAndPin (stack-dsl:%typed-value)
(
(foreign :accessor foreign :initform nil)))
#| external method ((self JSONpartNameAndPin)) partName |#
#| external method ((self JSONpartNameAndPin)) pinName |#

(defclass JSONwire (stack-dsl:%typed-value)
(
(foreign :accessor foreign :initform nil)))
#| external method ((self JSONwire)) index |#
#| external method ((self JSONwire)) sourceMap |#
#| external method ((self JSONwire)) destinationMap |#

(defclass JSONindex (stack-dsl:%typed-value)
(
(foreign :accessor foreign :initform nil)))
