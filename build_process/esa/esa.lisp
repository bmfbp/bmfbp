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
        .install_source (self, part, pin))
(defmethod add-destination ((self wire) part pin)
        .install_destination (self, part, pin))

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
        .ensure_input_pin_not_declared (self, name)
        .install_input_pin (self, name))
(defmethod add-output-pin ((self kind) name)
        .ensure_output_pin_not_declared (self, name)
        .install_output_pin (self, name))
(defmethod add-part ((self kind) nm k nclass)
        .ensure_part_not_declared (self, nm)
        .install_part (self, nm, k, nclass))
(defmethod add-wire ((self kind) w)
        (block %map (dolist (s .sources) 
.ensure_valid_source (self, s)))
        (block %map (dolist (dest .destinations) 
.ensure_valid_destination (self, dest)))
        .install_wire (self, w))
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
        (if (esa-expr-true .refers_to_self?)
(progn
.ensure_valid_input_pin (self, .pin_name)
)
(progn
(let ((p .kind_find_part (self, .part_name))) 
.ensure_kind_defined
.ensure_valid_output_pin (.part_kind, .pin_name))
)))
(defmethod ensure-valid-destination ((self kind) dest)
        (if (esa-expr-true .refers_to_self?)
(progn
.ensure_valid_output_pin (self, .pin_name)
)
(progn
(let ((p .kind_find_part (self, .part_name))) 
.ensure_kind_defined
.ensure_valid_input_pin (.part_kind, .pin_name))
)))
(defmethod loader ((self kind) my-name my-container dispatchr)
        (let ((clss .self_class)) 
(let ((inst (make-instance clss)))
.clear_input_queue
.clear_output_queue
(setf .kind_field self)
(setf .container my-container)
(setf .name_in_container my-name)
(block %map (dolist (part .parts) 
(let ((part-instance .loader (.part_kind, .part_name, inst, dispatchr))) 
.add_child (inst, .part_name, part-instance))))
.memo_node (dispatchr, inst)
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
        .install_child (self, nm, nd))
(defmethod initialize ((self node) )
        .initially)
#| external method ((self node)) initially |#
#| external method ((self node)) send |#
(defmethod distribute-output-events ((self node) )
        (if (esa-expr-true .has_no_container?)
(progn
.display_output_events_to_console_and_delete
)
(progn
(let ((parent-composite-node .container)) 
(block %map (dolist (output .get_output_events_and_delete) 
(let ((dest .partpin)) 
(let ((w .find_wire_for_source (.kind_field, .part_name, .pin_name))) 
(block %map (dolist (dest .destinations) 
(if (esa-expr-true .refers_to_self?)
(progn
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(setf .part_name .name_in_container)
(setf .pin_name .pin_name)
(setf .partpin pp)
(setf .data .data)
.send (parent-composite-node, new-event)))
)
(progn
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(setf .part_name .part_name)
(setf .pin_name .pin_name)
(setf .partpin pp)
(setf .data .data)
(let ((child-part-instance .node_find_child (parent-composite-node, .part_name))) 
.enqueue_input (.instance_node, new-event))))
)))))))))
)))
#| external method ((self node)) display-output-events-to-console-and-delete |#
#| external method ((self node)) get-output-events-and-delete |#
#| external method ((self node)) has-no-container? |#
(defmethod distribute-outputs-upwards ((self node) )
        (if (esa-expr-true .has_no_container?)
(progn
)
(progn
(let ((parent .container)) 
.distribute_output_events)
)))
(defmethod busy? ((self node) )
        (if (esa-expr-true .flagged_as_busy?)
(progn
(return-from busy? :true)
)
(progn
(block %map (dolist (child-part-instance .children) 
(let ((child-node .instance_node)) 
(if (esa-expr-true .has_inputs_or_outputs?)
(progn
(return-from busy? :true)
)
(progn
(when (esa-expr-true .busy?)
(return-from busy? :true)
)
)))))
))
        (return-from busy? :false))
(defmethod ready? ((self node) )
        (when (esa-expr-true .input_queue?)
(if (esa-expr-true .busy?)
(progn
(return-from ready? :false)
)
(progn
(return-from ready? :true)
))
)
        (return-from ready? :false))
(defmethod invoke ((self node) )
        (let ((e .dequeue_input)) 
.run_reaction (self, e)
.distribute_output_events))
#| external method ((self node)) has-inputs-or-outputs? |#
#| external method ((self node)) children? |#
#| external method ((self node)) flagged-as-busy? |#
#| external method ((self node)) dequeue-input |#
#| external method ((self node)) input-queue? |#
#| external method ((self node)) enqueue-input |#
#| external method ((self node)) enqueue-output |#
#| external method ((self node)) react |#
(defmethod run-reaction ((self node) e)
        .react (self, e))
(defmethod run-composite-reaction ((self node) e)
        (let ((w :true)) 
(if (esa-expr-true .has_no_container?)
(progn
(setf w .find_wire_for_self_source (.kind_field, .pin_name))
)
(progn
(setf w .find_wire_for_source (.kind_field, .part_name, .pin_name))
))
(block %map (dolist (dest .destinations) 
(let ((new-event (make-instance 'event)))
(let ((pp (make-instance 'part-pin)))
(if (esa-expr-true .refers_to_self?)
(progn
(setf .part_name .part_name)
(setf .pin_name .pin_name)
(setf .partpin pp)
(setf .data .data)
.send (self, new-event)
)
(progn
(when (esa-expr-true .children?)
(setf .part_name .part_name)
(setf .pin_name .pin_name)
(setf .partpin pp)
(setf .data .data)
(let ((child-part-instance .node_find_child (self, .part_name))) 
.enqueue_input (.instance_node, new-event))
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
        (block %map (dolist (part .all_parts) 
.initialize)))
(defmethod distribute-all-outputs ((self dispatcher) )
        (block %map (dolist (p .all_parts) 
.distribute_output_events
.distribute_outputs_upwards)))
(defmethod dispatcher-run ((self dispatcher) )
        (let ((done :true)) 
(loop 
(setf done :true)
.distribute_all_outputs
(block %map (dolist (part .all_parts) 
(when (esa-expr-true .ready?)
.invoke
(setf done :false)
(return-from %map :false)
)))
(when (esa-expr-true done) (return)))))
(defmethod dispatcher-inject ((self dispatcher) pin val)
        (let ((e .create_top_event (self, pin, val))) 
.enqueue_input (.top_node, e)
.dispatcher_run))
#| external method ((self dispatcher)) create-top-event |#

(defclass event ()
(
(partpin :accessor partpin :initform nil)
(data :accessor data :initform nil)))
