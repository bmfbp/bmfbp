script definition/node.loader(container) >> runtime/node
  let node = create-runtime/node in
    setkind node = self
    map child = node.get-parts in
      let child-instance = @child.loader(node) in
         node.install-child(child-instance)
      end let
    end map
    @node.initializer
    >> node
  end let
end script

xxx interfaces? xxx


class child
  name
  kind
end class

class kind
  field input-pins map name
  field output-pins map name
  field children child
  field wires map wire
end class

class node
  field input-queue
  field output-queue
end class

class event
  field node-name
  field pin-name
  field data
end class

class part-pin
  field node
  field pin
end class

class wire
  field source           %% part-pin
  field map destinations %% map of part-pin
end class
  
interace kind : loadtime
  script loader(container) >> node
  method install-child(node)
  script initializer
  method initially
  script send(event)
  method get-outputs
end interface

interface node : runtime
  delegate send(event) to :loadtime:node.send(event)
  defmethod react(event)
  delegate get-outputs >> map event to :loadtime : node get-outputs
  method enqueue-output(event)
  method enqueue-input(event)
  method-find-wire-from-source(node pin) >> wire
end interface

interface node : container
  method ensure-valid-source-in-kind(node pin)  %% checked against kind, not instance
end interface

interface wire : runtime
  script distribute-event(event)
end interface

interface node : runtime-busy
  method busy? >> true/false
  script ready? >> true/false
end interface

interface node : aux
  method ensure-valid-output-pin(pin)
  script make-jit-wire-from-kind(node pin)
  script ensure-valid-source-in-kind(node pin)
end interface

situation kind : runtime-seach-kind
  method ensure-valid-source(node pin)
  method ensure-valid-child-name(name)
  method ensure-valid-output-pin(name)
end situation



    set n.kind = self
    map child = n.children in
      let child-instance = @child.loader(n) in
        n.install-child(child-instance)
      end let		 
    end map
  end let
end script

script :loadtime node send(event)
  self.ensure-valid-output-pin(event.pin)
  self.enqueue-output(event)
end script

script :runtime dispatcher dispatch
  loop
    find-any n = @self.nodes.ready? in
      n.invoke
      @self.distribute-outputs(n.get-ouputs)
    end find-any
  end loop
end script

script :runtime dispatcher distribute-outputs(map event-list)
  let k = self.kind in
    map e = event-list in
      k.ensure-valid-child(e.node-name)
      k.ensure-valid-ouput-pin(e.pin-name)
    end map
  end let
end script

   map e = event-list in
     let name = e.node-name in
       n.ensure-valid-output-pin(e.pin-name)  %% redundant?  doesn't hurt (for now)
       let p = e.pin in
	 let c = self.container in
	   @c.ensure-valid-source-in-kind(n p)
	   @n.make-jit-wire-from-kind(n p)
           let w = c.find-kind-wire-from-source(n p)
             w.distribute-event(e)
           end let
	 end let
       end let
     end let
   end map
end script

script :runtime wire distribute-event(e)
  let d-list = e.get-destinations in
    map d = d-list in
      let e' = create-event in
        set e'.node = d.node
	set e'.pin = d.pin
	set e'.data = d.data
	d.node.enqueue-input(e')
      end map
    end map
  end let
end script

script :runtime node ready?
  if self.leaf? then
     >> self.busy?
  else
    notany child = self.get-parts in
      @child.busy?
    end noatny
  end if
end script

script :runtime kind ensure-valid-source-in-kind(n p)
  let k = self.kind in
    k.ensure-valid-source(n p)
  end let
end script

script :runtime node make-jit-wire-from-kind(n p)
end script

