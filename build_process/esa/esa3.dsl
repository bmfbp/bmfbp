type name
type function
type true/false

situation building
situation building-aux
situation loading
situation initializing
situation running

class part
  part-name
  part-kind
end class

class source
  part-name  % a name or "self"
  pin-name
end class

class destination
  part-name  % a name or "self"
  pin-name
end class

class wire
  source
  map destinations
end class

class kind
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
end when

when building-aux kind
  method ensure-input-pin-not-declared(name)
  method ensure-output-pin-not-declared(name)
  script ensure-valid-source(source)
  script ensure-valid-destination(destination)
end when

when building source
  method self? >> true/false %% true if self.part-name == "self"
end when

when building destination 
  method self? >> true/false %% true if self.part-name == "self"
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
  % self is a container ==> source and all dests must be contained as children, or, refer to "self"
  @self.ensure-valid-source(w.source)
  map dest = w.destinations in
    @self.ensure-valid-destination(dest)
  end map
  self.install-wire(wire)
end script

script kind ensure-valid-source(s)
  if s.self? then
    self.ensure-valid-input-pin(s.pin)
  else
    let p = self.find-child(s.part) in
      p.kind-field.ensure-valid-output-pin(s.pin)
    end let
  end if
end script

script kind ensure-valid-destination(dest)
  if dest.self? then
    self.ensure-valid-output-pin(dest.pin)
  else
    let p = self.find-child(dest.part) in
      p.kind-field.ensure-valid-input-pin(dest.pin)
    end let
  end if
end script

%=== building wires ===

when building wire
  method install-source(name name)
  method install-destination(name name)
end when

script wire set-source(part pin)
  self.ensure-source-empty
  self.install-source(part pin)
end script

script wire add-destination(part pin)
  self.install-source(part pin)
end script


%=== instantiating parts ===

when loading kind
  script loader >> node
end when

when loading node
  method clear-input-queue
  method clear-output-queue
end when

script kind loader(my-name my-container) >> node
  create instance = node in
    node.clear-input-queue
    node.clear-output-queue
    set node.kind-field = self
    set node.container = my-container
    set node.name-in-container = my-name
    create parts = map node in
      map part = self.parts in
        let child-instance = @part.kind-field.loader (part.name self) in
	  @self.add-part(part.name self)  % each child has a name that is local to the container (names are determined by kind)
        end let
      end map
    end create
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
  script 
end when

script node busy? >> true/false
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

script dispatcher distribute-all-outputs
end script

script dispatcher run
  loop
    map part = self.all-parts in
      if @part.ready? then
        @part.invoke
        quit-map
      end if
    end map
  end loop
end script

script node invoke(e)
  part.react(e)
  @part.distribute-output-events
end script

script node ready? >> true/false
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
             if dest.self? then
	       create output-event = event in
                 set output-event.part-name = dest.part-name
		 set output-event.part-pin = dest.pin-name
		 set output-event.data = ouput.data
		 self.enqueue-output(output-event)
	       end create
	     else
	       % the wire has already been validated
	       % wiring is by-name and contained in the kind of the container
	       % ==> every part-pin (by name) pair is valid
	       let dest-part-name = dest.part-name in
	         let part-instance = self.find-instance-by-name(dest-part-name) in
		   create input-event = event in
		     set input-event.part-name = dest-part-name
                     set input-event.part-pin = dest.pin-name
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

