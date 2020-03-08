%
% 4 sections:
% 1. Definition
% 2. Querying
% 3. pre-runtime
% 4. runtime
%
% 0. Dispatcher
%

handles
  pin-name
  node-list
end handles

class definition/part-pin {
  create :part :pin
  }
  
class definition/wire {
  % 1 sender per wire, 1 or more receivers per wire

  create
  
  method defintion/set-sender(node output-pin)
  method definition/add-destination(node input-pin)

  method query/get-sender >> node

  method query/get-destinations >> node-list

  method build/instantiate >> runtime/wire  % clone wire, replace node with nodeInstances

  method runtime/distribute-event(runtime/event)

  }

class runtime/wire { 

  create :definition
  
  method build/instantiate

  method query/get-sender >> node

  method query/get-destinations >> node-list

  method runtime/distribute-event(runtime/event)

  }

% a definition-time node is a prototype, it (probably) contains an "instance" field along with a "kind" field
% we want to instantiate a node by grabbing the prototype, then (recursively) creating node instances for each of the children
% wires need to be instantiated, too, to point to the final instances - this might be easier if wires in the prototype nodes point to
%  empty part instance slots (or, if the nodes contain empty slots), then, when we clone a part, all of the wiring is simply
%  copied and (already) points to part instances (wires can be shared, as long as they point to instances).

class definition/node {

  method definiton/create
  
  method definition/add-input(pin-name) % add name to self.inputs, check that all input names are unique
  method definition/add-output(pin-name)
  method definition/add-node(definition/node) % add node to list of children 
  method definition/add-wire(definition/wire) % check sender and all receivers to be valid for node, add wire to routing table

  method query/valid-input? (pin-name) >> true/false
  method query/valid-output? (pin-name) >> true/false
  method query/busy? >> true/false

  method runtime/react % pull 1 event from input queue, perform reaction (which may produce 0 or more SENDs)
  method runtime/react-done
  method runtime/send(data) % create an output event, push it onto self.output-queue
  method runtime/distribute-outputs-atomically % distribute every output event to appropriate wires using routing table
  method runtime/distribute-event-from-child(e)

  }

class runtime/node-instance {
  method buildtime/instantiate
  method buildtime/set-kind(node)  % set the instance's kind
}

  
