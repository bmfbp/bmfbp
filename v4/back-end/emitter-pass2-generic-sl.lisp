(in-package :arrowgrams/compiler)

(eval-when (:compile-toplevel)

  (defparameter *generic-emitter-pass2-rules*
    "
= <schematic>
' generic ' nl
  <top-name> 
  <kind>
  <metadata>
  <top-level-inputs>
  <top-level-outputs>
  <react>
  <first-time>
  :integer
  <parts>

= <top-name>
  :string

= <metadata>
  [ ?symbol :symbol symbol-must-be-nil
  | ?string :string 
  ]

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <top-level-inputs>
  :inputs
  <top-level-list-of-strings>
  :end

= <top-level-outputs>
  :outputs
  <top-level-list-of-strings>
  :end

= <top-level-list-of-strings>
  [ ?string :string <top-level-list-of-strings>
  | ! ]



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
  <incount>
  <inmap>
  :inputs <multiple-pins-with-indices> :end
  <outcount>
  <outmap>
  :outputs <multiple-pins-with-indices> :end
  [ ?string <parts>
  | ! ]

= <incount>
  :integer
= <outcount>
  :integer
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
  [ ?integer :integer <wire-indices>
  | ! ]

"
    )

 (defmacro xxx () (sl:parse *generic-emitter-pass2-rules* "-EMITTER-PASS2-GENERIC")))

(xxx)

(sl:parse *generic-emitter-pass2-rules* "-EMITTER-PASS2-GENERIC")
