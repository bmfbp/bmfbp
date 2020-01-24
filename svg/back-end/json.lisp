(in-package :arrowgrams/compiler/back-end/json)

(defclass parser (arrowgrams/compiler/back-end::parser) ())

(defparameter *rules*
"
= <ir> 
  :lpar
    :string 'kindName : ' print-text nl
            'metaData : \"\"' nl
    '{' inc nl <inputs> ',' nl <outputs> ',' nl <react> ',' nl <first-time> ',' nl <child-part-declarations> ',' nl <wiring> dec nl '}'
  :rpar


= <inputs>
  '\"inputs\" : ['
    [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list> :rpar]
  ']'

= <outputs> 
  '\"outputs\" : ['
    [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list> :rpar]
  ']'

= <child-part-declarations> 
  :lpar inc
    '\"parts\" : [' nl
      <part-decl-list> 
    nl ']'
  :rpar dec

= <wiring> 
  :lpar inc
    '\"wiring\" : {' <wire-list> '}'
  :rpar dec

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string print-text [ ?string ',' <ident-list>]

= <part-decl-list> 
  [ ?lpar <part-decl>  [ ?lpar ',' <part-decl-list> ] | ! ]

= <part-decl>
  '{' inc nl
    :lpar <name> ',' nl <kind> ',' nl <inputs> ',' nl <outputs> ',' nl <react> ',' nl <first-time> :rpar
   dec nl '}'

= <name>
  :string '\"name\" :' print-text

= <kind>
  :string '\"kind\" : ' print-text

= <react>
  '\"react\" : ' :string print-text

= <first-time>
  '\"firstTime\" : ':string print-text

= <wire-list>
  <wire> [ ?lpar ',' nl <wire-list> ] 

= <wire>
  inc '{ wire : '
  :lpar 
    :integer print-text ', '
    :lpar <part-pin-list> :rpar ','
    :lpar <part-pin-list> :rpar
  :rpar
  dec '}'

= <part-pin-list> 
  '{'
      :lpar <part> ',' <pin> :rpar 
  '}'
  [ ?lpar ',' <part-pin-list>]

= <part>
  :string '\"part\" : ' print-text
= <pin>
  :string '\"pin\" : ' print-text
"
)

;; this contortion gets rid of SL:: qualifiers and then compiles the result in the current package ...

(defparameter *parsed* (read-from-string (cl-ppcre:regex-replace-all "SL::" (cl:write-to-string (sl:parse *rules*)) "")))
(eval *parsed*)

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

(defmethod symbol-must-be-nil ((p parser))
  (arrowgrams/compiler/back-end:accepted-symbol-must-be-nil p))

(defmethod stop-here ((p parser))
  (format *standard-output* "p is ~A~%" p)
)

(defmethod inc ((p parser)) (arrowgrams/compiler/back-end::inc p))
(defmethod dec ((p parser)) (arrowgrams/compiler/back-end::dec p))
(defmethod nl ((p parser)) (arrowgrams/compiler/back-end::nl p))
