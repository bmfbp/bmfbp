(in-package :e/util)

;; error checks - debug only while we need to assemble diagrams by hand

(defmethod check-top-level-schematic-sanity ((self e/part:schematic))
  (check-part-sanity self))

(defmethod check-top-level-schematic-sanity ((self e/part:code))
  (error (format nil "top level part must be a schematic, but is a code part ~S" self)))

(defmethod check-part-sanity ((self e/part:code))
)

(defmethod check-part-sanity ((self e/part:schematic))
  (e/schematic::ensure-source-sanity self)
  (mapc #'check-part-sanity (e/part:internal-parts self)))



        