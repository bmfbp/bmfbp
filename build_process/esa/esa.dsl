types
  true/false
  name
  definition/wire
  loadtime/node
  definition/node
  loadtime/dispatcher
  runtime/output-event % {node, pin, data}
  runtime/wire % { source, map of runtime/destination }
  runtime/destination % { node, pin }
end types

class definition/node {
  script add-input-pin(name)
  script add-output-pin(name)
  script add-part(name kind)
  method install-wire(definition/wire)

  method create-loadtime >> loadtime/node
  method script loader  >> loadtime/node
}
  
class loadtime/node proto definition/node {
  method add-child(loadtime/node)
  script initializer
  method parts
  method initially
  method output-events >> map runtime/output-event
  }

class loadtime/dispatcher {
  method all-nodes >> map loadtime/node
  }

class runtime/output-event {
  find-wire >> runtime/wire
  }

class runtime/wire {
  script distribute-event(output-event)
  }

class runtime/dispatcher {
  method get-node >> runtime/node
  }

class runtime/node {
  script ready? >> true/false
  script busy? >> true/false
  method busy-self? >> true/false
  method children >> map of runtime/node
  script dispatch-outputs
  method output-events >> map runtime/output-event
  }




% helpers 

methods definition/node {
  method ensure-input-pin-not-defined(name)
  method ensure-output-pin-not-defined(name)
  method ensure-part-not-defined(name)
  method install-input-pin(name)
  method install-output-pin(name)
  method install-part(name definition/node)
}

