(in-package :arrowgrams/compiler/back-end)

(defparameter *generic-emitter-pass2-rules*
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

= <inmap>
  :inmap
    <mapping>
  :end

= <mapping>
  [ ?string :string :integer <mapping>
  | ! ]

= <inputs>
  :inputs
  <list-of-strings>
  :end

= <outmap>
  :outmap
    <mapping>
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
  :integer
  <inmap>
  :inputs <multiple-pins-with-indices> :end
  :integer
  <outmap>
  :outputs <multiple-pins-with-indices> :end
  [ ?string <parts>
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

"
)

(eval (sl:parse *generic-emitter-pass2-rules* "-EMITTER-PASS2-GENERIC"))
