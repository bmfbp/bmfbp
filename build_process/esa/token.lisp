(in-package :arrowgrams/build)

(defstruct token
  kind
  text
  position
  line
  (pulled-p nil))

