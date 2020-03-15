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
  initially
  react
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
end class

class dispatcher
  map all-parts
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
  method install-initially-function(function)
  method install-react-function(function)
  script add-part(name kind)
  script add-wire(wire)
  method install-wire(wire)
  method install-part(name kind)
  method parts-map >> map part-definition
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
      p.part-kind.ensure-valid-output-pin(s.pin-name)
    end let
  end if
end script

script kind ensure-valid-destination(dest)
  if dest.refers-to-self? then
    self.ensure-valid-output-pin(dest.pin-name)
  else
    let p = self.find-child(dest.part-name) in
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
  self.install-source(part pin)
end script


%=== instantiating parts ===

when loading kind
  script loader(name node) >> node
end when

when loading node
  method clear-input-queue
  method clear-output-queue
  % method children >> map node
end when

script kind loader(my-name my-container) >> node
  create instance = node in
    instance.clear-input-queue
    instance.clear-output-queue
    set instance.kind-field = self
    set instance.container = my-container
    set instance.name-in-container = my-name
      map part-def = self.parts-map in
        let child-instance = @part-def.kind-field.loader(part-def.part-name self) in
	  @instance.add-part(part-def.part-name self)  % each child has a name that is local to the container (names are determined by kind)
        end let
      end map
    >> instance
  end create
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
  method output-events >> map event
end when

%=== running ===

when running dispatcher
  script start
  script distribute-all-outputs
  script run
end when

when running node
  script busy?
  script ready?
  method dequeue-input
  method input-queue?
  method enqueue-input(event)
  method enqueue-output(event)
  method find-wire-for-source(name name) >> wire
end when

script node busy? >> boolean
  map child = self.children in
    if @child.busy? then
      >> true
    end if
  end map
  >> false
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
  end loop
end script

script node invoke
  let e = self.dequeue-input in
    self.react(e)
    @self.distribute-output-events
  end let
end script

script node ready? >> boolean
  if self.input-queue? then
    >> true
  end if
  >> false
end script

script dispatcher distribute-all-outputs
  map p = self.all-parts in
    @p.distribute-output-events
  end map
end script

script node distribute-output-events
  let parent-composite = self.container in
    let parent-kind = parent-composite.kind-field in
       let output = map self.output-events in
         let w = parent-composite.find-wire-for-source(output.part-name output.pin-name) in
           map dest = w.destinations in
             if dest.refers-to-self? then
	       create output-event = event in
                 set output-event.part-name = dest.part-name
		 set output-event.pin-name = dest.pin-name
		 set output-event.data = output.data
		 self.enqueue-output(output-event)
	       end create
	     else
	       % the wire has already been validated
	       % wiring is by-name and contained in the kind of the container
	       % ==> every part-pin (by name) pair is valid
	       let dest-part-name = dest.part-name in
	         let part-instance = self.find-child(dest.part-name) in
		   create input-event = event in
		     set input-event.part-name = dest.part-name
                     set input-event.pin-name = dest.pin-name
                     set input-event.data = output.data
                     part-instance.enqueue-input(input-event)
                   end create
		 end let
               end let
              end if
            end map
         end let
       end let
    end let
  end let
end script

