(in-package :arrowgrams/compiler)

(defstruct token
  kind
  position
  text
  (pulled-p nil))

