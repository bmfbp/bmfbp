// esa.js

function part_definition () {
    this.attribute_part_name = null;
    this.part_name = function () { return attribute_part_name; };
    this.attribute_part_kind = null;
    this.part_kind = function () { return attribute_part_kind; };
}
// external method ((self part-definition)) ensure_kind_defined

function named_part_instance () {
    this.attribute_instance_name = null;
    this.instance_name = function () { return attribute_instance_name; };
    this.attribute_instance_node = null;
    this.instance_node = function () { return attribute_instance_node; };
}

function part_pin () {
    this.attribute_part_name = null;
    this.part_name = function () { return attribute_part_name; };
    this.attribute_pin_name = null;
    this.pin_name = function () { return attribute_pin_name; };
}

function source () {
    this.attribute_part_name = null;
    this.part_name = function () { return attribute_part_name; };
    this.attribute_pin_name = null;
    this.pin_name = function () { return attribute_pin_name; };
}
// external method ((self source)) refers_to_selfQ

function destination () {
    this.attribute_part_name = null;
    this.part_name = function () { return attribute_part_name; };
    this.attribute_pin_name = null;
    this.pin_name = function () { return attribute_pin_name; };
}
// external method ((self destination)) refers_to_selfQ

function wire () {
    this.attribute_index = null;
    this.index = function () { return attribute_index; };
    this.attribute_sources = null;
    this.sources = function () { return attribute_sources; };
    this.attribute_destinations = null;
    this.destinations = function () { return attribute_destinations; };
}
// external method ((self wire)) install_source
// external method ((self wire)) install_destination
function add_source (self, part, pin) {
    self.install_source (part, pin);
};
function add_destination (self, part, pin) {
    self.install_destination (part, pin);
};

function kind () {
    this.attribute_kind_name = null;
    this.kind_name = function () { return attribute_kind_name; };
    this.attribute_input_pins = null;
    this.input_pins = function () { return attribute_input_pins; };
    this.attribute_self_class = null;
    this.self_class = function () { return attribute_self_class; };
    this.attribute_output_pins = null;
    this.output_pins = function () { return attribute_output_pins; };
    this.attribute_parts = null;
    this.parts = function () { return attribute_parts; };
    this.attribute_wires = null;
    this.wires = function () { return attribute_wires; };
}
// external method ((self kind)) install_input_pin
// external method ((self kind)) install_output_pin
function add_input_pin (self, name) {
    self.ensure_input_pin_not_declared (name);
    self.install_input_pin (name);
};
function add_output_pin (self, name) {
    self.ensure_output_pin_not_declared (name);
    self.install_output_pin (name);
};
function add_part (self, nm, k, nclass) {
    self.ensure_part_not_declared (nm);
    self.install_part (nm, k, nclass);
};
function add_wire (self, w) {
    (function () {
	for (const s in w.sources ()) {
	    self.ensure_valid_source (s);
	};
    }) ();
    (function () {
	for (const dest in w.destinations ()) {
	    self.ensure_valid_destination (dest);
	};
    }) ();
    self.install_wire (w);
};
// external method ((self kind)) install_wire
// external method ((self kind)) install_part
// external method ((self kind)) parts
// external method ((self kind)) install_class
// external method ((self kind)) ensure_part_not_declared
// external method ((self kind)) ensure_valid_input_pin
// external method ((self kind)) ensure_valid_output_pin
// external method ((self kind)) ensure_input_pin_not_declared
// external method ((self kind)) ensure_output_pin_not_declared
function ensure_valid_source (self, s) {
    if (s.refers_to_selfQ ()) {
	self.ensure_valid_input_pin (s.pin_name ());
    } else {
	{ /*let*/
	    let p = self.kind_find_part (s.part_name ());
	    p.ensure_kind_defined ();
	    p.part_kind ().ensure_valid_output_pin (s.pin_name ());
	} /* end let */
    }
};
function ensure_valid_destination (self, dest) {
    if (dest.refers_to_selfQ ()) {
	self.ensure_valid_output_pin (dest.pin_name ());
    } else {
	{ /*let*/
	    let p = self.kind_find_part (dest.part_name ());
	    p.ensure_kind_defined ();
	    p.part_kind ().ensure_valid_input_pin (dest.pin_name ());
	} /* end let */
    }
};
function loader (self, my_name, my_container, dispatchr) {
    { /*let*/
	let clss = self.self_class ();
	{ let inst = new clss;
	  inst.clear_input_queue ();
	  inst.clear_output_queue ();
	  inst.kind_field () = self;
	  inst.container () = my-container;
	  inst.name_in_container () = my-name;
	  (function () {
	      for (const part in self.parts ()) {
		  { /*let*/
		      let part_instance = part.part_kind ().loader (part.part_name (), inst, dispatchr);
		      inst.add_child (part.part_name (), part_instance);
		  } /* end let */
	      };
	  }) ();
	  dispatchr.memo_node (inst);
	  return inst;}

    } /* end let */
};
// external method ((self kind)) find_wire_for_source
// external method ((self kind)) find_wire_for_self_source

function node () {
    this.attribute_input_queue = null;
    this.input_queue = function () { return attribute_input_queue; };
    this.attribute_output_queue = null;
    this.output_queue = function () { return attribute_output_queue; };
    this.attribute_kind_field = null;
    this.kind_field = function () { return attribute_kind_field; };
    this.attribute_container = null;
    this.container = function () { return attribute_container; };
    this.attribute_name_in_container = null;
    this.name_in_container = function () { return attribute_name_in_container; };
    this.attribute_children = null;
    this.children = function () { return attribute_children; };
    this.attribute_busy_flag = null;
    this.busy_flag = function () { return attribute_busy_flag; };
}
// external method ((self node)) clear_input_queue
// external method ((self node)) clear_output_queue
// external method ((self node)) install_node
function add_child (self, nm, nd) {
    self.install_child (nm, nd);
};
function initialize (self) {
    self.initially ();
};
// external method ((self node)) initially
// external method ((self node)) send
function distribute_output_events (self) {
    if (self.has_no_containerQ ()) {
	self.display_output_events_to_console_and_delete ();
    } else {
	{ /*let*/
	    let parent_composite_node = self.container ();
	    (function () {
		for (const output in self.get_output_events_and_delete ()) {
		    { /*let*/
			let dest = output.partpin ();
			{ /*let*/
			    let w = parent_composite_node.kind_field ().find_wire_for_source (output.partpin ().part_name (), output.partpin ().pin_name ());
			    (function () {
				for (const dest in w.destinations ()) {
				    if (dest.refers_to_selfQ ()) {
					{ let new_event = new event;
					  { let pp = new part-pin;
					    pp.part_name () = parent_composite_node.name_in_container ();
					    pp.pin_name () = dest.pin_name ();
					    new_event.partpin () = pp;
					    new_event.data () = output.data ();
					    parent_composite_node.send (new_event);}
					}

				    } else {
					{ let new_event = new event;
					  { let pp = new part-pin;
					    pp.part_name () = dest.part_name ();
					    pp.pin_name () = dest.pin_name ();
					    new_event.partpin () = pp;
					    new_event.data () = output.data ();
					    { /*let*/
						let child_part_instance = parent_composite_node.node_find_child (pp.part_name ());
						child_part_instance.instance_node ().enqueue_input (new_event);
					    } /* end let */}
					}

				    }
				};
			    }) ();
			} /* end let */
		    } /* end let */
		};
	    }) ();
	} /* end let */
    }
};
// external method ((self node)) display_output_events_to_console_and_delete
// external method ((self node)) get_output_events_and_delete
// external method ((self node)) has_no_containerQ
function distribute_outputs_upwards (self) {
    if (self.has_no_containerQ ()) {
    } else {
	{ /*let*/
	    let parent = self.container ();
	    parent.distribute_output_events ();
	} /* end let */
    }
};
function busyQ (self) {
    if (self.flagged_as_busyQ ()) {
	return true;
    } else {
	(function () {
	    for (const child_part_instance in self.children ()) {
		{ /*let*/
		    let child_node = child_part_instance.instance_node ();
		    if (child_node.has_inputs_or_outputsQ ()) {
			return true;
		    } else {
			if (child_node.busyQ ()) {

			    return true;
			}
		    }
		} /* end let */
	    };
	}) ();
    }
    return false;
};
function readyQ (self) {
    if (self.input_queueQ ()) {

	if (self.busyQ ()) {
	    return false;
	} else {
	    return true;
	}
    }
    return false;
};
function invoke (self) {
    { /*let*/
	let e = self.dequeue_input ();
	self.run_reaction (e);
	self.distribute_output_events ();
    } /* end let */
};
// external method ((self node)) has_inputs_or_outputsQ
// external method ((self node)) childrenQ
// external method ((self node)) flagged_as_busyQ
// external method ((self node)) dequeue_input
// external method ((self node)) input_queueQ
// external method ((self node)) enqueue_input
// external method ((self node)) enqueue_output
// external method ((self node)) react
function run_reaction (self, e) {
    self.react (e);
};
function run_composite_reaction (self, e) {
    { /*let*/
	let w = true;
	if (self.has_no_containerQ ()) {
	    w = self.kind_field ().find_wire_for_self_source (e.partpin ().pin_name ());
	} else {
	    w = self.container ().kind_field ().find_wire_for_source (e.partpin ().part_name (), e.partpin ().pin_name ());
	}
	(function () {
	    for (const dest in w.destinations ()) {
		{ let new_event = new event;
		  { let pp = new part-pin;
		    if (dest.refers_to_selfQ ()) {
			pp.part_name () = dest.part_name ();
			pp.pin_name () = dest.pin_name ();
			new_event.partpin () = pp;
			new_event.data () = e.data ();
			self.send (new_event);
		    } else {
			if (self.childrenQ ()) {

			    pp.part_name () = dest.part_name ();
			    pp.pin_name () = dest.pin_name ();
			    new_event.partpin () = pp;
			    new_event.data () = e.data ();
			    { /*let*/
				let child_part_instance = self.node_find_child (dest.part_name ());
				child_part_instance.instance_node ().enqueue_input (new_event);
			    } /* end let */
			}
		    }}
		}

	    };
	}) ();
    } /* end let */
};
// external method ((self node)) node_find_child

function dispatcher () {
    this.attribute_all_parts = null;
    this.all_parts = function () { return attribute_all_parts; };
    this.attribute_top_node = null;
    this.top_node = function () { return attribute_top_node; };
}
// external method ((self dispatcher)) memo_node
// external method ((self dispatcher)) set_top_node
function initialize_all (self) {
    (function () {
	for (const part in self.all_parts ()) {
	    part.initialize ();
	};
    }) ();
};
function distribute_all_outputs (self) {
    (function () {
	for (const p in self.all_parts ()) {
	    p.distribute_output_events ();
	    p.distribute_outputs_upwards ();
	};
    }) ();
};
function dispatcher_run (self) {
    { /*let*/
	let done = true;
	for (;;) {
	    done = true;
	    self.distribute_all_outputs ();
	    (function () {
		for (const part in self.all_parts ()) {
		    if (part.readyQ ()) {

			part.invoke ();
			done = false;
			return;
		    }
		};
	    }) ();
	    if (done) {break;};
	}
    } /* end let */
};
function dispatcher_inject (self, pin, val) {
    { /*let*/
	let e = self.create_top_event (pin, val);
	self.top_node ().enqueue_input (e);
	self.dispatcher_run ();
    } /* end let */
};
// external method ((self dispatcher)) create_top_event

function event () {
    this.attribute_partpin = null;
    this.partpin = function () { return attribute_partpin; };
    this.attribute_data = null;
    this.data = function () { return attribute_data; };
}
