(in-pacakge :arrowgrams)

;======  class definition/part-pin ======

(defclass definition/part-pin () {
  ((part :accessor part :initarg :part)
   (pin  :accessor pin  :initarg :pin)))


;======  class definition/wire ======

(defclass definition/wire ()
  ((source :accessor source)
   (destinations :accessor destinations :initform nil)))

(defmethod definition/set-sender ((definition/wire self) (definition/node n) pin-name)
  (setf (source self) (make-instance 'definition/part-pin :part n :pin pin-name)))
  
(defmethod definition/add-destination ((definition/wire self) (definition/node n) pin-name)
  (push (destinations w) (make-instance 'part-pin :part n :pin pin-name)))

(defmethod query/get-sender ((definition/wire self))
  (source self))

(defmethod query/get-destinations ((definition/wire self))
  (destinations self))

  
;======  class runtime/wire ======

(defclass runtime/wire ()
  ((definition :accessor definition :initarg :definition)
   (source :accessor source)
   (destinations :accessor destinations)))

(defclass runtime/wire ()
  ((source :accessor source)
   (receivers :accessor receivers)))

(defmethod build/instantiate ((runtime/wire self) (definition/wire prototype))
(defmethod runtime/


