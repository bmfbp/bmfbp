(in-package :arrowgrams/compiler/back-end)

(defstruct token
  kind
  position
  text
  (special :nil))

