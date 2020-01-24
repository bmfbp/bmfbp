(in-package :arrowgrams/compiler/back-end/generic)

(defclass parser (arrowgrams/compiler/back-end::parser) ())

(defparameter *rules* 
"= <ir> 
  :lpar :string <inputs> <outputs> <react> <first-time> <part-declarations> <wiring> :rpar

= <inputs> 
  <pin-list>

= <outputs> 
  <pin-list>

= <part-declarations> 
  :lpar <part-decl-list> :rpar

= <wiring> 
  :lpar <wire-list> :rpar

= <pin-list> 
  [ :symbol symbol-must-be-nil  | :lpar <ident-list> :rpar ]

= <ident-list> 
  :ident [ ?ident <ident-list>]

= <part-decl-list> 
  :lpar <part-decl> [ ?lpar  <part-decl-list> ] :rpar

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
  :lpar <wire> [ ?lpar <wire-list> ]

= <wire>
  :lpar :integer print-text :lpar <part-pin-list> :rpar :lpar <part-pin-list> :rpar

= <part-pin-list> 
  :lpar <part> <pin> :rpar 
  [ ?lpar <part-pin-list>]

= <part>
  :ident print-text
= <pin>
  :ident print-text
")

(eval
 (read-from-string
  (cl-ppcre:regex-replace-all "SL::" (cl:write-to-string (sl:parse *rules*)) "")))
