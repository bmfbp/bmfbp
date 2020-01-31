(in-package :arrowgrams/compiler/back-end)

(defparameter *json-emitter-rules*
"
= <schematic>
  <name> 
  <kind>
  <inputs>
  <outputs>
  <react>
  <first-time>
  <parts>

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
  :string
  :string
  :inputs <multiple-pins-with-indices> :end
  :outputs <muliple-pins-with-indices> :end

= <muliple-pins-with-indices>
  [ ?string
    <single-pin-with-indices>
  | ?symbol
    :symbol <symbol-must-be-nil>
  | !]

= <single-pin-with-indices>
    :string
      <wire-indices>
    :end

= <wire-indices>
  [ ?integer :integer
  | ! ]

"
)

(eval (sl:parse *json-emitter-rules* "-JSON-EMITTER"))
