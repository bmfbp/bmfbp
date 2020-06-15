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
  script b
  script c
  script ddd
  script fff
  script ggg
  script hhh
  script iii
  script jjj
end when

script part-definition eeee
  let a = b in
    x
   @y
  end let
end script

script part-definition a
  map mapVarC = mapExprD in
    x
   @y
  end map
end script

script part-definition b
  set setVarV = SetVarExprW
end script

script part-definition c
  exit-map
end script

script part-definition ddd
  loop
    x
   @y
  end loop
end script

script part-definition fff
  loop
    x
   @y
   exit-when f
  end loop
end script

script part-definition ggg
  create kkk = kind in
    x
   @y
   exit-when f
  end create
end script

script part-definition hhh
  create kkk = *xyz in
    x
   @y
   exit-when f
  end create
end script

script part-definition iii
  if i then
   @y
  end if
end script

script part-definition jjj
  if j then
   @s
  else
   @u
  end if
end script
