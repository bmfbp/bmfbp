Part passes
[fb step]
[request-fb add-fact done-step error retract-fact finiahed-pipeline]
[
  find-comments
  find-metadata
  add-kinds
  add-self-ports
  make-unknown-port-names
  create-centers
  calculate-distances
  assign-portnames
  mark-indexed-ports
  coincident-ports
  mark-directions
  match-ports-to-components
  sem-parts-have-some-ports
  sem-ports-have-sink-or-source
  sem-no-duplicate-kinds
  sem-speech-vs-comments
  assign-wire-number-to-edges
  self-input-pins
  self-output-pins
  input-pins
  output-pins

  ellipse-bounding-boxes [fb go] [request-fb add-fact done error]
  