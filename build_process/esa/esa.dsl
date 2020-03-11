type true/false
type name
type definition/wire
type loadtime/node
type definition/node
type loadtime/dispatcher
type runtime/output-event
type runtime/wire
type runtime/destination

kind runtime/destination
  field node
  field pin
end kind

kind definition/node
  script add-input-pin(name)
  script add-output-pin(name)
  script add-part(name knd)
  method install-wire(definition/wire)

  method create-loadtime >> loadtime/node
  script loader  >> loadtime/node
end kind
  
kind loadtime/node 
  proto definition/node
  method install-child(loadtime/node)
  script initializer
  method get-parts
  method initially
  method output-events >> map runtime/output-event
end kind

kind loadtime/dispatcher
  method get-nodes >> map loadtime/node
end kind

kind runtime/output-event
  field node
  field pin
  field data
  method find-wire >> runtime/wire
end kind

kind definition/wire
  field source  
  field map destinations
  script add-source(definition/node name)      % node + output-pin-name
  script add-destination(definition/node name) % node + input-pin-name
end kind

kind runtime/wire
  proto definition/wire
  script distribute-event(output-event)
  method get-destinations
  method lock
  method unlock
end kind

kind runtime/dispatcher
  method get-node >> runtime/node
end kind

kind runtime/node
  proto loadtime/node
  delegate parent
  script main(dispatcher)
  script ready? >> true/false
  script busy? >> true/false
  method busy-self? >> true/false
  method children >> map runtime/node
  script dispatch-outputs
  method output-events >> map runtime/output-event
  method enqueue-input(runtime/output-event)
end kind




% helpers 

aux definition/node
  method ensure-input-pin-not-defined(name)
  method ensure-output-pin-not-defined(name)
  method ensure-part-not-defined(name)
  method install-input-pin(name)
  method install-output-pin(name)
  method ensure-source-exists(runtime/output-event)
end aux





%% scripts

script definition/node.main(dispatcher)
  %% build graph (definition) for tree
  let tree = @self.loader in
    @tree.initializer
    @dispatcher.distribute-all-outputs
    @dispatcher.run
  end let
end script



%%  loader

script definition/node.loader >> instance
  let self-instance = create-loadtime/node ni
    map child-def = self.get-parts in
      let child-instance = @child-def.loader in
        self-instance.install-child(child-instance)
      end let
    end map
    >> self-instance
   end let
end script

script loadtime/node.initializer
  map child = self.get-parts in
    @child.initializer
  end map    
  self.initially
end script

script loadtime/dispatcher.distribute-all-outputs
  map node = self.get-nodes in
    map output-event = node.output-events in
      let wire = @output-event.find-wire in
        @wire.distribute-event(output-event)
      end let
    end map
  end map
end script

script runtime/dispatcher.run
  loop
    let node = self.get-node in
      if @node.ready? then
        node.invoke
        @node.dispatch-outputs
      end if
    end let
  end loop
end script

script runtime/node.ready? >> true/false
  if self.has-input? then
    if @self.busy? then
      >> false
    else
      >> true
    end if
  end if
end script

script runtime/node.busy? >> true/false
  if self.busy-self then
    >> true
  else
    map child = self.children in
      if @child.busy? then
        >> true
      end if
    end map
  end if
end script

script runtime/node.dispatch-outputs
  map output-event = self.output-events in
    let wire = @output-event.find-wire in
      @wire.distribute-event(output-event)
    end let
  end map
end script


script runtime/output-event.find-wire
  let schematic = self.node.parent in
    schematic.ensure-source-exists(output-event)
    let wire = schematic.find-wire(output-event) in
      @wire.distribute-event(output-event)
    end let
  end let
end script

script runtime/wire.distribute-event(output-event)
  self.lock
  let data = output-event.data in
    map dest = self.get-destinations in
      let pin = dest.pin in
        let node = dest.node in
          let new-event = create-runtime/output-event in
            set new-event.pin = pin
	    set new-event.data = data
            node.enqueue-input(new-event)
          end let
        end let
      end let
    end map
  end let
  self.unlock
end script




%% helpers
script definition/node.add-input-pin (name)
  self.ensure-input-pin-not-defined(name)
  self.install-input-pin(name)
end script

script definition/node.add-output-pin (name)
  self.ensure-output-pin-not-defined(name)
  self.install-output-pin(name)
end script

script definition/node.add-part (name knd)
  self.ensure-part-not-defined(name)
  self.install-part (name knd)
end script


