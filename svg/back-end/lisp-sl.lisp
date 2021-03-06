(in-package :arrowgrams/compiler)

(eval-when (:compile-toplevel)

;; this version assumes that there is only one part with a given kind
;; and uses the kind as the part-name (whereas it should use a GENSYM or invented symbol)


  (defparameter *lisp-rules*
    "
= <ir> 
  :lpar                   '(' inc
    <top-name>
    <kind>                
    <metadata>
    <inputs>               nl
    <outputs>              nl
    <react> 
    <first-time> 
    <part-declarations> 
    <wiring>
                          ')' dec
  :rpar

= <top-name>
  :string                 print-text-as-symbol

= <inputs> 
  [ ?symbol :symbol symbol-must-be-nil  ' ()' | ?lpar :lpar inc ' (' <pin-list> :rpar dec ')']

= <outputs> 
  [ ?symbol :symbol symbol-must-be-nil ' ()' | ?lpar :lpar inc ' (' <pin-list> :rpar dec ')']

= <part-declarations> 
  :lpar nl <part-decl-list> :rpar

= <wiring> 
  :lpar                '\"' inc nl
    <wire-list>
  :rpar                '\"' dec

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string                 print-text-as-keyword-symbol
  [ ?string ' ' <ident-list>]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar <part-decl-list> ] | ! ]

= <part-decl>
  :lpar                  '(:code ' inc
  <name>                 memo-symbol
  <kind>                 print-text-as-symbol associate-kind-name-with-memo
  <inputs> 
  <outputs> 
  <react> 
  <first-time> 
  :rpar                   dec ')' nl

= <name>
  :string                

= <metadata>
  :string                nl ':metadata ' print-text-as-string nl nl

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
                                 ' -> '
    :lpar <part-pin-list> :rpar  
                                  nl
  :rpar

= <part-pin-list> 
  :lpar <part> <pin> :rpar 
  [ ?lpar ',' <part-pin-list> ]

= <part>
  :string                 print-kind-instead-of-symbol
= <pin>
  :string                 '.' print-text-as-symbol
"
    )

  (defmacro xxx () (sl:parse *lisp-rules* "-LISP")))

(xxx)
