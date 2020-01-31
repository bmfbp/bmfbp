(in-package :arrowgrams/compiler/back-end)

(defparameter *json-emitter-rules*
"
= <reparse-schematic>
    <name>
    <kind>
    <reparse-inputs>
    <reparse-outputs>
    <react>
    <first-time>
    <reparse-parts>

= <name>       :string
= <kind>       :string
= <react>      :string
= <first-time> :string
  
= <reparse-inputs>
  :inputs <list-of-strings> :end
= <reparse-outputs>
  :inputs <list-of-strings> :end

= <list-of-strings>
  [ ?string :string <list-of-strings>
  | ]

= <reparse-parts>
  [ ?string <reparse-part>
  | ]

= <reparse-part>
  <name>
  <kind>
  :inputs :string <list-of-wire-indices> :end
  :outputs :sring <list-of-wire-indices> :end
  <react>
  <first-time>

= <list-of-wire-indices>
  [ ?integer :integer <list-of-inputs>
  | ]
"
)

(eval (sl:parse *json-emitter-rules* "-EMITTER-PASS2-GENERIC"))
