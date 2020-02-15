
=kind
  get-input-pins
  get-output-pins
  busy?
  ready?
  new (parent input-pins output-pins)
  % list of inputs - namespace - each input name is different from every other input name
  % list of outputs - namespace - each output name is different from every other output name
  % same name may be used in inputs and output
  % ready? is true if input queue is non-empty, else false
  % "kind" is like "type" or "class"
  get-parent
  run-popping-one-input
  initially
  enqueue-input
  : input-queue
  : output-queue

=part inherits from kind
  get-kind


=schematic inherits from part
  (get-kind)
  get-parts
  new (input-pins output-pins parts wiring)
  get-wire (part pin)
  % schematic is busy if any child part is busy (recursive)
  % wiring is a list of double-lists ( (from) (from) ... -> (to) (to) ...) where from and to are part-name/pin-name pairs


=wire
  get-receivers 
  % receiver is (to), see above

=pin
  get-part
  get-name
  new (part name)

=event
  get-pin
  get-data
  
=Dispatcher
  : list-of-all-parts
  
  dispatch 
    loop
      foreach part in list-of-all-parts
        if part.ready? then
          part.run-popping-one-input
          break foreach
	end if
      end foreach
      release-output-queues
    end loop
  end
  
  release-output-queues
    loop
      foreach part in list-of-all-parts
        foreach out-event in part.get-output-queue
	  let parent = part.get-parent
            let wire = parent.get-wire (part out-event.pin)
              let data = out-event.data
                foreach receiver in wire.get-receivers
                  receiver.part.enqueue-input (receiver.pin data)
                end foreach
              end let
            end let
          end let
        end foreach
      end foreach
    end loop
  end
  
  start-dispatcher
    foreach part in list-of-all-parts
      part.initially
    end foreach
  end
