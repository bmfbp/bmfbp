
type name
situation building
class wire
  index
  map sources
  map destinations
end class

when building wire
  method install-source(name name)
  method install-destination(name name)
  script add-source(name name)
  script add-destination(name name)
end when

script wire add-source(part pin)
  self.install-source(part pin)
end script

script wire add-destination(part pin)
  self.install-destination(part pin)
end script

