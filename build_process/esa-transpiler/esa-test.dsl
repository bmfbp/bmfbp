
type name

situation running

class node
  input-queue
  output-queue
  kind-field
  container
  name-in-container  %% lookup this part instance by name as a child of my container
  children
  busy-flag
end class

when running node
  method has-inputs-or-outputs? >> boolean
  method children? >> boolean
  method flagged-as-busy? >> boolean
  method dequeue-input
  method input-queue?
  method enqueue-input(event)
  method enqueue-output(event)
  method react(event)
  script run-composite-reaction(event)
  method node-find-child(name) >> named-part-instance
end when

script node run-composite-reaction(e)
  x
  x.y
  x.y(a b)
  self.container.kind-field.find-wire-for-source(e.partpin.part-name e.partpin.pin-name)
end script
