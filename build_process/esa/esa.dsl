%
% 4 section:
% 1. Definition
% 2. Querying
% 3. pre-runtime
% 4. runtime
%
% 0. Dispatcher
%


class wire { 
  % 1 sender per wire, 1 or more receivers per wire
	      
  method defintion/set-sender(node output-pin)
  method definition/add-destination(node input-pin)

  method query/get-sender >> node

  method query/get-destinations >> list[(class/node n)]

  method runtime/distribute-event(runtime/event)

  }
  
class node {

  method definiton/create
  
  method definition/add-input(pin-name) % add name to self.inputs, check that all input names are unique
  method definition/add-output(pin-name)
  method definition/add-node(child-node) % add node to list of children 
  method definition/add-wire(wire) % check sender and all receivers to be valid for node, add wire to routing table

  method query/valid-input? (pin-name) >> true/false
  method query/valid-output? (pin-name) >> true/false
  method query/busy? >> true/false

  method runtime/react % pull 1 event from input queue, perform reaction (which may produce 0 or more SENDs)
  method runtime/react-done
  method runtime/send(data) % create an output event, push it onto self.output-queue
  method runtime/distribute-outputs % distribute every output event to appropriate wires using routing table
  method runtime/distribute-event-from-child(e)

  }

class node-instance {
  method buildtime/create

  method buildtime/set-kind((class/node n))  % set the instance's kind
  
  
