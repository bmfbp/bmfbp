type name
type function
type boolean

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
  has-container? >> boolean
  children
  node-find-child(name) >> named-part-instance
  busy-flag
end class

class dispatcher
  map all-parts
  top-node
end class

class event
  part-name
  pin-name
  data
end class

%=== building kinds ===

when building kind
  method install-input-pin(name)
  method install-output-pin(name)
  script add-input-pin(name)
  script add-output-pin(name)
  % method install-initially-function(function)
  script add-part(name kind)
  script add-wire(wire)
  method install-wire(wire)
  method install-part(name kind)
  method parts >> map part-definition
end when

when building-aux kind
  method ensure-part-not-declared(name)
  method ensure-valid-input-pin(name)
  method ensure-valid-output-pin(name)
  method ensure-input-pin-not-declared(name)
  method ensure-output-pin-not-declared(name)
  script ensure-valid-source(source)
  script ensure-valid-destination(destination)
  method find-child(name)
end when

when building part-definition
  method ensure-kind-defined	
end when

script kind add-input-pin(name)
   self.ensure-input-pin-not-declared(name)
   self.install-input-pin(name)
end script

script kind add-output-pin(name)
   self.ensure-output-pin-not-declared(name)
   self.install-output-pin(name)
end script

script kind add-part(nm k)
  self.ensure-part-not-declared(nm)
  self.install-part(nm k)
end script

script kind add-wire(w)
  % self is a container ==> sources and all dests must be contained as children, or, refer to "self"
  map s = w.sources in
    @self.ensure-valid-source(s)
  end map
  map dest = w.destinations in
    @self.ensure-valid-destination(dest)
  end map
  self.install-wire(w)
end script

script kind ensure-valid-source(s)
  if s.refers-to-self? then
    self.ensure-valid-input-pin(s.pin-name)
  else
    let p = self.find-child(s.part-name) in
      p.ensure-kind-defined
      p.part-kind.ensure-valid-output-pin(s.pin-name)
    end let
  end if
end script

script kind ensure-valid-destination(dest)
  if dest.refers-to-self? then
    self.ensure-valid-output-pin(dest.pin-name)
  else
    let p = self.find-child(dest.part-name) in
      p.ensure-kind-defined
      p.part-kind.ensure-valid-input-pin(dest.pin-name)
    end let
  end if
end script

%=== building wires ===

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

script wire add-source(part pin)
  self.install-source(part pin)
end script

script wire add-destination(part pin)
  self.install-destination(part pin)
end script


%=== instantiating parts ===

when loading kind
  script loader(name node dispatcher) >> node
end when

when loading node
  method clear-input-queue
  method clear-output-queue
  method install-node(node)
  script add-child(name node)
  % method children >> map named-part-instance
end when

script kind loader(my-name my-container dispatchr) >> node
  let my-kind = self in
    create node-instance = node in
      node-instance.clear-input-queue
      node-instance.clear-output-queue
      set node-instance.kind-field = my-kind
      set node-instance.container = my-container
      set node-instance.name-in-container = my-name
      map part-def = my-kind.parts in
	let child-instance = @part-def.part-kind.loader(part-def.part-name node-instance dispatchr) in % name, container (a node), dispatcher
	  @node-instance.add-child(part-def.part-name child-instance)  % each child has a name that is local to the container (names are determined by kind)
	end let
      end map
      dispatchr.memo-node(node-instance)
      >> node-instance
    end create
  end let
end script

when loading dispatcher
  method memo-node(node)
  method set-top-node(node)
end when

when loading node
  script add-child(name node)
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

script node initialize
  self.initially
end script

%=== overlapping methods ===

when intializing or running node
  method send(event)
  script distribute-output-events
  method display-output-events-to-console
  method output-events >> map event
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

when running node
  script busy?
  script ready?
  method has-inputs-or-outputs? >> boolean
  method flagged-as-busy? >> boolean
  method dequeue-input
  method input-queue?
  method enqueue-input(event)
  method enqueue-output(event)
  method find-wire-for-source(name name) >> wire
  script react(event)
end when

script node busy? >> boolean
  % atomically
  if self.flagged-as-busy? then
    >> true
  else
    map child-part-instance = self.children in
      let child-node = child-part-instance.instance-node in
	if child-node.has-inputs-or-outputs? then
	  >> true
	else
	  if @child-node.busy? then
	    >> true
	  end if
	end if
      end let
    end map
  end if
  >> false
  % end atomically
end script

script dispatcher start
  @self.distribute-all-outputs
  @self.run
end script


script dispatcher run
  loop
    map part = self.all-parts in
      if @part.ready? then
        @part.invoke
        exit-map
      end if
    end map
    exit-when true
  end loop
  self.declare-finished
end script

script node invoke
  let e = self.dequeue-input in
    @self.react(e)
    @self.distribute-output-events
  end let
end script

script node ready? >> boolean
  % atomically
    if self.input-queue? then
      if @self.busy? then
        >> false
      else
        >> true
      end if
    end if
    >> false
  % end atomically
end script

script dispatcher distribute-all-outputs
  map p = self.all-parts in
    @p.distribute-output-events
  end map
  @p.distribute-outputs-upwards
end script

script node distribute-outputs-upwards
  % if node create an output event on the parent, then distribute parent's output
  if node.has-no-container? then  
    %% stops upward recursion at top node (no container)
  else
    let parent = node.container in
      parent.distribute-output-events
    end let
  end if 
end script

script node distribute-output-events
  % an output event can be delivered to three possible places
  % 1. a child (part/pin) [most common]
  % 2. the parent's output pin ("self"/pin)
  % 3. the console if this is the top part (no container)
  if self.has-no-container? then
    % condition 3.
    self.display-output-events-to-console
  else
    let parent-composite-node = self.container in
       map output = self.output-events in
	 let w = parent-composite-node.find-wire-for-source(output.part-name output.pin-name) in
	   map dest = w.destinations in
	     if dest.refers-to-self? then
               % condition 2.
	       create output-event = event in
		 set output-event.part-name = dest.part-name % "self"
		 set output-event.pin-name = dest.pin-name
		 set output-event.data = output.data
		 self.enqueue-output(output-event)
	       end create
	     else
               % condition 1.
	       % the wire has already been validated
	       % wiring is by-name and contained in the kind of the container
	       % ==> every part-pin (by name) pair is valid
	       let dest-part-name = dest.part-name in
		 let child-named-instance = self.node-find-child(dest.part-name) in
                   let child-node = child-named-instance.instance-node in
		     create input-event = event in
		       set input-event.part-name = dest.part-name
		       set input-event.pin-name = dest.pin-name
		       set input-event.data = output.data
		       child-node.enqueue-input(input-event)
		     end create
		   end let
		 end let
	       end let
	      end if
	    end map
	 end let
       end map
    end let
  end if
end script

script node react(e)
  % composite reaction
  % composites distribute their inputs to 
  % 1. children [most common], or,
  % 2. to self.output(s) as appropriate

  % bottom of the react call-chain
  % code parts should override / augment this method

  let w = self.find-wire-for-source(e.part-name e.pin-name) in
    map dest = w.destinations in
      create new-event = event in
	if dest.refers-to-self? then
	<< deliver output event >>
	  % self.in going to out must go to an output pin
	  % this has already been checked during build
	  set new-event.part-name = dest.part-name  %% "self" in this case
	  set new-event.pin-name = dest.pin-name
	  set new-event.data = e.data
	  self.send(new-event)
	else
	  % else, must go to an input of a child
	  set new-event.part-name = dest.part-name
	  set new-event.pin-name = dest.pin-name
	  set new-event.data = e.data
	  let child-part-instance = self.node-find-child(dest.part-name)
	    let child-node = child-part-instance.instance-node in
	      child-node.enqueue-input(new-event)
	    end let
	  end let
	  <>.enqueue-input(new-event)
	end if
      end create
    end map
  end let
end script

<<< todo: node.find-child with name "self" -> pi.part-name=self >>>