Title: Intermediate Representation Basic  
Author: Paul Tarvydas

The first emitter phase emits an Intermediate Representation of a schematic: [*]


(
  kindName  ;; a kind of "class" name for this schematic
  parts-list
  wiring-list
  manifest
)


parts-list is:

( part-def, part-def, ... )

where part-def is:

(instance-name kindName input-list output-list)

where input/output-list is a list of pin names.


wiring-list is a list of wire:

(unique-name/index (...list-of-sources...) (...list-of-sinks...))

A source (or sink) is a part/pin pair:

(instance-name pin-name)
where instance-name is a part instance name or the keyword SELF (referring to a pin of the schematic)

Names are double-quoted strings, for example "abc".  KindNames are also double-quoted strings.

Manifest is currently undefined, but lets the runtime figure out where to fetch each part from.



[*] the second phase of the emitter parses the input from the first phase and emits JSON, CL, etc.
