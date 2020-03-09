(in-package :arrowgrams/compiler)

(defstruct token
  kind
  text
  position
  line
  (pulled-p nil))

