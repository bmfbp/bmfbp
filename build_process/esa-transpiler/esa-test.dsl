type name
type function
type boolean
type node-class

situation building
situation building-aux
situation loading
situation initializing
situation running

class part-definition
  part-name
  part-kind
end class

class named-part-instance
  instance-name
  instance-node
end class

class part-pin
  part-name
  pin-name
end class

class source
  part-name  % a name or "self"
  pin-name
end class

class destination
  part-name
  pin-name
end class

class wire
  index
  map sources
  map destinations
end class

class kind
  kind-name
  input-pins
  self-class  % of type node-class % subsumes initially code, react code and instance vars (using OO), otherwise OO is overkill
  output-pins
  parts
  wires
end class

class node
  input-queue
  output-queue
  kind-field
  container
  name-in-container  %% lookup this part instance by name as a child of my container
  children
  busy-flag
end class

class dispatcher
  map all-parts
  top-node
end class

class event
  partpin
  data
end class

%=== building kinds ===

when building kind
  method install-input-pin(name)
  method install-output-pin(name)
  script add-input-pin(name)
  script add-output-pin(name)
  % method install-initially-function(function)
  script add-part(name kind node-class)
  script add-wire(wire)
  method install-wire(wire)
  method install-part(name kind node-class)
  method parts >> map part-definition
end when

when building-aux kind
  method install-class(node-class)
  method ensure-part-not-declared(name)
  method ensure-valid-input-pin(name)
  method ensure-valid-output-pin(name)
  method ensure-input-pin-not-declared(name)
  method ensure-output-pin-not-declared(name)
  script ensure-valid-source(source)
  script ensure-valid-destination(destination)
end when

when building part-definition
  method ensure-kind-defined	
end when

script kind ensure-valid-source(s)
  xx
end script

when building source
  method refers-to-self? >> boolean %% true if self.part-name == "self"
end when

when building destination 
  method refers-to-self? >> boolean %% true if self.part-name == "self"
end when

when building wire
  method install-source(name name)
  method install-destination(name name)
end when


%=== instantiating parts ===

when loading kind
%                    node=runtime-container
%                    |
%                    V
  script loader(name node dispatcher) >> node
end when

when loading node
  method clear-input-queue
  method clear-output-queue
  method install-node(node)
  script add-child(name node)
  % method children >> map named-part-instance
end when

when loading dispatcher
  method memo-node(node)
  method set-top-node(node)
end when

script node add-child(nm nd)
  self.install-child(nm nd)
end script
%=== initializing ===

when initializing dispatcher
  script initialize-all
end when

script dispatcher initialize-all
  map part = self.all-parts in
    @part.initialize
  end map
end script

when initializing node
  script initialize
  method initially  % can call SEND, but distribution of events deferred until running
end when

%=== overlapping methods ===

when intializing or running node
  method send(event)
  script distribute-output-events
  method display-output-events-to-console-and-delete
  method get-output-events-and-delete >> map event
  method has-no-container? >> boolean
  script distribute-outputs-upwards
end when

%=== running ===

when running dispatcher
  script start
  script distribute-all-outputs
  script run
  method declare-finished
end when

when running kind
  method find-wire-for-source(name name) >> wire
  method find-wire-for-self-source(name) >> wire
end when

when running node
  script busy?
  script ready?
  method has-inputs-or-outputs? >> boolean
  method children? >> boolean
  method flagged-as-busy? >> boolean
  method dequeue-input
  method input-queue?
  method enqueue-input(event)
  method enqueue-output(event)
  method react(event)
  script run-reaction(event)
  script run-composite-reaction(event)
  method node-find-child(name) >> named-part-instance
end when
