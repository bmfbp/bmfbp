(in-package :arrowgrams)

(defclass definition/node ()
  ((input-pins :accessor input-pins :initform (empty-map))
   (output-pins :accessor output-pins :initform (empty-map))
   (parts :accessor parts :initform (empty-map))
   (wires :accessor wires :initform (empty-map))))
		

(defmethod install-input-pin ((self definition/node) (name name))
  (map-install (input-pins self) :key name))
   
(defmethod install-output-pin ((self definition/node) (name name))
  (map-install (output-pins self) :key name))

(defmethod install-wire ((self definition/node) (definition/wire w))
  (map-install (wires self) :key w))

(defmethod install-part ((self definition/node) (name name) (definition/node kind))
  (map-install (parts self) :key name :value kind))

