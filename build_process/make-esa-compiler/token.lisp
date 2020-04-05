(in-package :arrowgrams/make-esa-compiler)

(defstruct token
  kind
  text
  position
  line
  (pulled-p nil))

