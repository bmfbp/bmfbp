(in-package :arrowgrams)

;; input events can only appear on the input queue of a part, in that case, the pin field refers to the receiving part
;; output events can only appear on the output queue of a prt, in that case, the pin field refers to the sending part

(defclass runtime/event ()
  ((pin :accessor pin :initarg :pin)  
   (data :accessor data :initarg :data)))

