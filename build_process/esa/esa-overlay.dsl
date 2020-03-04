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

  method query/get-sender >> node {
    return self.sender
    }

  method query/get-destinations >> list[(class/node n)] {
    return self.destinations.as-list
    }

  method runtime/distribute-event(runtime/event)
    foreach destination in self.destinations
      destination.lock
    end foreach
    foreach destintation in self.destinations
      let e = runtime/create-event(destination.node destination.pin) in
        destination.push-input(e)
      end let
    end foreach
    foreach destination in self.destinations
      destination.unlock
    end foreach
  }
  
class node {

  method definition/add-node(child-node) { % add node to list of children 
    self.children.append(child-node)
    }
    
  method definition/add-wire(wire) { % check sender and all receivers to be valid for node
    self.routing-table.append(wire)
    }

  method query/valid-input? (pin-name) >> true/false {
     if pin-name is a member of self.inputs {
       return true
     } else {
       return false
     }

  method query/valid-output? (pin-name) >> true/false
     if pin-name is a member of self.outputs {
       return true
     } else {
       return false
     }
  

  

