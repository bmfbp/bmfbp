(in-package :rephrase)

(defstruct token
  kind
  text
  position
  line
  (pulled-p nil))

