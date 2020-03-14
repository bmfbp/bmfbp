class child
  name
  kind
  instance
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
  field kind
  field container
  field name-in-container
  field map children
  install-child(node)
  enqueue-output(event)
end class

class event
  node-name
  pin-name
  data
end class

situation loadtime kind
  script loader(name kind)
  method install-child(child)
  ensure-valid-output(name)
end situation

situation build node
  script initialize
  method initially(script)
  script send(event)
end situation




script kind loader(my-name parent-container) >> node
  let n = create node in
    set n.kind = self
    set n.name-in-container = my-name
    set n.container = parent-container
    clear-queue n.input-queue
    clear-queue n.output-queue
    map child = self.children in
      let child-instance = @child.kind.loader(child.name n) in
         let c = create child in
	   set c.name = child.name
	   set c.kind = child.name
           set c.instance = child-instance
	   c.install-child(n)
	 end let
      end let
    end map
    >> n
  end let
end script

script node initialize
  map child = self.children in
    @child.instance.initialize
  end map
  self.initially(send)
end script

script node send(e)
  %% deferred send; enqueue to self.output-queue
  self.kind.ensure-valid-output(e.pin-name)
  self.enqueue-output(e)
end script

  let node-nm = e.node-name in
    self.kind.ensure-valid-child(node-nm)
    let child-kind = self.get-child-kind(node-nm) in

    end let
  end let
end script

script node distribute-outputs
  %% move event to child.input or self.output
end script
