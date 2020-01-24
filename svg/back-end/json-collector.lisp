(in-package :arrowgrams/compiler/back-end/json-collector)

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

(defclass parser (arrowgrams/compiler/back-end::parser)
  ((schematic-stack :accessor schematic-stack :initform (make-instance 'stack))
   (list-stack :accessor list-stack :initform (make-instance 'stack))
   (part-stack :accessor part-stack :initform (make-instance 'stack))
   (wire-stack :accessor wire-stack :initform (make-instance 'stack))
   (top-schematic :accessor top-schematic)
   (parts :initform (make-hash-table :test 'equal) :accessor parts)
   (wires :initform (make-hash-table) :accessor wires)))


(defparameter *rules*
"
= <ir> 
                          schematic-open
  :lpar
    <kind>                schematic-set-kind-from-string
    <inputs>              schematic-set-inputs-from-pin-list-pop
    <outputs>             schematic-set-outputs-from-pin-list-pop
    <react>               schematic-set-react-from-string
    <first-time>          schematic-set-first-time-from-string
    <part-declarations>   schematic-set-parts-from-part-stack-pop
    <wiring>              schematic-set-wiring-from-wire-stack-pop
  :rpar
                          schematic-close


= <inputs>
                                        list-open-new
  [ ?symbol :symbol symbol-must-be-nil  
  | ?lpar :lpar <pin-list> :rpar]       list-close

= <outputs>                             list-open-new
  [ ?symbol :symbol symbol-must-be-nil  
  | ?lpar :lpar <pin-list> :rpar]       list-close

= <part-declarations> 
  :lpar <part-decl-list> :rpar

= <wiring> 
  :lpar
    <wire-list>
  :rpar

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string                               list-add-string
  [ ?string <ident-list> ]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar <part-decl-list> ] | ! ]

= <part-decl>
                                        part-open-new
  :lpar
    <name>                              part-set-name
    <kind>                              part-set-kind
    <inputs>                            part-set-inputs-from-pin-list-pop
    <outputs>                           part-set-outputs-from-pin-list-pop
    <react>                             part-set-react
    <first-time>                        part-set-first-time
  :rpar           
                                        part-close-pop

= <name>
  :string

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <wire-list>
  <wire> [ ?lpar <wire-list> ] 

= <wire>
  :lpar
    :integer print-text
    :lpar <part-pin-list> :rpar
    :lpar <part-pin-list> :rpar
  :rpar

= <part-pin-list> 
  :lpar <part> <pin> :rpar 
  [ ?lpar <part-pin-list>]

= <part>
  :string
= <pin>
  :string
"
)

(eval
 (read-from-string
  (cl-ppcre:regex-replace-all "SL::" (cl:write-to-string (sl:parse *rules*)) "")))

;; parser support
(defmethod must-see ((p parser) token)   (arrowgrams/compiler/back-end:need p token))
(defmethod look-ahead ((p parser) token)   (arrowgrams/compiler/back-end:look-ahead-p p token))
(defmethod output ((p parser) str)   (arrowgrams/compiler/back-end:emit p str))
(defmethod need-nil-symbol ((p parser) str)   (arrowgrams/compiler/back-end:emit p str))
(defmethod call-external ((p parser) func)  (cl:apply func (list p)))
(defmethod call-rule ((p parser) func)  (cl:apply func (list p)))

;; proxies
(defmethod get-accepted-token-text ((self part))
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

(defmethod schematic-set-inputs-from-pin-list-pop ((self parser))
  (let ((list (stack-pop (list-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (inputs top-schem) list))))

(defmethod schematic-set-outputs-from-pin-list-pop ((self parser))
  (let ((list (stack-pop (list-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (inputs top-schem) list))))


(defmethod schematic-set-parts-from-part-stack-pop ((self parser))
  (let ((part (stack-pop (part-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (gethash (name part) (parts self))
            part))))

(defmethod schematic-set-wires-from-part-stack-pop ((self parser))
  (let ((part (stack-pop (part-stack self))))
    (let ((top-schem (stack-top (schematic-stack self))))
      (setf (gethash (name part) (parts self))
            part))))

(defmethod list-open-new ((self parser))
  (stack-push (list-stack self) nil))

(defmethod list-close ((self parser))
  ;; noop - leave TOP on stack
  )


(defmethod list-add-string ((self parser))
  (let ((str (get-accepted-token-text self)))
    (stack-push (list-stack self) str)))

(defmethod part-open-new ((self parser))
  (stack-push (part-stack self) (make-instance 'part)))

(defmethod part-close-pop ((self parser))
  (let ((part (stack-pop (part-stack self))))
    (setf (gethash (name part) (parts self))
          part)))

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

(defmethod part-set-inputs-from-pin-list ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (inputs top) (stack-pop (list-stack self)))))

(defmethod part-set-outputs-from-pin-list ((self parser))
  (let ((top (stack-top (part-stack self))))
    (setf (outputs top) (stack-pop (list-stack self)))))


