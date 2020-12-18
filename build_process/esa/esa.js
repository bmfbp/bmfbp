// esa.js

function part_definition () {
this.part_name = null;
this.part_kind = null;
}
// external method ((self part-definition)) ensure_kind_defined

function named_part_instance () {
this.instance_name = null;
this.instance_node = null;
}

function part_pin () {
this.part_name = null;
this.pin_name = null;
}

function source () {
this.part_name = null;
this.pin_name = null;
}
// external method ((self source)) refers_to_self?

function destination () {
this.part_name = null;
this.pin_name = null;
}
// external method ((self destination)) refers_to_self?

function wire () {
this.index = null;
this.sources = null;
this.destinations = null;
}
// external method ((self wire)) install_source
// external method ((self wire)) install_destination
function add_source (self, part, pin) {
        install_source (self, part, pin);
};
function add_destination (self, part, pin) {
        install_destination (self, part, pin);
};

function kind () {
this.kind_name = null;
this.input_pins = null;
this.self_class = null;
this.output_pins = null;
this.parts = null;
this.wires = null;
}
// external method ((self kind)) install_input_pin
// external method ((self kind)) install_output_pin
function add_input_pin (self, name) {
        ensure_input_pin_not_declared (self, name);
        install_input_pin (self, name);
};
function add_output_pin (self, name) {
        ensure_output_pin_not_declared (self, name);
        install_output_pin (self, name);
};
function add_part (self, nm, k, nclass) {
        ensure_part_not_declared (self, nm);
        install_part (self, nm, k, nclass);
};
function add_wire (self, w) {
        (block %map (dolist (s sources) 
ensure_valid_source (self, s);))
        (block %map (dolist (dest destinations) 
ensure_valid_destination (self, dest);))
        install_wire (self, w);
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
        if (esa_expr_true (refers_to_self?))
{
ensure_valid_input_pin (self, pin_name);

}

{
(let ((p kind_find_part (self, part_name))) 
ensure_kind_defined;
ensure_valid_output_pin (part_kind, pin_name);)

}

};
function ensure_valid_destination (self, dest) {
        if (esa_expr_true (refers_to_self?))
{
ensure_valid_output_pin (self, pin_name);

}

{
(let ((p kind_find_part (self, part_name))) 
ensure_kind_defined;
ensure_valid_input_pin (part_kind, pin_name);)

}

};
function loader (self, my-name, my-container, dispatchr) {
        (let ((clss self_class)) 
(let ((inst (make-instance clss)))
clear_input_queue;
clear_output_queue;
kind_field = self;
container = my-container;
name_in_container = my-name;
(block %map (dolist (part parts) 
(let ((part_instance loader (part_kind, part_name, inst, dispatchr))) 
add_child (inst, part_name, part_instance);)))
memo_node (dispatchr, inst);
return inst;))
};
// external method ((self kind)) find_wire_for_source
// external method ((self kind)) find_wire_for_self_source

function node () {
this.input_queue = null;
this.output_queue = null;
this.kind_field = null;
this.container = null;
this.name_in_container = null;
this.children = null;
this.busy_flag = null;
}
// external method ((self node)) clear_input_queue
// external method ((self node)) clear_output_queue
// external method ((self node)) install_node
function add_child (self, nm, nd) {
        install_child (self, nm, nd);
};
function initialize (self) {
        initially;
};
// external method ((self node)) initially
// external method ((self node)) send
function distribute_output_events (self) {
        if (esa_expr_true (has_no_container?))
{
display_output_events_to_console_and_delete;

}

{
(let ((parent_composite_node container)) 
(block %map (dolist (output get_output_events_and_delete) 
(let ((dest partpin)) 
(let ((w find_wire_for_source (kind_field, part_name, pin_name))) 
(block %map (dolist (dest destinations) 
if (esa_expr_true (refers_to_self?))
{
{ let new_event = new event;
{ let pp = new part-pin;
part_name = name_in_container;
pin_name = pin_name;
partpin = pp;
data = data;
send (parent_composite_node, new_event);}
}


}

{
{ let new_event = new event;
{ let pp = new part-pin;
part_name = part_name;
pin_name = pin_name;
partpin = pp;
data = data;
(let ((child_part_instance node_find_child (parent-composite-node, part_name))) 
enqueue_input (instance_node, new_event);)}
}


}
)))))))

}

};
// external method ((self node)) display_output_events_to_console_and_delete
// external method ((self node)) get_output_events_and_delete
// external method ((self node)) has_no_container?
function distribute_outputs_upwards (self) {
        if (esa_expr_true (has_no_container?))
{

}

{
(let ((parent container)) 
distribute_output_events;)

}

};
function busy? (self) {
        if (esa_expr_true (flagged_as_busy?))
{
return true;

}

{
(block %map (dolist (child_part_instance children) 
(let ((child_node instance_node)) 
if (esa_expr_true (has_inputs_or_outputs?))
{
return true;

}

{
if (esa_expr_true (busy?)) {

return true;

}

}
)))

}

        return false;
};
function ready? (self) {
        if (esa_expr_true (input_queue?)) {

if (esa_expr_true (busy?))
{
return false;

}

{
return true;

}


}
        return false;
};
function invoke (self) {
        (let ((e dequeue_input)) 
run_reaction (self, e);
distribute_output_events;)
};
// external method ((self node)) has_inputs_or_outputs?
// external method ((self node)) children?
// external method ((self node)) flagged_as_busy?
// external method ((self node)) dequeue_input
// external method ((self node)) input_queue?
// external method ((self node)) enqueue_input
// external method ((self node)) enqueue_output
// external method ((self node)) react
function run_reaction (self, e) {
        react (self, e);
};
function run_composite_reaction (self, e) {
        (let ((w true)) 
if (esa_expr_true (has_no_container?))
{
w = find_wire_for_self_source (kind_field, pin_name);

}

{
w = find_wire_for_source (kind_field, part_name, pin_name);

}

(block %map (dolist (dest destinations) 
{ let new_event = new event;
{ let pp = new part-pin;
if (esa_expr_true (refers_to_self?))
{
part_name = part_name;
pin_name = pin_name;
partpin = pp;
data = data;
send (self, new_event);

}

{
if (esa_expr_true (children?)) {

part_name = part_name;
pin_name = pin_name;
partpin = pp;
data = data;
(let ((child_part_instance node_find_child (self, part_name))) 
enqueue_input (instance_node, new_event);)

}

}
}
}
)))
};
// external method ((self node)) node_find_child

function dispatcher () {
this.all_parts = null;
this.top_node = null;
}
// external method ((self dispatcher)) memo_node
// external method ((self dispatcher)) set_top_node
function initialize_all (self) {
        (block %map (dolist (part all_parts) 
initialize;))
};
function distribute_all_outputs (self) {
        (block %map (dolist (p all_parts) 
distribute_output_events;
distribute_outputs_upwards;))
};
function dispatcher_run (self) {
        (let ((done true)) 
for (;;) {
done = true;
distribute_all_outputs;
(block %map (dolist (part all_parts) 
if (esa_expr_true (ready?)) {

invoke;
done = false;
(return-from %map :false)

}))
if (done) break;})
};
function dispatcher_inject (self, pin, val) {
        (let ((e create_top_event (self, pin, val))) 
enqueue_input (top_node, e);
dispatcher_run;)
};
// external method ((self dispatcher)) create_top_event

function event () {
this.partpin = null;
this.data = null;
}
