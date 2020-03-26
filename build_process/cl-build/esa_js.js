function part-definition () {}
part-definition.prototype = {
  part-name: null
  part-kind: null
};
function named-part-instance () {}
named-part-instance.prototype = {
  instance-name: null
  instance-node: null
};
function source () {}
source.prototype = {
  part-name: null
  pin-name: null
};
function destination () {}
destination.prototype = {
  part-name: null
  pin-name: null
};
function wire () {}
wire.prototype = {
  index: null
(sources :accessor sources :initform nil)(destinations :accessor destinations :initform nil)};
function kind () {}
kind.prototype = {
  kind-name: null
  input-pins: null
  output-pins: null
  parts: null
  wires: null
};
function node () {}
node.prototype = {
  input-queue: null
  output-queue: null
  kind-field: null
  container: null
  name-in-container: null
  children: null
  busy-flag: null
};
function dispatcher () {}
dispatcher.prototype = {
(all-parts :accessor all-parts :initform nil)  top-node: null
};
function event () {}
event.prototype = {
  part-name: null
  pin-name: null
  data: null
};

event.install-input-pin = function (, G525) {};

event.install-output-pin = function (, G526) {};

event.add-input-pin = function /*script*/ (, G527) {};

event.add-output-pin = function /*script*/ (, G528) {};

event.add-part = function /*script*/ (, G529, G530) {};

event.add-wire = function /*script*/ (, G531) {};

event.install-wire = function (, G532) {};

event.install-part = function (, G533, G534) {};

event.parts = function () {};
 /*returns map part-definition*/ 


event.ensure-part-not-declared = function (, G535) {};

event.ensure-valid-input-pin = function (, G536) {};

event.ensure-valid-output-pin = function (, G537) {};

event.ensure-input-pin-not-declared = function (, G538) {};

event.ensure-output-pin-not-declared = function (, G539) {};

event.ensure-valid-source = function /*script*/ (, G540) {};

event.ensure-valid-destination = function /*script*/ (, G541) {};



event.ensure-kind-defined = function () {};



kind.add-input-pin = function /*script*/ (, name ) {

( ensure-input-pin-not-declared self  name )
( install-input-pin self  name )

};
/*end script*/

kind.add-output-pin = function /*script*/ (, name ) {

( ensure-output-pin-not-declared self  name )
( install-output-pin self  name )

};
/*end script*/

kind.add-part = function /*script*/ (, nm , k ) {

( ensure-part-not-declared self  nm )
( install-part self  nm  k )

};
/*end script*/

kind.add-wire = function /*script*/ (, w ) {

(function () {
  let s;
( sources w)
( ensure-valid-source self  s )
})();/*end map*/

(function () {
  let dest;
( destinations w)
( ensure-valid-destination self  dest )
})();/*end map*/

( install-wire self  w )

};
/*end script*/

kind.ensure-valid-source = function /*script*/ (, s ) {

if (( refers-to-self? s)) {

( ensure-valid-input-pin self ( pin-name s) )
}
else {

{
  let p =( kind-find-part self ( part-name s) );

( ensure-kind-defined p)
( ensure-valid-output-pin( part-kind p) ( pin-name s) )
}

}


};
/*end script*/

kind.ensure-valid-destination = function /*script*/ (, dest ) {

if (( refers-to-self? dest)) {

( ensure-valid-output-pin self ( pin-name dest) )
}
else {

{
  let p =( kind-find-part self ( part-name dest) );

( ensure-kind-defined p)
( ensure-valid-input-pin( part-kind p) ( pin-name dest) )
}

}


};
/*end script*/

kind.refers-to-self? = function () {};
 /*returns boolean*/ 


kind.refers-to-self? = function () {};
 /*returns boolean*/ 


kind.install-source = function (, G542, G543) {};

kind.install-destination = function (, G544, G545) {};



wire.add-source = function /*script*/ (, part , pin ) {

( install-source self  part  pin )

};
/*end script*/

wire.add-destination = function /*script*/ (, part , pin ) {

( install-destination self  part  pin )

};
/*end script*/

wire.loader = function /*script*/ (, G546, G547, G548, G549) {};
 /*returns node*/ 


wire.clear-input-queue = function () {};

wire.clear-output-queue = function () {};

wire.install-node = function (, G550) {};

wire.add-child = function /*script*/ (, G551, G552) {};



kind.loader = function /*script*/ (, my-name , my-class , my-container , dispatchr ) {

{ let inst = new my-class();

( clear-input-queue inst)
( clear-output-queue inst)

( kind-field inst) =  my-class

( container inst) =  my-container

( name-in-container inst) =  my-name
(function () {
  let part;
( parts self)
{
  let part-instance =( loader( part-kind part) ( part-name part) ( part-kind part)  inst  dispatchr );

( add-child inst  part-instance )
}

})();/*end map*/

( memo-node dispatchr  inst )
return inst;

}/*end create*/


};
/*end script*/

kind.memo-node = function (, G553) {};

kind.set-top-node = function (, G554) {};



kind.add-child = function /*script*/ (, G555, G556) {};



node.add-child = function /*script*/ (, nm , nd ) {

( install-child self  nm  nd )

};
/*end script*/

node.initialize-all = function /*script*/ () {};



dispatcher.initialize-all = function /*script*/ () {

(function () {
  let part;
( all-parts self)
( initialize part)
})();/*end map*/


};
/*end script*/

dispatcher.initialize = function /*script*/ () {};

dispatcher.initially = function () {};



node.initialize = function /*script*/ () {

( initially self)

};
/*end script*/

node.send = function (, G557) {};

node.distribute-output-events = function /*script*/ () {};

node.display-output-events-to-console = function () {};

node.output-events = function () {};
 /*returns map event*/ 
node.has-no-container? = function () {};
 /*returns boolean*/ 
node.distribute-outputs-upwards = function /*script*/ () {};



node.get-destination = function () {};
 /*returns destination*/ 


node.start = function /*script*/ () {};

node.distribute-all-outputs = function /*script*/ () {};

node.run = function /*script*/ () {};

node.declare-finished = function () {};



node.find-wire-for-source = function (, G558, G559) {};
 /*returns wire*/ 
node.find-wire-for-self-source = function (, G560) {};
 /*returns wire*/ 


node.busy? = function /*script*/ () {};

node.ready? = function /*script*/ () {};

node.has-inputs-or-outputs? = function () {};
 /*returns boolean*/ 
node.flagged-as-busy? = function () {};
 /*returns boolean*/ 
node.dequeue-input = function () {};

node.input-queue? = function () {};

node.enqueue-input = function (, G561) {};

node.enqueue-output = function (, G562) {};

node.react = function (, G563) {};

node.run-reaction = function /*script*/ (, G564) {};

node.run-composite-reaction = function /*script*/ (, G565) {};

node.node-find-child = function (, G566) {};
 /*returns named-part-instance*/ 


node.busy? = function /*script*/ () {

if (( flagged-as-busy? self)) {

return true;

}
else {

(function () {
  let child-part-instance;
( children self)
{
  let child-node =( instance-node child-part-instance);

if (( has-inputs-or-outputs? child-node)) {

return true;

}
else {

if (( busy? child-node)) {

return true;

}

}

}

})();/*end map*/

}

return false;


};
/*end script*/

dispatcher.start = function /*script*/ () {

( distribute-all-outputs self)
( run self)

};
/*end script*/

dispatcher.run = function /*script*/ () {

{
  let done = :true;

while (true) {

(function () {
  let part;
( all-parts self)
if (( ready? part)) {

( invoke part)

 done =  :false
return;

}

})();/*end map*/

if ( done) return;

}/*end loop*/

}

( declare-finished self)

};
/*end script*/

node.invoke = function /*script*/ () {

{
  let e =( dequeue-input self);

( run-reaction self  e )
( run-composite-reaction self  e )
( distribute-output-events self)
}


};
/*end script*/

node.ready? = function /*script*/ () {

if (( input-queue? self)) {

if (( busy? self)) {

return false;

}
else {

return true;

}

}

return false;


};
/*end script*/

dispatcher.distribute-all-outputs = function /*script*/ () {

(function () {
  let p;
( all-parts self)
( distribute-output-events p)
( distribute-outputs-upwards p)
})();/*end map*/


};
/*end script*/

node.distribute-outputs-upwards = function /*script*/ () {

if (( has-no-container? self)) {

}
else {

{
  let parent =( container self);

( distribute-output-events parent)
}

}


};
/*end script*/

node.distribute-output-events = function /*script*/ () {

if (( has-no-container? self)) {

( display-output-events-to-console self)
}
else {

{
  let parent-composite-node =( container self);

(function () {
  let output;
( output-events self)
{ let new-event = new event();

{
  let dest =( get-destination output);

if (( refers-to-self? dest)) {


( part-name new-event) = ( name-in-container self)

( pin-name new-event) = ( pin-name dest)

( data new-event) = ( data output)
( send self  new-event )
}
else {


( part-name new-event) = ( part-name dest)

( pin-name new-event) = ( pin-name dest)

( data new-event) = ( data output)
{
  let child-node =( node-find-child self ( part-name dest) );

( enqueue-input child-node  new-event )
}

}

}

}/*end create*/

})();/*end map*/

}

}


};
/*end script*/

node.run-reaction = function /*script*/ (, e ) {

( react self  e )

};
/*end script*/

node.run-composite-reaction = function /*script*/ (, e ) {

{
  let w = :true;

if (( has-no-container? self)) {


 w = ( find-wire-for-self-source( kind-field self) ( pin-name e) )
}
else {


 w = ( find-wire-for-source( kind-field( container self)) ( part-name e) ( pin-name e) )
}

(function () {
  let dest;
( destinations w)
{ let new-event = new event();

if (( refers-to-self? dest)) {


( part-name new-event) = ( part-name dest)

( pin-name new-event) = ( pin-name dest)

( data new-event) = ( data e)
( send self  new-event )
}
else {


( part-name new-event) = ( part-name dest)

( pin-name new-event) = ( pin-name dest)

( data new-event) = ( data e)
{
  let child-part-instance =( node-find-child self ( part-name dest) );

( enqueue-input( instance-node child-part-instance)  new-event )
}

}

}/*end create*/

})();/*end map*/

}


};
/*end script*/
