%
% 4 sections:
% 1. Definition
% 2. Querying
% 3. pre-runtime
% 4. runtime
%
% 0. Dispatcher
%

system
  begin-atomic  % disable all interrupts (prevents deadlocks)
  end-atomic    % re-enable interrupts
end system

class wire { 
  % 1 sender per wire, 1 or more receivers per wire

  (node sender)
  (list[node-pin-pair] destinations)

  method defintion/set-sender(node n) {
    sender = n
    }
    
  method definition/add-destination(node input-pin) {
    let pair = create node-pin-pair(node input-pin) in
      destinations.add(pair)
    end let
  }

  method query/get-sender >> node {
    return self.sender
    }

  method query/get-destinations >> list[node-instance-pin-pair] {
    return self.destinations.as-list
    }

  % external method build/instantiate
  
  method runtime/distribute-event(runtime/event)
    begin-atomic
      foreach destination in self.destinations
        destination.lock
      end foreach
    end-atomic
    foreach destintation in self.destinations
      let e = create runtime/event(destination.node destination.pin) in
        destination.push-input(e)
      end let
    end foreach
    begin-atomic
      foreach destination in self.destinations
        destination.unlock
      end foreach
    end-atomic
  }
  
class node {

  method create >> node {
    let n new node in
      dispatcher.add-node(n)
    end let
  }

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
  

  

