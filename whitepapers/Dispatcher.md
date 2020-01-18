Title: Dispatcher  
Author: Paul Tarvydas

Dispatcher {
  run all first-time functions.
  dispatch output queues, if any.
  loop 
    exit when all parts have empty input queues
    for some part, p, that is ready
       e <- dequeue event from p’s input queue
       call react(p,e)
       dispatch output queues
    end for 
  end loop
}

Dispatch output queues {
  loop
    exit when all parts have empty output queues
    p <- any part with non-empty output queue
    loop
      exit when p has empty output queue
      schem <- p’s parent
      e <- dequeue p’s output queue
      source <- {p,e.pin}
      receivers <- lookup source in schem’s receiver bag
      (receivers is used 3 times)
      lock input queues of all receivers
      loop
        exit when receivers is empty
        receiver {part,inpuPin} <- pop from receivers
        newEvent <- map e.outputPin to inputPin
        push newEvent onto receiver’s input queue
      end loop
      unlock input queues of all receivers
    end loop
}
N.B. lock/unlock needed only in bare metal and multi-thread versions.

Send(self : part, e : Event) {
  push e onto output queue of part
}