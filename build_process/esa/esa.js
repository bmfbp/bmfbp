// esa.js

function part-definition () {
this.part-name = null;
this.part-kind = null;
}
// external method ((self part-definition)) ensure-kind-defined

function named-part-instance () {
this.instance-name = null;
this.instance-node = null;
}

function part-pin () {
this.part-name = null;
this.pin-name = null;
}

function source () {
this.part-name = null;
this.pin-name = null;
}
// external method ((self source)) refers-to-self?

function destination () {
this.part-name = null;
this.pin-name = null;
}
// external method ((self destination)) refers-to-self?

function wire () {
this.index = null;
this.sources = null;
this.destinations = null;
}
// external method ((self wire)) install-source
// external method ((self wire)) install-destination
function add-source (self, part, pin) {
        install-source (self, part, pin);
};
function add-destination (self, part, pin) {
        install-destination (self, part, pin);
};

function kind () {
this.kind-name = null;
this.input-pins = null;
this.self-class = null;
this.output-pins = null;
this.parts = null;
this.wires = null;
}
// external method ((self kind)) install-input-pin
// external method ((self kind)) install-output-pin
function add-input-pin (self, name) {
        ensure-input-pin-not-declared (self, name);
        install-input-pin (self, name);
};
function add-output-pin (self, name) {
        ensure-output-pin-not-declared (self, name);
        install-output-pin (self, name);
};
function add-part (self, nm, k, nclass) {
        ensure-part-not-declared (self, nm);
        install-part (self, nm, k, nclass);
};
function add-wire (self, w) {
        (block %map (dolist (s sources) 
ensure-valid-source (self, s);))
        (block %map (dolist (dest destinations) 
ensure-valid-destination (self, dest);))
        install-wire (self, w);
};
// external method ((self kind)) install-wire
// external method ((self kind)) install-part
// external method ((self kind)) parts
// external method ((self kind)) install-class
// external method ((self kind)) ensure-part-not-declared
// external method ((self kind)) ensure-valid-input-pin
// external method ((self kind)) ensure-valid-output-pin
// external method ((self kind)) ensure-input-pin-not-declared
// external method ((self kind)) ensure-output-pin-not-declared
function ensure-valid-source (self, s) {
        if (esa_expr_true (refers-to-self?))
{
ensure-valid-input-pin (self, pin-name);

}

{
(let ((p kind-find-part (self, part-name))) 
ensure-kind-defined;
ensure-valid-output-pin (part-kind, pin-name);)

}

};
function ensure-valid-destination (self, dest) {
        if (esa_expr_true (refers-to-self?))
{
ensure-valid-output-pin (self, pin-name);

}

{
(let ((p kind-find-part (self, part-name))) 
ensure-kind-defined;
ensure-valid-input-pin (part-kind, pin-name);)

}

};
function loader (self, my-name, my-container, dispatchr) {
        (let ((clss self-class)) 
(let ((inst (make-instance clss)))
clear-input-queue;
clear-output-queue;
kind-field = self;
container = my-container;
name-in-container = my-name;
(block %map (dolist (part parts) 
(let ((part-instance loader (part-kind, part-name, inst, dispatchr))) 
add-child (inst, part-name, part-instance);)))
memo-node (dispatchr, inst);
return loader;))
};
// external method ((self kind)) find-wire-for-source
// external method ((self kind)) find-wire-for-self-source

function node () {
this.input-queue = null;
this.output-queue = null;
this.kind-field = null;
this.container = null;
this.name-in-container = null;
this.children = null;
this.busy-flag = null;
}
// external method ((self node)) clear-input-queue
// external method ((self node)) clear-output-queue
// external method ((self node)) install-node
function add-child (self, nm, nd) {
        install-child (self, nm, nd);
};
function initialize (self) {
        initially;
};
// external method ((self node)) initially
// external method ((self node)) send
function distribute-output-events (self) {
        if (esa_expr_true (has-no-container?))
{
display-output-events-to-console-and-delete;

}

{
(let ((parent-composite-node container)) 
(block %map (dolist (output get-output-events-and-delete) 
(let ((dest partpin)) 
(let ((w find-wire-for-source (kind-field, part-name, pin-name))) 
(block %map (dolist (dest destinations) 
if (esa_expr_true (refers-to-self?))
{
{ let new-event = new event;
{ let pp = new part-pin;
part-name = name-in-container;
pin-name = pin-name;
partpin = pp;
data = data;
send (parent-composite-node, new-event);}
}


}

{
{ let new-event = new event;
{ let pp = new part-pin;
part-name = part-name;
pin-name = pin-name;
partpin = pp;
data = data;
(let ((child-part-instance node-find-child (parent-composite-node, part-name))) 
enqueue-input (instance-node, new-event);)}
}


}
)))))))

}

};
// external method ((self node)) display-output-events-to-console-and-delete
// external method ((self node)) get-output-events-and-delete
// external method ((self node)) has-no-container?
function distribute-outputs-upwards (self) {
        if (esa_expr_true (has-no-container?))
{

}

{
(let ((parent container)) 
distribute-output-events;)

}

};
function busy? (self) {
        if (esa_expr_true (flagged-as-busy?))
{
return true;

}

{
(block %map (dolist (child-part-instance children) 
(let ((child-node instance-node)) 
if (esa_expr_true (has-inputs-or-outputs?))
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
        if (esa_expr_true (input-queue?)) {

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
        (let ((e dequeue-input)) 
run-reaction (self, e);
distribute-output-events;)
};
// external method ((self node)) has-inputs-or-outputs?
// external method ((self node)) children?
// external method ((self node)) flagged-as-busy?
// external method ((self node)) dequeue-input
// external method ((self node)) input-queue?
// external method ((self node)) enqueue-input
// external method ((self node)) enqueue-output
// external method ((self node)) react
function run-reaction (self, e) {
        react (self, e);
};
function run-composite-reaction (self, e) {
        (let ((w true)) 
if (esa_expr_true (has-no-container?))
{
w = find-wire-for-self-source (kind-field, pin-name);

}

{
w = find-wire-for-source (kind-field, part-name, pin-name);

}

(block %map (dolist (dest destinations) 
{ let new-event = new event;
{ let pp = new part-pin;
if (esa_expr_true (refers-to-self?))
{
part-name = part-name;
pin-name = pin-name;
partpin = pp;
data = data;
send (self, new-event);

}

{
if (esa_expr_true (children?)) {

part-name = part-name;
pin-name = pin-name;
partpin = pp;
data = data;
(let ((child-part-instance node-find-child (self, part-name))) 
enqueue-input (instance-node, new-event);)

}

}
}
}
)))
};
// external method ((self node)) node-find-child

function dispatcher () {
this.all-parts = null;
this.top-node = null;
}
// external method ((self dispatcher)) memo-node
// external method ((self dispatcher)) set-top-node
function initialize-all (self) {
        (block %map (dolist (part all-parts) 
initialize;))
};
function distribute-all-outputs (self) {
        (block %map (dolist (p all-parts) 
distribute-output-events;
distribute-outputs-upwards;))
};
function dispatcher-run (self) {
        (let ((done true)) 
for (;;) {
done = true;
distribute-all-outputs;
(block %map (dolist (part all-parts) 
if (esa_expr_true (ready?)) {

invoke;
done = false;
(return-from %map :false)

}))
if (done) break;})
};
function dispatcher-inject (self, pin, val) {
        (let ((e create-top-event (self, pin, val))) 
enqueue-input (top-node, e);
dispatcher-run;)
};
// external method ((self dispatcher)) create-top-event

function event () {
this.partpin = null;
this.data = null;
}
