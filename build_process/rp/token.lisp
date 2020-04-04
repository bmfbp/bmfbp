(in-package :arrowgrams/rp)

(defstruct token
  kind
  text
  position
  line
  (pulled-p nil))

