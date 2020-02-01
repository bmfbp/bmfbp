(in-package :arrowgrams/compiler/back-end)

(defparameter *json-emitter-rules*
"
= <schematic>
'{' nl
  <name>  '\"name\" : ' print-text ',' nl
  <kind>  '\"kind\" : ' print-text ',' nl
  <inputs>
  <outputs>
  <react>
  <first-time>
  '\"parts\" : {' inc nl
  <parts>
               dec nl '}' nl
'}'

= <name>
  :string

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <inputs>
  :inputs
  <list-of-strings>
  :end

= <outputs>
  :outputs
  <list-of-strings>
  :end

= <list-of-strings>
  [ ?string :string <list-of-strings>
  | ! ]

= <parts>
  '{' inc nl
  :string '\"partName\" : ' print-text ',' nl
  :string '\"kindName\" : ' print-text ',' nl
  :integer '\"inCount\" : ' print-text ',' nl
  :inputs <multiple-pins-with-indices> :end
  :integer '\"outCount\" : ' print-text ',' nl
  :outputs <multiple-pins-with-indices> :end
  [ ?string dec nl '},' nl <parts>
  | ! ]

= <multiple-pins-with-indices>
  [ ?string
    <single-pin-with-indices>
    <multiple-pins-with-indices>
  | ?symbol
    :symbol <symbol-must-be-nil>
  | ! ]

= <single-pin-with-indices>
    :string
      [ ?integer <wire-indices>
      | ! ]
    :end

= <wire-indices>
  [ ?integer :integer
  | ! ]

")

(eval (sl:parse *json-emitter-rules* "-JSON-EMITTER"))

