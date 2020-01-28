(in-package :arrowgrams/compiler/back-end)

(defmethod unparse-schematic ((p parser) schem)
  (emit-string p (slot-value schem 'name))
  (emit-string p (slot-value schem 'kind))
  (unparse-inputs p (slot-value schem 'inputs))
  (unparse-outputs p (slot-value schem 'outputs))
  (emit-string p (slot-value schem 'react))
  (emit-string p (slot-value schem 'first-time))
  (unparse-parts  p (slot-value schem 'parts) (slot-value schem 'wiring)))

(defmethod unparse-inputs ((p parser) string-collection)
  (emit-token p :inputs)
  (dolist (str (as-list string-collection))
    (emit-string p str))
  (emit-token p :end))

(defmethod unparse-outputs ((p parser) string-collection)
  (emit-token p :outputs)
  (dolist (str (as-list string-collection))
    (emit-string p str))
  (emit-token p :end))

(defmethod unparse-parts ((p parser) parts-table wiring-table)
  (maphash #'(lambda (part-name part-data)
               (unparse-part p part-name part-data wiring-table))
           parts-table))

(defmethod unparse-part ((p parser) part-name part-data wiring-table)
  (emit-token p :inputs)
  (dolist (pin-name (as-list (inputs part-data)))
    (unparse-input-pin p pin-name part-name wiring-table))
  (emit-token p :end)
  (emit-token p :outputs)
  (dolist (pin-name (as-list (outputs part-data)))
    (unparse-output-pin p pin-name part-name wiring-table))
  (emit-token p :end))


;%   emit :inputs (foreach wire ...) :end
;%   if pin has no wires, then emit :string name :end
;%   if pin has 1 wire,   then emit :string name :integer nnn :end
;%   if pin has multiple wires, emit multiple {:integer nnn} pairs

(defmethod unparse-input-pin ((p parser) pin-name part-name wiring-table)
  (emit-string p pin-name)
  (let ((wire-list (lookup-part-pin-in-sinks p wiring-table part-name pin-name)))
    (dolist (wire wire-list)
      (emit-integer wire)))
  (emit-token p :end))

(defmethod unparse-output-pin ((p parser) pin-name part-name wiring-table)
  (emit-string p pin-name)
  (let ((wire-list (lookup-part-pin-in-sources p wiring-table part-name pin-name)))
    (dolist (wire wire-list)
      (emit-integer p wire)))
  (emit-token p :end))

