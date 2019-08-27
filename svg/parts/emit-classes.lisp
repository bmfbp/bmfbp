(defclass part-descriptor-class ()
  ((sinks :accessor sinks :initform (new-string-hashmap))
   (sources :accessor sources :initform (new-string-hashmap))
   (id :accessor id :initform nil)))
