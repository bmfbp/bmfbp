(in-package :arrowgrams/compiler/back-end/generic)

(defclass parser (arrowgrams/compiler/back-end::parser) ())

(defparameter *rules*
"
= <ir> 
  :lpar
    <kind>
    <inputs> 
    <outputs> 
    <react> 
    <first-time> 
    <part-declarations> 
    <wiring>
  :rpar


= <inputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar 'inputs : [' <pin-list> ']' :rpar]

= <outputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar 'outputs : [' <pin-list> ']' :rpar]

= <part-declarations> 
  :lpar '{' <part-decl-list> '}' :rpar

= <wiring> 
  :lpar
    'wiring : {' <wire-list> '}'
  :rpar

= <pin-list> 
  '{' <ident-list> '}'

= <ident-list> 
  :string [ ?string <ident-list>]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar <part-decl-list> ] | ! ]

= <part-decl>
  :lpar <name> <kind> <inputs> <outputs> <react> <first-time> :rpar

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

;; mechanisms used in *rules* above
(defmethod print-text ((p parser))
  (format (arrowgrams/compiler/back-end:output-stream p)
          "~a"
          (arrowgrams/compiler/back-end:token-text (arrowgrams/compiler/back-end:accepted-token p))))
(defmethod nl ((p parser))
  (format (arrowgrams/compiler/back-end:output-stream p) "~%"))

(defmethod symbol-must-be-nil ((p parser))
  (arrowgrams/compiler/back-end:accepted-symbol-must-be-nil p))

(defmethod stop-here ((p parser))
  (format *standard-output* "p is ~A~%" p)
)
