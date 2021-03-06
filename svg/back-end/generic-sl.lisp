(in-package :arrowgrams/compiler)

(eval-when (:compile-toplevel)

  (defparameter *generic-rules*
    "
= <ir> 
  :lpar
    <top-name>
    <kind>
    <metadata>
    <inputs> 
    <outputs> 
    <react> 
    <first-time> 
    <part-declarations> 
    <wiring>
  :rpar

= <top-name>
  :string

= <inputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list> :rpar]

= <outputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list> :rpar]

= <part-declarations> 
  :lpar <part-decl-list> :rpar

= <wiring> 
  :lpar
    <wire-list>
  :rpar

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string [ ?string <ident-list>]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar <part-decl-list> ] | ! ]

= <part-decl>
  :lpar <name> <kind> <inputs> <outputs> <react> <first-time> :rpar

= <name>
  :string

= <metadata>
  [ ?symbol :symbol symbol-must-be-nil error-no-metadata | ?string :string ]

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
    :integer
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

  (defmacro xxx () (sl:parse *generic-rules* "-GENERIC")))

(xxx)
