(in-package :arrowgrams/compiler)

(eval-when (:compile-toplevel)

  (defparameter *lisp-rules*
    "
= <ir> 
  :lpar                   '(' inc
    <kind>                inc
    <metadata>
    <inputs> 
    <outputs> 
    <react> 
    <first-time> 
    <part-declarations> 
    <wiring>
                          ')' dec
  :rpar


= <inputs> 
  [ ?symbol :symbol symbol-must-be-nil  '()' | ?lpar :lpar inc '(' <pin-list> :rpar dec ')']

= <outputs> 
  [ ?symbol :symbol symbol-must-be-nil '()' | ?lpar :lpar inc '(' <pin-list> :rpar dec ')']

= <part-declarations> 
  :lpar <part-decl-list> :rpar

= <wiring> 
  :lpar                '\"' inc
    <wire-list>
  :rpar                '\"' dec

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string [ ?string <ident-list>]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar <part-decl-list> ] | ! ]

= <part-decl>
  :lpar                  '(' inc
  <name>
  <kind>
  <inputs> 
  <outputs> 
  <react> 
  <first-time> 
  :rpar                   dec ')' nl

= <name>
  :string                print-text

= <metadata>
  :string                ':metadata ' print-text ' '

= <kind>
  :string                ':kind ' print-text ' '

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
                          nl
  :rpar

= <part-pin-list> 
  :lpar <part> <pin> :rpar 
  [ ?lpar <part-pin-list> ', ' ]

= <part>
  :string                 print-text
= <pin>
  :string                 '.' print-text
"
    )

  (defmacro xxx () (sl:parse *lisp-rules* "-LISP")))

(xxx)
