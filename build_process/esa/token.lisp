(in-package :arrowgrams/esa)

(defstruct token
  kind
  text
  position
  line
  (pulled-p nil))

