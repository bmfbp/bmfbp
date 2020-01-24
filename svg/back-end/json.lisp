(in-package :arrowgrams/compiler/back-end/json)

(defclass parser (arrowgrams/compiler/back-end::parser) ())

(defparameter *rules*
"
= <ir> 
  :lpar :string 'kindName : ' print-text nl
              'metaData : \"\"' nl
  'inputs : {' <inputs> <outputs> <react> <first-time> <part-declarations> <wiring> :rpar '}' nl


= <inputs> 
  'inputs : [' <pin-list> ']'

= <outputs> 
  'outputs : [' <pin-list> ']'

= <part-declarations> 
  :lpar '{' <part-decl-list> '}' :rpar

= <wiring> 
  :lpar 'wiring : {' <wire-list> '}' :rpar

= <pin-list> 
  [ ?symbol :symbol symbol-must-be-nil  | :lpar '{' <ident-list> '}' :rpar ]

= <ident-list> 
  :ident [ ?ident <ident-list>]

= <part-decl-list> 
  :lpar '{' <part-decl> '}' [ ?lpar ', ' <part-decl-list> ] :rpar

= <part-decl>
  <name> <kind> <inputs> <outputs> <react> <first-time>

= <name>
  :string print-text

= <kind>
  :string print-text

= <react>
  :string print-text

= <first-time>
  :string print-text

= <wire-list>
  :lpar 'wires : [' <wire> [ ?lpar ',' <wire-list> ] ']'

= <wire>
  :lpar '{ wire : ' :integer print-text :lpar <part-pin-list> :rpar :lpar <part-pin-list> :rpar ' }'

= <part-pin-list> 
  :lpar <part> <pin> :rpar 
  [ ?lpar <part-pin-list>]

= <part>
  :ident print-text
= <pin>
  :ident print-text
"
)

;; this contortion gets rid of SL:: qualifiers and then compiles the result in the current package ...

(eval (read-from-string (cl-ppcre:regex-replace-all "SL::" (cl:write-to-string (sl:parse *rules*)) "")))

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
