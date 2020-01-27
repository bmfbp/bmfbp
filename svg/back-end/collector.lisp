(in-package :arrowgrams/compiler/back-end/collector)

(defclass stack ()
  ((stack :initform nil :accessor stack)))

(defclass part ()
  ((name :accessor name :initarg :name)
   (kind :accessor kind)
   (inputs :accessor inputs)
   (outputs :accessor outputs)
   (react :accessor react)
   (first-time :accessor first-time)))  

(defclass schematic (part)
  ((parts :accessor parts)
   (wiring :accessor wiring)))

(defclass wire ()
  ((index :accessor index)
   (source-list :accessor source-list)
   (sink-list :accessor sink-list)))   

(defclass parser (arrowgrams/compiler/back-end::parser)
  ((schematic-stack :accessor schematic-stack :initform (make-instance 'stack))
   (queue-stack :accessor queue-stack :initform (make-instance 'stack))
   (table-stack :accessor table-stack :initform (make-instance 'stack))
   (wire-stack :accessor wire-stack :initform (make-instance 'stack))
   (part-stack :accessor part-stack :initform (make-instance 'stack))
   (top-schematic :accessor top-schematic)
   (parts :initform (make-hash-table :test 'equal) :accessor parts)
   (wires :initform (make-hash-table) :accessor wires)))


(defparameter *rules*
"
= <ir> 
                          schematic-open
  :lpar
    <kind>                schematic-set-kind-from-string
    <inputs>              schematic-set-inputs-from-list/pop-list
    <outputs>             schematic-set-outputs-from-list/pop-list
    <react>               schematic-set-react-from-string
    <first-time>          schematic-set-first-time-from-string

                          table-open-new
    <part-declarations>
                          schematic-set-parts-from-table/pop-table
                          table-open-new
    <wiring>
                          schematic-set-wiring-from-table/pop-table
  :rpar
                          schematic-close


= <inputs>
                                        queue-open-new
  [ ?symbol :symbol symbol-must-be-nil  
  | ?lpar :lpar <pin-list> :rpar]       queue-close

= <outputs>                             queue-open-new
  [ ?symbol :symbol symbol-must-be-nil  
  | ?lpar :lpar <pin-list> :rpar]       queue-close

= <part-declarations> 
  :lpar <part-decl-list> :rpar

= <wiring> 
  :lpar
    <wire-list>
  :rpar

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string                               queue-add-string
  [ ?string <ident-list> ]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar <part-decl-list> ] | ! ]

= <part-decl>
                                        part-open-new
  :lpar
    <name>                              part-set-name
    <kind>                              part-set-kind
    <inputs>                            part-set-inputs-from-list/pop-list
    <outputs>                           part-set-outputs-from-list/pop-list
    <react>                             part-set-react
    <first-time>                        part-set-first-time
  :rpar           
                                        part-add-to-table
                                        part-close/pop

= <name>
  :string

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <wire-list>
  <wire>                             queue-add-wire/pop-wire-stack
  [ ?lpar <wire-list> ] 

= <wire>
  :lpar                              wire-open-new
    :integer                         wire-set-index
                                     queue-open-new
    :lpar <part-pin-list> :rpar      wire-set-sources-from-list/pop-list
                                     queue-open-new
    :lpar <part-pin-list> :rpar      wire-set-sinks-from-list/pop-list
                                     wire-add-to-table
                                     wire-close/pop
  :rpar

= <part-pin-list> 
  :lpar <part> <pin> :rpar            
  [ ?lpar <part-pin-list>]

= <part>
  :string                             queue-add-string
= <pin>
  :string                             queue-add-string
"
)

(eval (sl:parse *rules*))


;; parser support
(defmethod must-see ((p parser) token)   (arrowgrams/compiler/back-end:need p token))
(defmethod look-ahead ((p parser) token)   (arrowgrams/compiler/back-end:look-ahead-p p token))
(defmethod output ((p parser) str)   (arrowgrams/compiler/back-end:emit p str))
(defmethod need-nil-symbol ((p parser) str)   (arrowgrams/compiler/back-end:emit p str))
(defmethod call-external ((p parser) func)  (cl:apply func (list p)))
(defmethod call-rule ((p parser) func)  (cl:apply func (list p)))

;; proxies
(defmethod get-accepted-token-text ((self parser))
  (arrowgrams/compiler/back-end:get-accepted-token-text self))

;; mechanisms used in *rules* above
(defmethod print-text ((p parser))
  (format (arrowgrams/compiler/back-end:output-stream p)
          "~a"
          (arrowgrams/compiler/back-end:token-text (arrowgrams/compiler/back-end:accepted-token p))))
(defmethod nl ((p parser))
  (format (arrowgrams/compiler/back-end:output-stream p) "~%"))

(defmethod symbol-must-be-nil ((p parser))
  (arrowgrams/compiler/back-end:accepted-symbol-must-be-nil p))

;; mechanisms

;; top level schematic

(defmethod stack-push ((self stack) item)
  (cl:push item (stack self)))

(defmethod stack-pop ((self stack))
  (cl:pop (stack self)))

(defmethod stack-top ((self stack))
  (first (stack self)))


(defmethod schematic-open ((self parser))
  (stack-push (schematic-stack self) (make-instance 'schematic :name "self")))

(defmethod schematic-set-kind-from-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top (stack-top (schematic-stack self))))
      (setf (kind top) str))))

(defmethod schematic-set-react-from-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top (stack-top (schematic-stack self))))
      (setf (react top) str))))

(defmethod schematic-set-first-time-from-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top (stack-top (schematic-stack self))))
      (setf (first-time top) str))))

(defmethod schematic-close ((self parser))
  (setf (top-schematic self)
        (stack-pop (schematic-stack self))))

(defmethod schematic-set-inputs-from-list/pop-list ((self parser))
  (let ((list (stack-pop (queue-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (inputs top-schem) list))))

(defmethod schematic-set-outputs-from-list/pop-list ((self parser))
  (let ((list (stack-pop (queue-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (outputs top-schem) list))))

(defmethod schematic-set-parts-from-table/pop-table ((self parser))
  (let ((table (stack-pop (table-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (parts top-schem) table))))

(defmethod schematic-set-wiring-from-table/pop-table ((self parser))
  (let ((table (stack-pop (table-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (wiring top-schem) table))))





;; list mechanism

(defmethod queue-open-new ((self parser))
  (stack-push (queue-stack self) nil))

(defmethod queue-close ((self parser))
  ;; noop - leave TOP on stack
  )

(defmethod queue-add-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (let ((top-list (stack-pop (queue-stack self))))
      (let ((result (if (null top-list)
                        (list str)
                      (append top-list (list str)))))
        (stack-push (queue-stack self) result)))))

(defmethod queue-add-wire/pop-wire-stack ((self parser))
  (let ((wire (stack-pop (wire-stack self))))
    (let ((top-list (stack-pop (queue-stack self))))
      (let ((result (if (null top-list)
                        (list wire)
                      (append top-list wire))))
        (stack-push (queue-stack self) result)))))

;; part mechanism

(defmethod part-open-new ((self parser))
  (stack-push (part-stack self) (make-instance 'part)))

(defmethod part-close/pop ((self parser))
  (stack-pop (part-stack self)))

(defmethod part-add-to-table ((self parser))
  (let ((part (stack-top (part-stack self))))
    (let ((top-table (stack-top (table-stack self))))
      (setf (gethash (name part) top-table)
            part))))

(defmethod part-set-name ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (name top) (get-accepted-token-text self))))

(defmethod part-set-kind ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (kind top) (get-accepted-token-text self))))

(defmethod part-set-react ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (react top) (get-accepted-token-text self))))

(defmethod part-set-first-time ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (first-time top) (get-accepted-token-text self))))

(defmethod part-set-inputs-from-list/pop-list ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (inputs top) (stack-pop (queue-stack self)))))

(defmethod part-set-outputs-from-list/pop-list ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (outputs top) (stack-pop (queue-stack self)))))


;; wire mechanism
(defmethod wire-open-new ((self parser))
  (stack-push (wire-stack self) (make-instance 'wire)))

(defmethod wire-close/pop ((self parser))
  ;; top-wire is finished
  (stack-pop (wire-stack self)))

(defmethod wire-add-to-table ((self parser))
  (let ((top-table (stack-top (table-stack self))))
    (let ((top-wire (stack-top (wire-stack self))))
      (setf (gethash (index top-wire) top-table)
            top-wire))))

(defmethod wire-set-index ((self parser))
  (let ((top-wire (stack-top (wire-stack self))))
    (setf (index top-wire) (cl:parse-integer (get-accepted-token-text self)))))

(defmethod wire-set-sources-from-list/pop-list ((self parser))
  (let ((top-wire (stack-top (wire-stack self))))
    (let ((list (stack-pop (queue-stack self))))
      (setf (source-list top-wire) list))))

(defmethod wire-set-sinks-from-list/pop-list ((self parser))
  (let ((top-wire (stack-top (wire-stack self))))
    (let ((list (stack-pop (queue-stack self))))
      (setf (sink-list top-wire) list))))

;; table
(defmethod table-open-new ((self parser))
  (stack-push (table-stack self) (make-hash-table :test 'equal)))

(defmethod table-pop ((self parser))
  (stack-pop (table-stack self)))