type name
type function
type boolean
type node-class

situation building
situation building-aux
situation loading
situation initializing
situation running

class part-definition
  part-name
  part-kind
end class

class named-part-instance
  instance-name
  instance-node
end class

class part-pin
  part-name
  pin-name
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
  self-class  % of type node-class % subsumes initially code, react code and instance vars (using OO), otherwise OO is overkill
  output-pins
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
  busy-flag
end class

class dispatcher
  map all-parts
  top-node
end class

class event
  partpin
  data
end class

%=== building kinds ===

when building part-definition
  method ensure-kind-defined	
  script eeee
  method m2
  script a
end when

script part-definition a
  x
  @y
end script
