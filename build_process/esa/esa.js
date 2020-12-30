// esa.js

function part_definition () {
this.attribute_part_name = null,
this.part_name = function () { return attribute_part_name; },
this.set_part_name = function (val) { this.attribute_part_name = val; },
this.attribute_part_kind = null,
this.part_kind = function () { return attribute_part_kind; },
this.set_part_kind = function (val) { this.attribute_part_kind = val; }
}
// external function ensure_kind_defined ((self part_definition))

function named_part_instance () {
this.attribute_instance_name = null,
this.instance_name = function () { return attribute_instance_name; },
this.set_instance_name = function (val) { this.attribute_instance_name = val; },
this.attribute_instance_node = null,
this.instance_node = function () { return attribute_instance_node; },
this.set_instance_node = function (val) { this.attribute_instance_node = val; }
}

function part_pin () {
this.attribute_part_name = null,
this.part_name = function () { return attribute_part_name; },
this.set_part_name = function (val) { this.attribute_part_name = val; },
this.attribute_pin_name = null,
this.pin_name = function () { return attribute_pin_name; },
this.set_pin_name = function (val) { this.attribute_pin_name = val; }
}

function source () {
this.attribute_part_name = null,
this.part_name = function () { return attribute_part_name; },
this.set_part_name = function (val) { this.attribute_part_name = val; },
this.attribute_pin_name = null,
this.pin_name = function () { return attribute_pin_name; },
this.set_pin_name = function (val) { this.attribute_pin_name = val; }
}
// external function refers_to_selfQ ((self source))

function destination () {
this.attribute_part_name = null,
this.part_name = function () { return attribute_part_name; },
this.set_part_name = function (val) { this.attribute_part_name = val; },
this.attribute_pin_name = null,
this.pin_name = function () { return attribute_pin_name; },
this.set_pin_name = function (val) { this.attribute_pin_name = val; }
}
// external function refers_to_selfQ ((self destination))

function wire () {
this.attribute_index = null,
this.index = function () { return attribute_index; },
this.set_index = function (val) { this.attribute_index = val; },
this.attribute_sources = [],
this.sources = function () { return attribute_sources; },
this.set_sources = function (val) { this.attribute_sources = val; },
this.attribute_destinations = [],
this.destinations = function () { return attribute_destinations; },
this.set_destinations = function (val) { this.attribute_destinations = val; }
}
// external function install_source ((self wire), (? name), (? name))
// external function install_destination ((self wire), (? name), (? name))
function add_source (self, part, pin) {
        self.install_source (part, pin);
};
function add_destination (self, part, pin) {
        self.install_destination (part, pin);
};

function kind () {
this.attribute_kind_name = null,
this.kind_name = function () { return attribute_kind_name; },
this.set_kind_name = function (val) { this.attribute_kind_name = val; },
this.attribute_input_pins = [],
this.input_pins = function () { return attribute_input_pins; },
this.set_input_pins = function (val) { this.attribute_input_pins = val; },
this.attribute_output_pins = [],
this.output_pins = function () { return attribute_output_pins; },
this.set_output_pins = function (val) { this.attribute_output_pins = val; },
this.attribute_self_class = null,
this.self_class = function () { return attribute_self_class; },
this.set_self_class = function (val) { this.attribute_self_class = val; },
this.attribute_parts = [],
this.parts = function () { return attribute_parts; },
this.set_parts = function (val) { this.attribute_parts = val; },
this.attribute_wires = [],
this.wires = function () { return attribute_wires; },
this.set_wires = function (val) { this.attribute_wires = val; }
}
// external function install_input_pin ((self kind), (? name))
// external function install_output_pin ((self kind), (? name))
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
// external function install_class ((self kind), (? node_class))
// external function install_wire ((self kind), (? wire))
// external function install_part ((self kind), (? name), (? kind), (? node_class))
// external function parts ((self kind))
// external function ensure_part_not_declared ((self kind), (? name))
// external function ensure_valid_input_pin ((self kind), (? name))
// external function ensure_valid_output_pin ((self kind), (? name))
// external function ensure_input_pin_not_declared ((self kind), (? name))
// external function ensure_output_pin_not_declared ((self kind), (? name))
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
// external function find_wire_for_source ((self kind), (? name), (? name))
// external function find_wire_for_self_source ((self kind), (? name))
// external function schematicCommonClass ((self kind))
// external function make_type_name ((self kind), (? name))
function read_leaf (self, json_object_part) {
        { /*let*/
let kindName = json_object_part.kind ();
{ /*let*/
let filename = json_object_part.filename ();
self.self_class () = self.make_type_name (kindName);
self.load_file (filename);
self.make_leaf_input_pins (json_object_part);
self.make_leaf_output_pins (json_object_part);
} /* end let */
} /* end let */
};
function read_schematic (self, app, json_object_part) {
        { /*let*/
let schematicName = json_object_part.name ();
self.self_class () = self.schematicCommonClass ();
{ /*let*/
let schematic = json_object_part.schematic ();
self.make_schematic_input_pins (schematic);
self.make_schematic_output_pins (schematic);
{ /*let*/
let parts = schematic.parts ().as_map ();
(function () {
for (const json_child in parts) {
{ /*let*/
let child_kind_name = json_child.kindName ();
{ /*let*/
let child_name = json_child.partName ();
{ /*let*/
let child_kind = app.lookupKind (child-kind-name);
self.add_part (child_name, child_kind, child_kind.self_class ());
} /* end let */
} /* end let */
} /* end let */
};
}) ();
} /* end let */
{ /*let*/
let wires = schematic.wiring ().as_map ();
(function () {
for (const json_wire in wires) {
{ let newWire = new wire;
newWire.index () = json_wire.wireIndex ();
{ /*let*/
let sources = json_wire.sources ().as_map ();
(function () {
for (const json_source in sources) {
newWire.add_source (json_source.part (), json_source.pin ());
};
}) ();
} /* end let */
{ /*let*/
let receivers = json_wire.receivers ().as_map ();
(function () {
for (const json_receiver in receivers) {
newWire.add_destination (json_receiver.part (), json_receiver.pin ());
};
}) ();
} /* end let */
self.add_wire (newWire);}

};
}) ();
} /* end let */
} /* end let */
} /* end let */
};
function make_input_pins (self, json_pin_array) {
        { /*let*/
let pin_map = json_pin_array.as_map ();
(function () {
for (const pin_name in pin-map) {
self.add_input_pin (pin_name);
};
}) ();
} /* end let */
};
function make_output_pins (self, json_pin_array) {
        { /*let*/
let pin_map = json_pin_array.as_map ();
(function () {
for (const pin_name in pin-map) {
self.add_output_pin (pin_name);
};
}) ();
} /* end let */
};
function make_leaf_input_pins (self, json_object_part) {
        self.make_input_pins (json_object_part.inPins ());
};
function make_leaf_output_pins (self, json_object_part) {
        self.make_output_pins (json_object_part.outPins ());
};
function make_schematic_input_pins (self, json_object_schematic) {
        self.make_input_pins (json_object_schematic.inputs ());
};
function make_schematic_output_pins (self, json_object_schematic) {
        self.make_output_pins (json_object_schematic.outputs ());
};
// external function load_file ((self kind), (? name))

function node () {
this.attribute_input_queue = null,
this.input_queue = function () { return attribute_input_queue; },
this.set_input_queue = function (val) { this.attribute_input_queue = val; },
this.attribute_output_queue = null,
this.output_queue = function () { return attribute_output_queue; },
this.set_output_queue = function (val) { this.attribute_output_queue = val; },
this.attribute_kind_field = null,
this.kind_field = function () { return attribute_kind_field; },
this.set_kind_field = function (val) { this.attribute_kind_field = val; },
this.attribute_container = null,
this.container = function () { return attribute_container; },
this.set_container = function (val) { this.attribute_container = val; },
this.attribute_name_in_container = null,
this.name_in_container = function () { return attribute_name_in_container; },
this.set_name_in_container = function (val) { this.attribute_name_in_container = val; },
this.attribute_children = [],
this.children = function () { return attribute_children; },
this.set_children = function (val) { this.attribute_children = val; },
this.attribute_busy_flag = null,
this.busy_flag = function () { return attribute_busy_flag; },
this.set_busy_flag = function (val) { this.attribute_busy_flag = val; }
}
// external function clear_input_queue ((self node))
// external function clear_output_queue ((self node))
// external function install_node ((self node), (? node))
function add_child (self, nm, nd) {
        self.install_child (nm, nd);
};
function initialize (self) {
        self.initially ();
};
// external function initially ((self node))
// external function send ((self node), (? event))
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
// external function display_output_events_to_console_and_delete ((self node))
// external function get_output_events_and_delete ((self node))
// external function has_no_containerQ ((self node))
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
// external function has_inputs_or_outputsQ ((self node))
// external function childrenQ ((self node))
// external function flagged_as_busyQ ((self node))
// external function dequeue_input ((self node))
// external function input_queueQ ((self node))
// external function enqueue_input ((self node), (? event))
// external function enqueue_output ((self node), (? event))
// external function react ((self node), (? event))
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
// external function node_find_child ((self node), (? name))

function dispatcher () {
this.attribute_all_parts = [],
this.all_parts = function () { return attribute_all_parts; },
this.set_all_parts = function (val) { this.attribute_all_parts = val; },
this.attribute_top_node = null,
this.top_node = function () { return attribute_top_node; },
this.set_top_node = function (val) { this.attribute_top_node = val; }
}
// external function memo_node ((self dispatcher), (? node))
// external function set_top_node ((self dispatcher), (? node))
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
// external function create_top_event ((self dispatcher), (? name), (? value))

function event () {
this.attribute_partpin = null,
this.partpin = function () { return attribute_partpin; },
this.set_partpin = function (val) { this.attribute_partpin = val; },
this.attribute_data = null,
this.data = function () { return attribute_data; },
this.set_data = function (val) { this.attribute_data = val; }
}

function App () {
this.attribute_tableOfKinds = null,
this.tableOfKinds = function () { return attribute_tableOfKinds; },
this.set_tableOfKinds = function (val) { this.attribute_tableOfKinds = val; },
this.attribute_alist = null,
this.alist = function () { return attribute_alist; },
this.set_alist = function (val) { this.attribute_alist = val; },
this.attribute_top_node = null,
this.top_node = function () { return attribute_top_node; },
this.set_top_node = function (val) { this.attribute_top_node = val; },
this.attribute_json_string = null,
this.json_string = function () { return attribute_json_string; },
this.set_json_string = function (val) { this.attribute_json_string = val; }
}
function read_json (self) {
        { /*let*/
let top_schematic = self.nothing ();
self.initialize ();
{ /*let*/
let JSON_arr = self.JSON ();
{ /*let*/
let arr = JSON_arr.as_map ();
(function () {
for (const json_object_part in arr) {
{ let newKind = new kind;
newKind.kind_name () = json_object_part.name ();
if (json_object_part.isLeaf ()) {
newKind.read_leaf (json_object_part);
} else {
if (json_object_part.isSchematic ()) {
newKind.read_schematic (self, json_object_part);
top_schematic = newKind;
} else {
self.fatalErrorInBuild ();
}
}
self.installInTable (newKind.kind_name (), newKind);}

};
}) ();
} /* end let */
} /* end let */
return top_schematic;
} /* end let */
};
// external function initialize ((self App))
// external function fatalErrorInBuild ((self App))
// external function JSON ((self App))
// external function nothing ((self App))
// external function lookupKind ((self App), (? name))
// external function installInTable ((self App), (? name), (? kind))

function JSON_object () {
this.attribute_handle = null,
this.handle = function () { return attribute_handle; },
this.set_handle = function (val) { this.attribute_handle = val; }
}
// external function isLeaf ((self JSON_object))
// external function isSchematic ((self JSON_object))
// external function name ((self JSON_object))
// external function itemKind ((self JSON_object))
// external function kind ((self JSON_object))
// external function filename ((self JSON_object))
// external function inPins ((self JSON_object))
// external function outPins ((self JSON_object))
// external function schematic ((self JSON_object))
// external function inputs ((self JSON_object))
// external function outputs ((self JSON_object))
// external function parts ((self JSON_object))
// external function wiring ((self JSON_object))
// external function partName ((self JSON_object))
// external function kindName ((self JSON_object))
// external function wireIndex ((self JSON_object))
// external function sources ((self JSON_object))
// external function receivers ((self JSON_object))
// external function part ((self JSON_object))
// external function pin ((self JSON_object))

function JSON_array () {
this.attribute_handle = null,
this.handle = function () { return attribute_handle; },
this.set_handle = function (val) { this.attribute_handle = val; }
}
// external function as_map ((self JSON_array))

function foreign () {
this.attribute_handle = null,
this.handle = function () { return attribute_handle; },
this.set_handle = function (val) { this.attribute_handle = val; }
}
