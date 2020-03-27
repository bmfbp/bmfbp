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

script kind add-input-pin(name)
   self.ensure-input-pin-not-declared(name)
   self.install-input-pin(name)
end script

script kind add-output-pin(name)
   self.ensure-output-pin-not-declared(name)
   self.install-output-pin(name)
end script

script kind add-part(nm k nclass)
  self.ensure-part-not-declared(nm)
  self.install-part(nm k nclass)
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
    let p = self.kind-find-part(s.part-name) in
      p.ensure-kind-defined
      p.part-kind.ensure-valid-output-pin(s.pin-name)
    end let
  end if
end script

script kind ensure-valid-destination(dest)
  if dest.refers-to-self? then
    self.ensure-valid-output-pin(dest.pin-name)
  else
    let p = self.kind-find-part(dest.part-name) in
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

script kind loader(my-name my-container dispatchr) >> node  % return an object that inherits from node
  let clss = self.self-class in
    create inst = *clss in
      inst.clear-input-queue
      inst.clear-output-queue
      set inst.kind-field = self
      set inst.container = my-container
      set inst.name-in-container = my-name
      map part = self.parts in  % map over kind.parts
	let part-instance = @part.part-kind.loader(part.part-name inst dispatchr) in
	  @inst.add-child(part.part-name part-instance)
	end let
      end map
      dispatchr.memo-node(inst)
      >> inst
    end create
  end let
end script

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
  let done = true in
  loop
    map part = self.all-parts in
      if @part.ready? then
        @part.invoke
	set done = false
        exit-map
      end if
    end map
    exit-when done
  end loop
  end let
  self.declare-finished
end script

script node invoke
  let e = self.dequeue-input in
    @self.run-reaction(e)
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
    @p.distribute-outputs-upwards
  end map
end script

script node distribute-outputs-upwards
  % if node create an output event on the parent, then distribute parent's output
  if self.has-no-container? then  
    %% stops upward recursion at top node (no container)
  else
    let parent = self.container in
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
    % case 3.
    self.display-output-events-to-console
  else
    let parent-composite-node = self.container in
       map output = self.output-events in
         create new-event = event in
	   let dest = output.partpin in
	     create pp = part-pin in
               if dest.refers-to-self? then
                 % case 2 - output to output pin of self
                 set pp.part-name = self.name-in-container
                 set pp.pin-name = dest.pin-name
                 set new-event.partpin = pp
                 set new-event.data = output.data
                 self.send(new-event)
               else
                 % case 1 - the common case - child outputs to input of another child
                 if self.children? then
                   set pp.part-name = dest.part-name
                   set pp.pin-name = dest.pin-name
                   set new-event.partpin = pp
                   set new-event.data = output.data
                   let child-node = self.node-find-child(dest.part-name) in
                     child-node.enqueue-input(new-event)
                   end let
                 end if
               end if
	     end create
           end let
         end create
       end map
    end let
  end if
end script


script node run-reaction(e)  % composite reaction
  self.react(e)
end script

script node run-composite-reaction(e)
  % composites distribute their inputs to 
  % 1. children [most common], or,
  % 2. to self.output(s) as appropriate

  let w = true in
    if self.has-no-container? then
      set w = self.kind-field.find-wire-for-self-source(e.partpin.pin-name)
    else	
      set w = self.container.kind-field.find-wire-for-source(e.partpin.part-name e.partpin.pin-name)
    end if
    map dest = w.destinations in
      create new-event = event in
	create pp = part-pin in
          if dest.refers-to-self? then
              % self.in going to out must go to an output pin
              % this has already been checked during build
              set pp.part-name = dest.part-name %"self"
              set pp.pin-name = dest.pin-name
              set new-event.partpin = pp
              set new-event.data = e.data
              self.send(new-event)
          else
            % else, must go to an input of a child
            if self.children? then
              set pp.part-name = dest.part-name
              set pp.pin-name = dest.pin-name
              set new-event.partpin = pp
              set new-event.data = e.data
              let child-part-instance = self.node-find-child(dest.part-name) in
                child-part-instance.instance-node.enqueue-input(new-event)
              end let
             end if
          end if
	end create
      end create
    end map
  end let
end script

