(in-package :arrowgrams/compiler/back-end)

(defstruct token
  kind
  position
  text
  (pulled-p nil))

