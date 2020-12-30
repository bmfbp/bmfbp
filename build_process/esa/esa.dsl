type name
type function
type boolean
type node-class
type value

situation reading-from-JSON
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
  map input-pins
  map output-pins
  self-class  % of type node-class % subsumes initially code, react code and instance vars (using OO), otherwise OO is overkill
  map parts
  map wires
end class

class node
  input-queue
  output-queue
  kind-field
  container
  name-in-container  %% lookup this part instance by name as a child of my container
  map children
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

%%%%
% classes for reading App from JSON
%%%%

class App
  tableOfKinds
  alist
  top-node
  json-string
end class

class JSON-object
  handle  % opaque handle - set and handled by underlying language (e.g. cl-user-esa-methods.lisp)
end class

class JSON-array
  handle  % opaque handle - set and handled by underlying language (e.g. cl-user-esa-methods.lisp)
end class

class foreign
  handle
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
  method install-class(node-class)
  method install-wire(wire)
  method install-part(name kind node-class)
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
  % self is a schematic ==> sources and all dests must be contained as children, or, refer to "self"
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
  script add-source(name name)
  script add-destination(name name)
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
  method display-output-events-to-console-and-delete
  method get-output-events-and-delete >> map event
  method has-no-container? >> boolean
  script distribute-outputs-upwards
end when

%=== running ===

when running dispatcher
  script distribute-all-outputs
  script dispatcher-run
  script dispatcher-inject
  method create-top-event(name value) >> event
end when

when running kind
  method find-wire-for-source(name name) >> wire
  method find-wire-for-self-source(name) >> wire
end when

when running node
  script busy?
  script ready?
  script invoke
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

script dispatcher dispatcher-run
  let done = true in
    loop
      set done = true
      @self.distribute-all-outputs
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
end script

script dispatcher dispatcher-inject(pin val)
  let e = self.create-top-event(pin val) in
    self.top-node.enqueue-input(e)
    @self.dispatcher-run
  end let
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
      @parent.distribute-output-events
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
    self.display-output-events-to-console-and-delete
  else
    let parent-composite-node = self.container in
       map output = self.get-output-events-and-delete in
         let dest = output.partpin in
           let w = parent-composite-node.kind-field.find-wire-for-source(output.partpin.part-name output.partpin.pin-name) in
             map dest = w.destinations in
               if dest.refers-to-self? then
                 % case 2
                 create new-event = event in
                   create pp = part-pin in
                     set pp.part-name = parent-composite-node.name-in-container
                     set pp.pin-name = dest.pin-name
                     set new-event.partpin = pp
                     set new-event.data = output.data
                     parent-composite-node.send(new-event)
                   end create
                 end create
               else
                 % case 1 - the common case - child outputs to input of another child
                 create new-event = event in
                   create pp = part-pin in
                     set pp.part-name = dest.part-name
                     set pp.pin-name = dest.pin-name
                     set new-event.partpin = pp
                     set new-event.data = output.data
                     let child-part-instance = parent-composite-node.node-find-child(pp.part-name) in
                       child-part-instance.instance-node.enqueue-input(new-event)
                     end let
                   end create
                 end create
               end if
             end map
           end let
         end let
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





%%%%%%%%%
when reading App
  script read-json >> kind  % returns kind of top schematic
  method initialize
  method fatalErrorInBuild
  method JSON >> JSON-array
  method nothing >> kind
  method lookupKind (name) >> kind
  method installInTable (name kind)
end when

when reading kind
  method schematicCommonClass >> foreign
  method make-type-name (name) >> foreign
  script read-leaf (JSON-object)
  script read-schematic (App JSON-object)
  script make-input-pins (JSON-array)
  script make-output-pins (JSON-array)
  script make-leaf-input-pins (JSON-object)
  script make-leaf-output-pins (JSON-object)
  script make-schematic-input-pins (JSON-object)
  script make-schematic-output-pins (JSON-object)
  method load-file (name)
end when

when reading JSON-array
  method as-map >> map JSON-object
end when

when reading JSON-object
  method isLeaf >> boolean
  method isSchematic >> boolean
  method name >> name

  % level 0
  method itemKind >> name      % "leaf" or "schematic"

  % level 1 "leaf"
  method kind >> name          % name of Kind
  method filename >> filename  % filename template with "$" to represent (any) root directory 
  method inPins >> JSON-array  % array of names
  method outPins >> JSON-array % array of names


  % level 1 "schematic"

  method schematic >> JSON-object
  %method name >> name

  % level 2
  method inputs >> JSON-array
  method outputs >> JSON-array
  method parts >> JSON-array
  method wiring >> JSON-array

  % level 3a
  method partName >> name
  method kindName >> name

  % level 3b
  method wireIndex >> foreign
  method sources >> JSON-array
  method receivers >> JSON-array

  % level 4
  method part >> name
  method pin >> name

  % itemKind == "schematic"
  % valid: itemKind, name, schematic
  %   level 2: name, inputs, outputs, parts, wiring
  %     level 3a part: partName, kindName
  %     level 3b wiring: wireIndex, sources, receivers
  %       level 4 (source & receiver): part, pin

  % (the above could be better - every part shuld have kind, inPins and outPins, but I backed into the above structure by trial and error)

end when

script App read-json >> kind
    let top-schematic = self.nothing in
    self.initialize
    let JSON-arr = self.JSON in
      let arr = JSON-arr.as-map in
	map json-object-part = arr in
          create newKind = kind in
	    set newKind.kind-name = json-object-part.name
	    if json-object-part.isLeaf then
	      @newKind.read-leaf (json-object-part)
	    else
	      if json-object-part.isSchematic then
		@newKind.read-schematic (self json-object-part)
		set top-schematic = newKind
	      else
		self.fatalErrorInBuild
	      end if
	    end if
	    self.installInTable (newKind.kind-name newKind)
          end create
	end map
      end let 
    end let
    >> top-schematic
    end let
end script

script kind read-leaf (json-object-part)
  let kindName = json-object-part.kind in
    let filename = json-object-part.filename in
      set self.self-class = self.make-type-name (kindName)
      self.load-file (filename)
      @self.make-leaf-input-pins (json-object-part)
      @self.make-leaf-output-pins (json-object-part)
    end let
  end let
end script

script kind read-schematic (app json-object-part)
  let schematicName = json-object-part.name in
      set self.self-class = self.schematicCommonClass
      let schematic = json-object-part.schematic in
	@self.make-schematic-input-pins (schematic)
	@self.make-schematic-output-pins (schematic)

	let parts = schematic.parts.as-map in
	  map json-child = parts in
	    let child-kind-name = json-child.kindName in
	      let child-name = json-child.partName in 
		let child-kind = app.lookupKind (child-kind-name) in
		  self.add-part (child-name child-kind child-kind.self-class)
		end let
	      end let
	    end let
	   end map
	 end let

	let wires = schematic.wiring.as-map in
	  map json-wire = wires in
	    create newWire = wire in
              set newWire.index = json-wire.wireIndex
	      let sources = json-wire.sources.as-map in
		map json-source = sources in
                  newWire.add-source (json-source.part json-source.pin)
		end map
	      end let

	      let receivers = json-wire.receivers.as-map in
		map json-receiver = receivers in
                  newWire.add-destination (json-receiver.part json-receiver.pin)
		end map
	      end let

	      self.add-wire (newWire)
	    end create
	  end map
	end let
      end let
    end let
end script


script kind make-input-pins (json-pin-array)
  let pin-map = json-pin-array.as-map in
    map pin-name = pin-map in
      self.add-input-pin (pin-name)
    end map
  end let
end script

script kind make-output-pins (json-pin-array)
  let pin-map = json-pin-array.as-map in
    map pin-name = pin-map in
      self.add-output-pin (pin-name)
    end map
  end let
end script

script kind make-leaf-input-pins (json-object-part)
  @self.make-input-pins (json-object-part.inPins)
end script

script kind make-schematic-input-pins (json-object-schematic)
  @self.make-input-pins (json-object-schematic.inputs)
end script

script kind make-leaf-output-pins (json-object-part)
  @self.make-output-pins (json-object-part.outPins)
end script

script kind make-schematic-output-pins (json-object-schematic)
  @self.make-output-pins (json-object-schematic.outputs)
end script
