(in-package :arrowgrams/compiler)

(eval-when (:compile-toplevel)

;; this version assumes that there is only one part with a given kind
;; and uses the kind as the part-name (whereas it should use a GENSYM or invented symbol)


  (defparameter *json1-rules*
    "
= <ir> 
  :lpar                   
                          '{' inc nl '\"name\" : '
    <top-name>
                          ',' nl
    <kind>                
    <metadata>
                          '\"inputs\" : ['
    <toplevel-inputs>
                          '],' nl
                          '\"outputs\" : ['
    <toplevel-outputs>
                          '],' nl
    <react> 
    <first-time>
    <part-declarations> 
    <wiring>
                          nl dec '}'
  :rpar

= <top-name>
  :string                 print-text

= <toplevel-inputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar inc <pin-list> :rpar dec]

= <toplevel-outputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar inc <pin-list> :rpar dec]

= <part-declarations> 
  :lpar
                       '\"parts\" :' nl '[' inc nl
  <part-decl-list>
  :rpar 
                       dec nl '],'

= <inputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list> :rpar]

= <outputs> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list> :rpar]

= <wiring> 
  :lpar                nl '\"wiring\" :' inc nl inc
                            '[' nl
    <wire-list>
  :rpar                dec nl ']' dec

= <pin-list> 
  <ident-list>

= <ident-list> 
  :string                 '\"' print-text-as-symbol '\"'
  [ ?string ', ' <ident-list>]

= <part-decl-list> 
  [ ?lpar <part-decl> [ ?lpar ',' nl <part-decl-list> ] | ! ]

= <part-decl>
  :lpar                  
                         '{ \"partName\" : '
  <name>                 memo-symbol
  <kind>
                         '\"' print-text-as-symbol '\",' associate-kind-name-with-memo
                         ' \"kindName\" : \"' print-text-as-symbol '\"}'
  <inputs-for-part-decl> 
  <outputs-for-part-decl> 
  <react> 
  <first-time> 
  :rpar                   

= <inputs-for-part-decl> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list-for-part-decl> :rpar]

= <outputs-for-part-decl> 
  [ ?symbol :symbol symbol-must-be-nil | ?lpar :lpar <pin-list-for-part-decl> :rpar]

= <pin-list-for-part-decl> 
  <ident-list-for-part-decl>

= <ident-list-for-part-decl> 
  :string
  [ ?string <ident-list-for-part-decl>]

= <name>
  :string                

= <metadata>
  [ ?symbol :symbol symbol-must-be-nil | ?string :string ]

= <kind>
  :string

= <react>
  :string

= <first-time>
  :string

= <wire-list>
  '{' <wire> '}'
  [ ?lpar ',' nl <wire-list> ]
  

= <wire>
  :lpar
    :integer  '\"wire-index\" : ' print-text 
    :lpar ', \"sources\" : [' <part-pin-list> :rpar ']'
                         
    :lpar ', \"receivers\" : [' <part-pin-list> :rpar ']'  
  :rpar

= <part-pin-list> 
  :lpar 
                       '{\"part\" : \"' 
  <part>
                       '\", \"pin\" : \"'
  <pin> 
  :rpar 
                       '\"}'
  [ ?lpar ',' <part-pin-list> ]

= <part>
  :string                 print-kind-instead-of-symbol
= <pin>
  :string                 print-text-as-symbol
"
    )

  (defmacro xxx4 () (sl:parse *json1-rules* "-JSON1")))

(xxx4)

(sl:parse *json1-rules* "-JSON1")
